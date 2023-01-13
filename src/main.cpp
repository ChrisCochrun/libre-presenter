#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QUrl>
#include <QSql>
#include <QDebug>
#include <KLocalizedContext>
#include <KLocalizedString>
#include <KAboutData>
#include <KWindowSystem>
#include <iostream>
#include <QQmlEngine>
#include <QtSql>
#include <QSqlDatabase>
#include <QSqlTableModel>

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
#include "cpp/songsqlmodel.h"
#include "cpp/videosqlmodel.h"
#include "cpp/imagesqlmodel.h"
#include "cpp/presentationsqlmodel.h"
#include "cpp/filemanager.h"
#include "cpp/slide.h"

// RUST
// #include "cxx-qt-gen/my_object.cxxqt.h"
#include "cxx-qt-gen/service_thing.cxxqt.h"
#include "cxx-qt-gen/file_helper.cxxqt.h"

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
  qDebug() << QSurfaceFormat::defaultFormat();
  QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
  QApplication::setWindowIcon(QIcon::fromTheme(QStringLiteral("system-config-display")));
  QApplication app(argc, argv);
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
  qSetMessagePattern("[%{type} %{time h:m:s ap}: %{function} in %{file}]: %{message}\n");

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
  QCommandLineParser parser;
  aboutData.setupCommandLine(&parser);
  // setup of app specific commandline args

  //Need to instantiate our slide
  QScopedPointer<Slide> slide(new Slide);
  QScopedPointer<File> filemanager(new File);
  QScopedPointer<QQuickView> preswin(new QQuickView);
  preswin->setSource(QUrl(QStringLiteral("qrc:qml/presenter/PresentationWindow.qml")));

  // apparently mpv needs this class set
  // let's register mpv as well
  std::setlocale(LC_NUMERIC, "C");
  qmlRegisterType<MpvObject>("mpv", 1, 0, "MpvObject");

  //register our models
  qmlRegisterType<SongSqlModel>("org.presenter", 1, 0, "SongSqlModel");
  qmlRegisterType<VideoSqlModel>("org.presenter", 1, 0, "VideoSqlModel");
  qmlRegisterType<ImageSqlModel>("org.presenter", 1, 0, "ImageSqlModel");
  qmlRegisterType<PresentationSqlModel>("org.presenter", 1, 0, "PresentationSqlModel");
  qmlRegisterType<ServiceItemModel>("org.presenter", 1, 0, "ServiceItemModel");
  qmlRegisterType<FileHelper>("org.presenter", 1, 0, "FileHelper");
  qmlRegisterType<ServiceThing>("org.presenter", 1, 0, "ServiceThing");
  qmlRegisterSingletonInstance("org.presenter", 1, 0, "SlideObject", slide.get());
  qmlRegisterSingletonInstance("org.presenter", 1, 0, "FileManager", filemanager.get());
  qmlRegisterSingletonInstance("org.presenter", 1, 0, "PresWindow", preswin.get());

  connectToDatabase();

  QQmlApplicationEngine engine;

  engine.rootContext()->setContextObject(new KLocalizedContext(&engine));
  engine.load(QUrl(QStringLiteral("qrc:qml/main.qml")));

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

  window->setIcon(QIcon::fromTheme(QStringLiteral("system-config-display")));
  // KWindowSystem::setMainWindow(&window);
  KWindowSystem::activateWindow(window);
  qDebug() << "00000000000000000000000000000000";
  qDebug() << KWindowSystem::isPlatformWayland();
  qDebug() << KWindowSystem::windows();
  qDebug() << "00000000000000000000000000000000";


  return app.exec();
}

