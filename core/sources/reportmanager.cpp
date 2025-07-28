#include "reportmanager.h"

ReportManager::ReportManager(QObject *parent)
    : QObject{parent}, connection_name("threadDb")
{
    //constractor
    dbManager = DatabaseManager::instance(); //globle Database system
    android = AndroidSystem::instance(); //globle androind system
    connect(dbManager,&DatabaseManager::salesProcessed, this, &ReportManager::processReport);
    processReport(0);
    connect(android, &AndroidSystem::workerInvoked, this, &ReportManager::resetWeeklyReport);

    // Delayed monthly data load (500 ms)
    QTimer::singleShot(500, this, [this]() {
        QtConcurrent::run([this]() {
            QVariantList data = getMonthlyReportData();
            QMetaObject::invokeMethod(this, [this, data]() {
                setMonthlyData(data);
            }, Qt::QueuedConnection);
        });
    });
}

ReportManager::~ReportManager()
{
    //distractor
}
/**
 * @brief ReportManager::addWeaklyReport
 * add weakly report  tot the database
 */
void ReportManager::addWeeklyReport(const qreal &total, QSqlDatabase &db)
{

    qDebug() << "Total: " << total;
    qDebug() << "Thread: " << QThread::currentThread();

    if (!db.isOpen()) {
        qDebug() << "Database is not open!";
        return;
    }

    QSqlQuery query(db);
    QDate currentDate = QDate::currentDate();
    QString day = currentDate.toString("ddd");
    QString date = currentDate.toString("yyyy-MM-dd");
    qreal amount = total;

    // Checking if entry exists for the current date
    query.prepare("SELECT income FROM WeeklyIncome WHERE day = :day");
    query.bindValue(":day", day);
    if (query.exec() && query.next()) {
        // Update existing entry
        qreal existingAmount = query.value(0).toDouble();
        amount += existingAmount;
        query.prepare("UPDATE WeeklyIncome SET income = :income WHERE day = :day");
        query.bindValue(":income", amount);
        query.bindValue(":day", day);
    } else {
        // Insert new entry
        query.prepare("INSERT INTO WeeklyIncome (day, income) VALUES (:day, :income)");
        query.bindValue(":day", day);
        query.bindValue(":income", amount);
    }
    if (!query.exec()) {
        qDebug() << "Failed to update or insert WeeklyIncome:" << query.lastError().text();
    }
}
/**
 * @brief ReportManager::addMonthlyReport
 * @param total
 * add monthly report to the database
 */
void ReportManager::addMonthlyReport(const qreal &total, QSqlDatabase &db)
{

    QSqlQuery query (db);
    QString month = QDate::currentDate().toString("MMM");
    qreal amount = total;

    if (!db.isOpen()) {
        qDebug() << "Database is not open!";
        return;
    }

    // Checking if entry exists for the current month
    query.prepare("SELECT income FROM MonthlyIncome WHERE month = :month");
    query.bindValue(":month", month);
    if (query.exec() && query.next()) {
        // Update existing entry
        qreal existingAmount = query.value(0).toDouble();
        amount += existingAmount;
        query.prepare("UPDATE MonthlyIncome SET income = :income WHERE month = :month");
        query.bindValue(":income", amount);
        query.bindValue(":month", month);
    } else {
        // Insert new entry
        query.prepare("INSERT INTO MonthlyIncome (month, income) VALUES (:month, :income)");
        query.bindValue(":month", month);
        query.bindValue(":income", amount);
    }
    if (!query.exec()) {
        qDebug() << "Failed to update or insert MonthlyIncome:" << query.lastError().text();
    }
}
/**
 * @brief ReportManager::resetWeeklyReport
 * reserting the weekly data by clearing the table to start a fresh entry every weak
 * when the alarm is fire every sundy thid function in responsible for reseting the table for new fresh entry
 */
