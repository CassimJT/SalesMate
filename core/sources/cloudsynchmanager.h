#ifndef CLOUDSYNCHMANAGER_H
#define CLOUDSYNCHMANAGER_H

#include <QObject>

class CloudSynchManager : public QObject
{
    Q_OBJECT
public:
    explicit CloudSynchManager(QObject *parent = nullptr);

signals:
};

#endif // CLOUDSYNCHMANAGER_H
