#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include "androidsystem.h"
#include <QQmlContext>
#include <qqml.h>
#include "barcodeengine.h"
#include "System/databasemanager.h"
#include "System/expensesmodel.h"
#include "System/incomemodel.h"
#include "System/servicemodel.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    BarcodeEngine barcodeEngine;
    AndroidSystem sytstem;
    DatabaseManager databaseManager;
    ExpensesModel expenseModel;
    IncomeModel incomeModel;
    ServiceModel serviceModel;

    QCoreApplication::setOrganizationName("SalesMate");
    QCoreApplication::setOrganizationDomain("SalesMate.com");
    QCoreApplication::setApplicationName("SalesMate");

    engine.rootContext()->setContextProperty("Android",&sytstem);
    engine.rootContext()->setContextProperty("databaseManager", &databaseManager);
    engine.rootContext()->setContextProperty("productFilterModel", databaseManager.getProxyModel());
    engine.rootContext()->setContextProperty("expenseModel", &expenseModel);
    engine.rootContext()->setContextProperty("incomeModel", &incomeModel);
     engine.rootContext()->setContextProperty("serviceModel", &serviceModel);
    qmlRegisterType <BarcodeEngine>("Cisociety",1,0,"BarcodeEngine");
    qmlRegisterSingletonType(QUrl("qrc:/UI/Stock/SalesModel.qml"), "SalesModel", 1, 0, "SalesModel");

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("SalesMate", "Main");

    return app.exec();
}
