#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QUrl>
#include <QSql>
#include <QDebug>
#include <KLocalizedContext>
#include <KLocalizedString>
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

#include "mpv/mpvobject.h"
#include "serviceitemmodel.h"
#include "songsqlmodel.h"
#include "videosqlmodel.h"
#include "imagesqlmodel.h"
#include "presentationsqlmodel.h"
#include "filemanager.h"
#include "slide.h"

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
  QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
  QApplication app(argc, argv);
  KLocalizedString::setApplicationDomain("librepresenter");
  QCoreApplication::setOrganizationName(QStringLiteral("librepresenter"));
  QCoreApplication::setOrganizationDomain(QStringLiteral("tfcconnection.org"));
  QCoreApplication::setApplicationName(QStringLiteral("Libre Presenter"));

#ifdef Q_OS_WINDOWS
  QIcon::setFallbackThemeName("breeze");
  QQuickStyle::setStyle(QStringLiteral("org.kde.breeze"));
  // QApplication::setStyle(QStringLiteral("breeze"));
#else
  QIcon::setFallbackThemeName("breeze");
  QQuickStyle::setStyle(QStringLiteral("org.kde.desktop"));
  QQuickStyle::setFallbackStyle(QStringLiteral("Default"));
#endif

  QGuiApplication::setWindowIcon(QIcon::fromTheme(QStringLiteral("system-config-display")));
  qDebug() << QQuickStyle::availableStyles();
  qDebug() << QIcon::themeName();

  //Need to instantiate our slide
  QScopedPointer<Slide> slide(new Slide);
  QScopedPointer<File> filemanager(new File);

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
  qmlRegisterSingletonInstance("org.presenter", 1, 0, "SlideObject", slide.get());
  qmlRegisterSingletonInstance("org.presenter", 1, 0, "FileManager", filemanager.get());

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

  return app.exec();
}

