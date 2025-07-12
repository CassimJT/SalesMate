#ifndef ANDROIDSYSTEM_H
#define ANDROIDSYSTEM_H

#include <QObject>
#include <QJsonObject>
#include <QCoreApplication>
#if defined(Q_OS_ANDROID)
#include <QtCore/private/qandroidextras_p.h>
#include <jni.h>
#include <android/log.h>
#define LOG_TAG "NativeWorker"
#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG, __VA_ARGS__)
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
        static AndroidSystem* instance();
        void invoked() ;
public slots:
    //
    void requestCameraPeremision();

signals:
    void workerInvoked();
   //
private slots:
  //
private:
    void setAnAndroidSystemBarColor();
    void StartSchedua();
    void requestIgnoreBatteryOptimization();
    void printLog();
    static AndroidSystem * _instance;
    void startAlarm();


};

#endif // ANDROIDSYSTEM_H
