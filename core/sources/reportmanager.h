#ifndef REPORTMANAGER_H
#define REPORTMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include "core/sources/databasemanager.h"
#include <QDebug>

class ReportManager : public QObject
{
    Q_OBJECT
public:
    explicit ReportManager(QObject *parent = nullptr);
    ~ReportManager();

public slots:
    void addWeaklyReport(const qreal &total);
    void addMonthlyReport();

signals:
private:
    DatabaseManager *dbManager = nullptr;
};

#endif // REPORTMANAGER_H
