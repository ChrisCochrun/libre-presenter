#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QUrl>
#include <QSql>
#include <QDebug>
#include <KLocalizedContext>
#include <KLocalizedString>
#include <KAboutData>
// #include <KWindowSystem>
#include <iostream>
#include <QQmlEngine>
#include <QtSql>
#include <QSqlDatabase>
#include <QSqlTableModel>
#include <QtWebEngine>

#include <QObject>
#include <QtGlobal>
#include <QOpenGLContext>
#include <QGuiApplication>
#include <QQuickStyle>
#include <QSurfaceFormat>

#include <QtGui/QOpenGLFramebufferObject>

#include <QtQuick/QQuickWindow>
#include <QtQuick/QQuickView>
#include <qapplication.h>
#include <qcoreapplication.h>
#include <qdir.h>
#include <qglobal.h>
#include <qguiapplication.h>
#include <qqml.h>
#include <qquickstyle.h>
#include <qsqldatabase.h>
#include <qsqlquery.h>
#include <qstringliteral.h>

#include "cpp/mpv/mpvobject.h"
#include "cpp/serviceitemmodel.h"
#include "cpp/slidemodel.h"
#include "cpp/songsqlmodel.h"
#include "cpp/videosqlmodel.h"
#include "cpp/imagesqlmodel.h"
#include "cpp/presentationsqlmodel.h"
#include "cpp/filemanager.h"
#include "cpp/slideobject.h"

// RUST
// #include "cxx-qt-gen/my_object.cxxqt.h"
#include "cxx-qt-gen/service_thing.cxxqt.h"
#include "cxx-qt-gen/file_helper.cxxqt.h"
#include "cxx-qt-gen/slide_obj.cxxqt.h"
#include "cxx-qt-gen/slide_model.cxxqt.h"
#include "cxx-qt-gen/settings.cxxqt.h"
#include "cxx-qt-gen/ytdl.cxxqt.h"
// #include "cxx-qt-gen/image_model.cxxqt.h"

static QWindow *windowFromEngine(QQmlApplicationEngine *engine)
{
    const auto rootObjects = engine->rootObjects();
    auto *window = qobject_cast<QQuickWindow *>(rootObjects.first());
    Q_ASSERT(window);
    return window;
}

static void connectToDatabase() {
  // let's setup our sql database
  QSqlDatabase db = QSqlDatabase::database();
  if (!db.isValid()){
    db = QSqlDatabase::addDatabase("QSQLITE");
    if (!db.isValid())
      qFatal("Cannot add database: %s", qPrintable(db.lastError().text()));
  }

  const QDir writeDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
  qDebug() << "dir location " << writeDir.absolutePath();

  if (!writeDir.mkpath(".")) {
    qFatal("Failed to create writable location at %s", qPrintable(writeDir.absolutePath()));
  }

  const QString dbName = writeDir.absolutePath() + "/library-db.sqlite3";

  db.setHostName("localhost");
  db.setDatabaseName(dbName);
  db.setUserName("presenter");
  // TODO change password system before launch
  db.setPassword("i393jkf782djyr98302j");
  if (!db.open()) {
    qFatal("Cannot open database: %s", qPrintable(db.lastError().text()));
    QFile::remove(dbName);
  }

}

