#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "androidsystem.h"
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    AndroidSystem sytstem;
    engine.rootContext()->setContextProperty("AndroidSystem",&sytstem);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("SalesMate", "Main");

    return app.exec();
}
