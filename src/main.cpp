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

#include <QtGui/QOpenGLFramebufferObject>

#include <QtQuick/QQuickWindow>
#include <QtQuick/QQuickView>
#include <qdir.h>
#include <qglobal.h>
#include <qqml.h>
#include <qsqldatabase.h>
#include <qsqlquery.h>

#include "songlistmodel.h"
#include "mpv/mpvobject.h"
#include "songsqlmodel.h"

static void connectToDatabase() {
  // let's setup our sql database
  QSqlDatabase db = QSqlDatabase::database();
  if (!db.isValid()){
    db = QSqlDatabase::addDatabase("QSQLITE");
    if (!db.isValid())
      qFatal("Cannot add database: %s", qPrintable(db.lastError().text()));
  }

  const QDir writeDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);

  if (!writeDir.mkpath(".")) {
    qFatal("Failed to create writable location at %s", qPrintable(writeDir.absolutePath()));
  }

  const QString dbName = writeDir.absolutePath() + "/library-db.sqlite3";

  db.setHostName("localhost");
  db.setDatabaseName(dbName);
  db.setUserName("presenter");
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
  KLocalizedString::setApplicationDomain("presenter");
  QCoreApplication::setOrganizationName(QStringLiteral("presenter"));
  QCoreApplication::setOrganizationDomain(QStringLiteral("tfcconnection.org"));
  QCoreApplication::setApplicationName(QStringLiteral("Church Presenter"));

  // apparently mpv needs this class set
  std::setlocale(LC_NUMERIC, "C");
  qmlRegisterType<MpvObject>("mpv", 1, 0, "MpvObject");

  //register our song model from sql
  qmlRegisterType<SongSqlModel>("org.presenter", 1, 0, "SongSqlModel");

  SongListModel songListModel;

  connectToDatabase();

  QQmlApplicationEngine engine;

  engine.rootContext()->setContextObject(new KLocalizedContext(&engine));
  engine.rootContext()->setContextProperty("_songListModel", &songListModel);
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

