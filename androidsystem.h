#ifndef ANDROIDSYSTEM_H
#define ANDROIDSYSTEM_H

#include <QObject>
#include <QJsonObject>
#include <QCoreApplication>
#if defined(Q_OS_ANDROID)
#include <QtCore/private/qandroidextras_p.h>
#endif

class AndroidSystem : public QObject
{
    Q_OBJECT
public:
    explicit AndroidSystem(QObject *parent = nullptr);
public slots:

signals:
private:
      void setAnAndroidSystemBarColor();
};

#endif // ANDROIDSYSTEM_H
