#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include "core/sources/androidsystem.h"
#include <QQmlContext>
#include <qqml.h>
#include "core/sources/barcodeengine.h"
#include "core/sources/databasemanager.h"
#include "core/sources/expensesmodel.h"
#include "core/sources/incomemodel.h"
#include "core/sources/servicemodel.h"
#include "core/sources/reportmanager.h"
#include <QQuickWindow>

#if defined(Q_OS_ANDROID)
#include <jni.h>
#include <QtCore>
#endif

#include <QTimer>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QQuickWindow::setDefaultAlphaBuffer(true);

    QQmlApplicationEngine engine;

    BarcodeEngine barcodeEngine;
    AndroidSystem *sytstem = AndroidSystem::instance();
    DatabaseManager *databaseManager = DatabaseManager::instance();
    ExpensesModel expenseModel;
    IncomeModel incomeModel;
    ServiceModel serviceModel;
    ReportManager reportManger;

    QCoreApplication::setOrganizationName("SalesMate");
    QCoreApplication::setOrganizationDomain("SalesMate.com");
    QCoreApplication::setApplicationName("SalesMate");

    engine.rootContext()->setContextProperty("Android", sytstem);
    engine.rootContext()->setContextProperty("databaseManager", databaseManager);
    engine.rootContext()->setContextProperty("productFilterModel", databaseManager->getProxyModel());
    engine.rootContext()->setContextProperty("expenseModel", &expenseModel);
    engine.rootContext()->setContextProperty("incomeModel", &incomeModel);
    engine.rootContext()->setContextProperty("ServiceModel", &serviceModel);
    engine.rootContext()->setContextProperty("ReportManger", &reportManger);
    engine.rootContext()->setContextProperty("BarcodeEngine", &barcodeEngine);

    qmlRegisterSingletonType(QUrl("qrc:/UI/Stock/SalesModel.qml"), "SalesModel", 1, 0, "SalesModel");


    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("SalesMate", "Main");

#if defined(Q_OS_ANDROID)
    // Show the native splash screen for 4 seconds (adjust as needed)
    // Then hide it with a nice 400 ms fade-out animation
    QTimer::singleShot(500, []() {
        QNativeInterface::QAndroidApplication::hideSplashScreen(400);  // 400 ms fade
        // Use 0 for instant hide: hideSplashScreen(0)
    });
#endif

    return app.exec();
}