// In resetWeeklyReport():
void ReportManager::resetWeeklyReport()
{
    QFuture<void> future = QtConcurrent::run([this]() {
        QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE", "reset_connection");
        db.setDatabaseName("salesmate.db");
        // deleteTables(db);

        if (!db.open()) {
            qCritical() << "Failed to open database in worker thread";
            return;
        }

        // 1. Get weekly total
        qreal total = weeklyTotal(db);

        // 2. Add to monthly report
        if (total > 0) {
            addMonthlyReport(total, db);
        }

        // 3. Reset weekly
        QSqlQuery query(db);
        if (!query.exec("DELETE FROM WeeklyIncome")) {
            qDebug() << "Reset failed:" << query.lastError();
        } else {
            // Update UI safely in main thread
            QMetaObject::invokeMethod(this, [this]() {
                setWeeklyData(QVariantList());
            }, Qt::QueuedConnection);
        }
        //updating the GUI
        QVariantList newData = getMonthlyReportData();
        QMetaObject::invokeMethod(this, [this, newData]() {
            setMonthlyData(newData);
        }, Qt::QueuedConnection);

        db.close();
        QSqlDatabase::removeDatabase("reset_connection");
    });
}
/**
 * @brief ReportManager::weeklyTotal
 * @return the current weakly total
 */
qreal ReportManager::weeklyTotal(QSqlDatabase &db)
{
    qreal total = 0.0;

    if (!db.isOpen()) {
        qDebug() << "Database is not open!";
        return total;
    }

    QSqlQuery query(db);
    if (query.exec("SELECT SUM(income) FROM WeeklyIncome")) {
        if (query.next()) {
            total = query.value(0).toDouble();
        }
    } else {
        qDebug() << "Failed to calculate weekly total:" << query.lastError().text();
    }

    return total;
}

qreal ReportManager::yearyTotal(QSqlDatabase &db)
{
    qreal total = 0.0;

    if (!db.isOpen()) {
        qDebug() << "Database is not open!";
        return total;
    }

    QSqlQuery query(db);
    if (query.exec("SELECT SUM(income) FROM MonthlyIncome")) {
        if (query.next()) {
            total = query.value(0).toDouble();
        }
    } else {
        qDebug() << "Failed to calculate MonthlyIncome total:" << query.lastError().text();
    }

    return total;
}
/**
 * @brief ReportManager::getWeeklyReportData
 * @return a weekly Data
 */
QVariantList ReportManager::getWeeklyReportData()
{
    QVariantList list;
    QSqlDatabase db = QSqlDatabase::database(connection_name) ;

    if (!db.isOpen()) {
        qDebug() << "Database is not open!";
        return list;
    }

    QSqlQuery query(db);

    query.prepare("SELECT id, date, day, income FROM WeeklyIncome");

    if (!query.exec()) {
        qDebug() << "Failed to fetch WeeklyIncome:" << query.lastError().text();
        return list;
    }

    while (query.next()) {
        QJsonObject jsonObject;
        jsonObject["id"] = query.value(0).toInt();
        jsonObject["date"] = query.value(1).toString();
        jsonObject["day"] = query.value(2).toString();
        jsonObject["income"] = query.value(3).toDouble();

        list.append(jsonObject);
    }
    db.close();
    return list;
}
/**
 * @brief ReportManager::getMonthlyReportData
 * @return monthly data for plotting
 */
QVariantList ReportManager::getMonthlyReportData()
{
    QVariantList list;

    // Create a new thread-local connection
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE", "monthly_query_conn");
    db.setDatabaseName("salesmate.db");

    if (!db.open()) {
        qWarning() << "Failed to open monthly database:" << db.lastError();
        QSqlDatabase::removeDatabase("monthly_query_conn");
        return list;
    }

    QSqlQuery query(db);
    if (!query.exec("SELECT month, income FROM MonthlyIncome")) {
        qWarning() << "Monthly query failed:" << query.lastError();
    } else {
        while (query.next()) {
            QJsonObject obj;
            obj["month"] = query.value("month").toString();
            obj["income"] = query.value("income").toDouble();
            list.append(obj);
        }
    }

    db.close();
    QSqlDatabase::removeDatabase("monthly_query_conn");
    qDebug() << "Monthly data fetched:" << list.size() << "items";
    return list;
}
/**
 * @brief ReportManager::processReport
 * @param total
 * process the resport borth monthly and weakly
 */
