#include "reportmanager.h"

ReportManager::ReportManager(QObject *parent)
    : QObject{parent}
{
    //constractor
    dbManager = DatabaseManager::instance();
    connect(dbManager,&DatabaseManager::salesProcessed, this, &ReportManager::processReport);
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

    QSqlDatabase db = dbManager->getDatabase();
    if (!db.isOpen()) {
        qDebug() << "Database is not open!";
        return;
    }

    QSqlQuery query(db);
    QDate currentDate = QDate::currentDate();
    QString day = currentDate.toString("ddd");
    QString date = currentDate.toString("yyyy-MM-dd");
    qreal amount = total;

    // Check if entry exists for the current date
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
    QSqlDatabase db = dbManager->getDatabase();
    if (!db.isOpen()) {
        qDebug() << "Database is not open!";
        return;
    }

    QSqlQuery query (db);
    QString month = QDate::currentDate().toString("MMM");
    qreal amount = total;

    // Check if entry exists for the current month
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
QVariantList ReportManager::getWeeklyReportData() const
{
    QVariantList list;
    QSqlDatabase db = dbManager->getDatabase();

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
        threadDb = QSqlDatabase::addDatabase("QSQLITE");
        threadDb.setDatabaseName("salesmate.db");

        if (!threadDb.open()) {
            qCritical() << "Failed to open database in worker thread";
            return;
        }
        qDebug() << "New database connection opened in: " <<QThread::currentThread();

    });

}


