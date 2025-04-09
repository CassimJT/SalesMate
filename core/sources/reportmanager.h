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


class ReportManager : public QObject
{
    Q_OBJECT
public:
    explicit ReportManager(QObject *parent = nullptr);
    ~ReportManager();

public slots:
    void addWeaklyReport(const qreal &total);
    void addMonthlyReport(const qreal &total);
    QVariantList getWeeklyReportData() const;

private slots:
    void processReport(const qreal &total);

signals:
private:
    DatabaseManager *dbManager = nullptr;
};

#endif // REPORTMANAGER_H
