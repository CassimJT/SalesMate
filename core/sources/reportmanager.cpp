#include "reportmanager.h"

ReportManager::ReportManager(QObject *parent)
    : QObject{parent}, connection_name("threadDb")
{
    //constractor
    dbManager = DatabaseManager::instance();
    connect(dbManager,&DatabaseManager::salesProcessed, this, &ReportManager::processReport);
    processReport(0);
}

ReportManager::~ReportManager()
{
    //distractor
}
/**
 * @brief ReportManager::addWeaklyReport
 * add weakly report  tot the database
 */
void ReportManager::addWeaklyReport(const qreal &total)
{

    qDebug() << "Total: " << total;
    qDebug() << "Total: " << QThread::currentThread();

    QSqlDatabase db = QSqlDatabase::database(connection_name) ;
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
void ReportManager::addMonthlyReport(const qreal &total)
{
    QSqlDatabase db = QSqlDatabase::database(connection_name);
    if (!db.isOpen()) {
        qDebug() << "Database is not open!";
        return;
    }

    QSqlQuery query (db);
    QString month = QDate::currentDate().toString("MMM");
    qreal amount = total;

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

    query.prepare("SELECT id, data, day, income FROM WeeklyIncome");

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
        addWeaklyReport(total);
        QVariantList data = getWeeklyReportData();
        setWeeklyData(data);

    });

}

QVariantList ReportManager::weeklyData() const
{
    return m_weeklyData;
}

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

    QString createWeekly = R"(
        CREATE TABLE IF NOT EXISTS WeeklyIncome (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            data TEXT DEFAULT CURRENT_DATE,
            day TEXT UNIQUE,
            income REAL
        )
    )";
    if (!query.exec(createWeekly)) {
        qDebug() << "Failed to create WeeklyIncome:" << query.lastError().text();
    }
    QString createMonthly = R"(
        CREATE TABLE IF NOT EXISTS MonthlyIncome (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            data TEXT DEFAULT CURRENT_DATE,
            month TEXT UNIQUE,
            income REAL
        )
    )";
    if (!query.exec(createMonthly)) {
        qDebug() << "Failed to create MonthlyIncome:" << query.lastError().text();
    }
}




