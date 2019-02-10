#include <QQmlApplicationEngine>
#include <QGuiApplication>
#include <QtQml>
#include <QTranslator>
#include <qDebug>
#include <QGeoCoordinate>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QTranslator translator;
    translator.load(QLocale(), QLatin1String("asteroid-sportapp"), QLatin1String("."), QLatin1String("i18n"));
    bool test = translator.load(QLocale(), QLatin1String("asteroid-sportapp"), QLatin1String("."), QLatin1String("i18n"));
    qDebug() << "QTranslator: " << test;
    app.installTranslator(&translator);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
