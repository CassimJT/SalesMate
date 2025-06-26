#ifndef REPORTMANAGER_H
#define REPORTMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include "core/sources/databasemanager.h"
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

public:
    explicit ReportManager(QObject *parent = nullptr);
    ~ReportManager();

    QVariantList list() const;
    void setList(const QVariantList &newList);

    QVariantList weeklyData() const;
    void setWeeklyData(const QVariantList &newWeeklyData);

public slots:
    void addWeaklyReport(const qreal &total);
    void addMonthlyReport(const qreal &total);

private slots:
    void processReport(const qreal &total);

signals:
    void weeklyDataChanged();

private:
    DatabaseManager *dbManager = nullptr;
    QSqlDatabase threadDb;
    QString connection_name;
    QVariantList m_weeklyData;
    void createIncomeTables(QSqlDatabase &db);
    QVariantList getWeeklyReportData();
    void deleteTables(QSqlDatabase &db);

};

#endif // REPORTMANAGER_H
