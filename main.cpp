#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "androidsystem.h"
#include <QQmlContext>
#include <qqml.h>
#include "barcodeengine.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    BarcodeEngine barcodeEngine;
    AndroidSystem sytstem;
    engine.rootContext()->setContextProperty("Android",&sytstem);
    qmlRegisterType <BarcodeEngine>("Cidociety",1,0,"BarcodeEngine");
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("SalesMate", "Main");

    return app.exec();
}
