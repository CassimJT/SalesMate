#include "reportmanager.h"

ReportManager::ReportManager(QObject *parent)
    : QObject{parent}
{
    //constractor
    dbManager = DatabaseManager::instance();
    connect(dbManager,&DatabaseManager::salesProcessed, this, &ReportManager::addWeaklyReport);
}

ReportManager::~ReportManager()
{
    //distractor
}
/**
 * @brief ReportManager::addWeaklyReport
 * @param day
 * @param date
 * @param amount
 * add the weakly report to the database
 */
void ReportManager::addWeaklyReport(const qreal &total)
{
    qDebug() <<"Current Total: " << total;
}
/**
 * @brief ReportManager::addMonthlyReport
 * @param month
 * @param amount
 * add the monthly report to the database
 */
void ReportManager::addMonthlyReport()
{
    //
    qDebug() <<"Adding monthly report...";
}

