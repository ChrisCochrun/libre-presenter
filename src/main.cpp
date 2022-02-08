#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QUrl>
#include <KLocalizedContext>
#include <KLocalizedString>

// #include "mpvobject.h"

int main(int argc, char *argv[])
{
  QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
  QApplication app(argc, argv);
  KLocalizedString::setApplicationDomain("presenter");
  QCoreApplication::setOrganizationName(QStringLiteral("TFC"));
  QCoreApplication::setOrganizationDomain(QStringLiteral("tfcconnection.org"));
  QCoreApplication::setApplicationName(QStringLiteral("Church Presenter"));

  QQmlApplicationEngine engine;


  engine.rootContext()->setContextObject(new KLocalizedContext(&engine));
  engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

#ifdef STATIC_KIRIGAMI
  KirigamiPlugin::getInstance().registerTypes();
#endif

  // // Qt sets the locale in the QGuiApplication constructor, but libmpv
  // // requires the LC_NUMERIC category to be set to "C", so change it back.
  // std::setlocale(LC_NUMERIC, "C");

  // qmlRegisterType<MpvObject>("mpv", 1, 0, "MpvObject");

  if (engine.rootObjects().isEmpty()) {
    return -1;
  }

  return app.exec();
}