int main(int argc, char *argv[])
{
  // qDebug() << QSurfaceFormat::defaultFormat();
  QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
  QGuiApplication::setWindowIcon(QIcon::fromTheme(QStringLiteral("video-display")));
  QtWebEngine::initialize();
  QGuiApplication app(argc, argv);
  KLocalizedString::setApplicationDomain("librepresenter");
  KAboutData aboutData("librepresenter", i18n("Libre Presenter"), "0.1",
                       i18n("A church presentation app built with KDE tech."),
                       KAboutLicense::GPL_V3,
                       i18n("Copyright 2017 Bar Foundation"), QString(),
                       "https://www.foo-the-app.net");
  // overwrite default-generated values of organizationDomain & desktopFileName
  aboutData.setOrganizationDomain("tfcconnection.org");
  aboutData.setDesktopFileName("org.tfcconnection.librepresenter");
 
  // set the application metadata
  KAboutData::setApplicationData(aboutData);
  QCoreApplication::setOrganizationName(QStringLiteral("librepresenter"));
  QCoreApplication::setOrganizationDomain(QStringLiteral("tfcconnection.org"));
  QCoreApplication::setApplicationName(QStringLiteral("Libre Presenter"));
  // qSetMessagePattern("[%{type} %{time h:m:s ap}: %{function} in %{file}]: %{message}\n");

#ifdef Q_OS_WINDOWS
  QIcon::setFallbackThemeName("breeze");
  QQuickStyle::setStyle(QStringLiteral("org.kde.breeze"));
  // QApplication::setStyle(QStringLiteral("breeze"));
#else
  QIcon::setFallbackThemeName("breeze");
  QQuickStyle::setStyle(QStringLiteral("org.kde.desktop"));
  QQuickStyle::setFallbackStyle(QStringLiteral("Default"));
#endif

  qDebug() << QQuickStyle::availableStyles();
  qDebug() << QIcon::themeName();
  qDebug() << QApplication::platformName();

  // integrate with commandline argument handling
  // QCommandLineParser parser;
  // aboutData.setupCommandLine(&parser);
  // setup of app specific commandline args

  //Need to instantiate our slide
  QScopedPointer<SlideModel> slideModel(new SlideModel);
  QScopedPointer<SlideyMod> slideMod(new SlideyMod);
  QScopedPointer<File> filemanager(new File);
  // QScopedPointer<QQuickView> preswin(new QQuickView);
  QScopedPointer<ServiceItemModel> serviceItemModel(new ServiceItemModel);
  QScopedPointer<SlideObj> slideobject(new SlideObj);

  Settings *settings = new Settings;
  settings->setup();
  // preswin->setSource(QUrl(QStringLiteral("qrc:qml/presenter/PresentationWindow.qml")));

  QObject::connect(serviceItemModel.get(),
                   SIGNAL(itemInserted(const int&, const ServiceItem&)),
                   slideModel.get(),
                   SLOT(insertItemFromService(const int&, const ServiceItem&)));
  QObject::connect(serviceItemModel.get(),
                   SIGNAL(itemAdded(const int&, const ServiceItem&)),
                   slideModel.get(),
                   SLOT(addItemFromService(const int&, const ServiceItem&)));
  QObject::connect(serviceItemModel.get(),
                   &ServiceItemModel::itemAddedRust,
                   slideMod.get(),
                   &SlideyMod::addItemFromService);
  QObject::connect(serviceItemModel.get(),
                   &ServiceItemModel::itemInsertedRust,
                   slideMod.get(),
                   &SlideyMod::insertItemFromService);
  QObject::connect(serviceItemModel.get(),
                   &ServiceItemModel::rowMovedRust,
                   slideMod.get(),
                   &SlideyMod::moveItemFromService);
  QObject::connect(serviceItemModel.get(),
                   &ServiceItemModel::rowRemovedRust,
                   slideMod.get(),
                   &SlideyMod::removeItemFromService);
  // QObject::connect(serviceItemModel.get(),
  //                  SIGNAL(allRemoved()),
  //                  slideMod.get(),
  //                  SLOT(clear()));
  QObject::connect(slideobject.get(),
                   SIGNAL(slideChanged(int)),
                   slideMod.get(),
                   SLOT(activate(int)));

  if (!serviceItemModel.get()->loadLastSaved()) {
    qDebug() << "Last saved file is missing or there isn't a last saved file.";
    serviceItemModel.get()->addItem("Black", "image",
                                    "qrc:/assets/black.jpg",
                                    "image", QStringList(""),
                                    "", "", 0, 1, false);
  }

  // apparently mpv needs this class set
  // let's register mpv as well
  std::setlocale(LC_NUMERIC, "C");
  qmlRegisterType<MpvObject>("mpv", 1, 0, "MpvObject");

  //register our models
  qmlRegisterType<SongProxyModel>("org.presenter", 1, 0, "SongProxyModel");
  qmlRegisterType<VideoProxyModel>("org.presenter", 1, 0, "VideoProxyModel");
  qmlRegisterType<ImageProxyModel>("org.presenter", 1, 0, "ImageProxyModel");
  qmlRegisterType<PresentationProxyModel>("org.presenter", 1, 0, "PresentationProxyModel");
  qmlRegisterType<SongSqlModel>("org.presenter", 1, 0, "SongSqlModel");
  qmlRegisterType<VideoSqlModel>("org.presenter", 1, 0, "VideoSqlModel");
  qmlRegisterType<ImageSqlModel>("org.presenter", 1, 0, "ImageSqlModel");
  qmlRegisterType<PresentationSqlModel>("org.presenter", 1, 0, "PresentationSqlModel");
  qmlRegisterType<FileHelper>("org.presenter", 1, 0, "FileHelper");
  qmlRegisterType<Ytdl>("org.presenter", 1, 0, "Ytdl");
  qmlRegisterType<ServiceThing>("org.presenter", 1, 0, "ServiceThing");
  qmlRegisterType<SlideObject>("org.presenter", 1, 0, "SlideHelper");
  qmlRegisterSingletonInstance("org.presenter", 1, 0,
                               "ServiceItemModel", serviceItemModel.get());
  qmlRegisterSingletonInstance("org.presenter", 1, 0, "SlideModel", slideModel.get());
  qmlRegisterSingletonInstance("org.presenter", 1, 0, "SlideMod", slideMod.get());
  qmlRegisterSingletonInstance("org.presenter", 1, 0, "SlideObject", slideobject.get());
  qmlRegisterSingletonInstance("org.presenter", 1, 0, "FileManager", filemanager.get());
  // qmlRegisterSingletonInstance("org.presenter", 1, 0, "PresWindow", preswin.get());

  connectToDatabase();

  QQmlApplicationEngine engine;

  engine.rootContext()->setContextObject(new KLocalizedContext(&engine));
  engine.load(QUrl(QStringLiteral("qrc:qml/main.qml")));

  qDebug() << app.topLevelWindows();
  qDebug() << app.allWindows();
  // QQuickView *view = new QQuickView;
  // view->setSource(QUrl(QStringLiteral("qrc:qml/main.qml")));
  // view->show();
#ifdef STATIC_KIRIGAMI
  KirigamiPlugin::getInstance().registerTypes();
#endif

  if (engine.rootObjects().isEmpty()) {
    return -1;
  }

  QWindow *window = windowFromEngine(&engine);
  QQuickWindow *PresWindow = new QQuickWindow;
  qDebug() << PresWindow;
  PresWindow->create();
  PresWindow->setVisible(true);
  qDebug() << PresWindow->isVisible();

  window->setIcon(QIcon::fromTheme(QStringLiteral("system-config-display")));
  // KWindowSystem::setMainWindow(window);
  // KWindowSystem::activateWindow(window);
  // qDebug() << "00000000000000000000000000000000";
  // qDebug() << KWindowSystem::isPlatformWayland();
  // qDebug() << KWindowSystem::windows();
  // qDebug() << "00000000000000000000000000000000";


  return app.exec();
}

