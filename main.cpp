#include <QQmlApplicationEngine>
#include <QGuiApplication>
#include <QtQml>
#include <QTranslator>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    QTranslator translator;
    translator.load(QLocale(), "asteroid-sportapp", ".", "/i18n");
    app.installTranslator(&translator);

    return app.exec();
}
