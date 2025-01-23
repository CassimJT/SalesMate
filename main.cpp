#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "androidsystem.h"
#include <QQmlContext>
#include <qqml.h>
#include "barcodeengine.h"
#include "System/databasemanager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    BarcodeEngine barcodeEngine;
    AndroidSystem sytstem;
    DatabaseManager databaseManager;

    engine.rootContext()->setContextProperty("Android",&sytstem);
    engine.rootContext()->setContextProperty("databaseManager", &databaseManager);
      engine.rootContext()->setContextProperty("productFilterModel", databaseManager.getProxyModel());
    qmlRegisterType <BarcodeEngine>("Cisociety",1,0,"BarcodeEngine");
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("SalesMate", "Main");

    return app.exec();
}
