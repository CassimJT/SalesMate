#ifndef REPORTMANAGER_H
#define REPORTMANAGER_H

#include <QObject>

class ReportManager : public QObject
{
    Q_OBJECT
public:
    explicit ReportManager(QObject *parent = nullptr);

signals:
};

#endif // REPORTMANAGER_H
