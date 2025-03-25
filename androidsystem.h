#ifndef ANDROIDSYSTEM_H
#define ANDROIDSYSTEM_H

#include <QObject>
#include <QJsonObject>
#include <QCoreApplication>
#if defined(Q_OS_ANDROID)
#include <QtCore/private/qandroidextras_p.h>
#endif
#include <QPermission>
#include <QImage>
#include <ZXingCpp.h>
#include <ImageView.h>
#include <Result.h>
#include <ReadBarcode.h>
#include <DecodeHints.h>
#include <QCamera>
#include <QVideoFrame>

class AndroidSystem : public QObject
{
    Q_OBJECT
public:
    explicit AndroidSystem(QObject *parent = nullptr);
public slots:
    //
    void requestCameraPeremision();

signals:
   //
private slots:
  //
private:
    void setAnAndroidSystemBarColor();
    void StartSchedua();
    void requestIgnoreBatteryOptimization();

};

#endif // ANDROIDSYSTEM_H
