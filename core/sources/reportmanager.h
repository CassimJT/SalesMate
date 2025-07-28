#ifndef REPORTMANAGER_H
#define REPORTMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include "core/sources/databasemanager.h"
#include "core/sources/androidsystem.h"
#include <QDebug>
#include <QtConcurrent>
#include <QFuture>
#include <QThread>
#include <QVariantList>
#include <QJsonObject>
#include <QDebug>


class ReportManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList weeklyData READ weeklyData WRITE setWeeklyData NOTIFY weeklyDataChanged FINAL)
    Q_PROPERTY(QVariantList monthlyData READ monthlyData WRITE setMonthlyData RESET resetMonthlyData NOTIFY monthlyDataChanged FINAL)

public:
    explicit ReportManager(QObject *parent = nullptr);
    ~ReportManager();

    QVariantList list() const;
    void setList(const QVariantList &newList);

    QVariantList weeklyData() const;
    void setWeeklyData(const QVariantList &newWeeklyData);

    QVariantList monthlyData() const;
    void setMonthlyData(const QVariantList &newMonthlyData);


public slots:
    void addWeeklyReport(const qreal &total,QSqlDatabase &db);
    void addMonthlyReport(const qreal &total,QSqlDatabase &db);
    void resetWeeklyReport();
    void resetMonthlyData();


private slots:
    void processReport(const qreal &total);

signals:
    void weeklyDataChanged();
    void weeklyReportReset();

    void monthlyDataChanged();

private:
    DatabaseManager *dbManager = nullptr;
    AndroidSystem *android = nullptr;
    QSqlDatabase threadDb;
    QString connection_name;
    QVariantList m_weeklyData;
    QVariantList m_monthlyData;
    void createIncomeTables(QSqlDatabase &db);
    QVariantList getWeeklyReportData();
    QVariantList getMonthlyReportData();
    void deleteTables(QSqlDatabase &db);
    qreal weeklyTotal(QSqlDatabase &db);
    qreal yearyTotal(QSqlDatabase &db);

};

#endif // REPORTMANAGER_H