void ReportManager::processReport(const qreal &total)
{
    QFuture future = QtConcurrent::run([this, total]() {
        threadDb = QSqlDatabase::addDatabase("QSQLITE",connection_name);
        threadDb.setDatabaseName("salesmate.db");
        if (!threadDb.open()) {
            qCritical() << "Failed to open database in worker thread";
            return;
        }
        qDebug() << "New database connection opened in: " <<QThread::currentThread();
        createIncomeTables(threadDb);
        //deleteTables(threadDb);
        addWeeklyReport(total,threadDb);
        QVariantList data = getWeeklyReportData();
        setWeeklyData(data);

    });

}
/**
 * @brief ReportManager::monthlyData
 * @return monthly data
 */
QVariantList ReportManager::monthlyData() const
{
    return m_monthlyData;
}
/**
 * @brief ReportManager::setMonthlyData
 * @param newMonthlyData
 */
void ReportManager::setMonthlyData(const QVariantList &newMonthlyData)
{
    if (m_monthlyData == newMonthlyData)
        return;
    m_monthlyData = newMonthlyData;
    emit monthlyDataChanged();
}
/**
 * @brief ReportManager::resetMonthlyData
 * reset montltable ant the end of a year for a freach new year
 */
void ReportManager::resetMonthlyData()
{
    setMonthlyData({}); // TODO: Adapt to use your actual default value
}
/**
 * @brief ReportManager::weeklyData
 * @return current week data
 */
QVariantList ReportManager::weeklyData() const
{
    return m_weeklyData;
}
/**
 * @brief ReportManager::setWeeklyData
 * @param newWeeklyData
 */
void ReportManager::setWeeklyData(const QVariantList &newWeeklyData)
{
    if (m_weeklyData == newWeeklyData)
        return;
    m_weeklyData = newWeeklyData;
    emit weeklyDataChanged();
}

/**
 * @brief ReportManager::createIncomeTables
 * creating the weekly and monthly tables if not exist
 */
void ReportManager::createIncomeTables(QSqlDatabase &db)
{
    QSqlQuery query(db);

    const QString createWeekly = R"(
        CREATE TABLE IF NOT EXISTS WeeklyIncome (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT DEFAULT (DATE('now')),
            day TEXT UNIQUE,
            income REAL
        )
    )";

    if (!query.exec(createWeekly)) {
        qDebug() << "Failed to create WeeklyIncome:" << query.lastError().text();
    } else {

        qDebug() << "WeeklyIncome Table created";
    }


    const QString createMonthly = R"(
        CREATE TABLE IF NOT EXISTS MonthlyIncome (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT DEFAULT (DATE('now')),
            month TEXT UNIQUE,
            income REAL
        )
    )";

    if (!query.exec(createMonthly)) {
        qDebug() << "Failed to create MonthlyIncome:" << query.lastError().text();
    }else {

        qDebug() << "MonthlyIncome Table created";
    }
}

/**
 * @brief DatabaseManager::deleteTables
 * for deleting tables during development phase
 */
void ReportManager::deleteTables(QSqlDatabase &db)
{

    QSqlQuery query(db);

    if (!query.exec("DROP TABLE IF EXISTS WeeklyIncome;")) {
        qDebug() << "Failed to drop WeeklyIncome table:" << query.lastError().text();
    } else {
        qDebug() << "WeeklyIncome table dropped.";
    }

    if (!query.exec("DROP TABLE IF EXISTS MonthlyIncome;")) {
        qDebug() << "Failed to drop MonthlyIncome table:" << query.lastError().text();
    } else {
        qDebug() << "MonthlyIncome table dropped.";
    }
}





