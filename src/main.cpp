#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QUrl>
#include <KLocalizedContext>
#include <KLocalizedString>
#include <iostream>
#include <QQmlEngine>

// #include "mpvobject.h"

int main(int argc, char *argv[])
{
  QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
  QApplication app(argc, argv);
  KLocalizedString::setApplicationDomain("presenter");
  QCoreApplication::setOrganizationName(QStringLiteral("TFC"));
  QCoreApplication::setOrganizationDomain(QStringLiteral("tfcconnection.org"));
  QCoreApplication::setApplicationName(QStringLiteral("Church Presenter"));

  // path = QQmlEngine::importPathList()
  std::cout << "Hello World!";

  QQmlApplicationEngine engine;


  engine.rootContext()->setContextObject(new KLocalizedContext(&engine));
  engine.load(QUrl(QStringLiteral("qrc:qml/main.qml")));

#ifdef STATIC_KIRIGAMI
  KirigamiPlugin::getInstance().registerTypes();
#endif

  if (engine.rootObjects().isEmpty()) {
    return -1;
  }

  return app.exec();
}
