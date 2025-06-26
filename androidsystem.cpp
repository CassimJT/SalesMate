#include "androidsystem.h"
extern "C"
    JNIEXPORT void JNICALL
    Java_com_salesmate_NativeBridge_invoked(JNIEnv *env, jclass clazz) {
    LOGD("JNI invoked from AlarmReceiver");

    if (qApp) {
        QMetaObject::invokeMethod(qApp, []() {
            AndroidSystem::instance()->invoked();
        });
    } else {
        LOGD("Qt context not ready - cannot process alarm");
    }
}

AndroidSystem *AndroidSystem::_instance = nullptr;
AndroidSystem::AndroidSystem(QObject *parent)
    : QObject{parent}
{
//constractor
#if defined(Q_OS_ANDROID)
    setAnAndroidSystemBarColor();
    requestIgnoreBatteryOptimization();
    startAlarm();
    //StartSchedua();
    connect(this, &AndroidSystem::workerInvoked, this, &AndroidSystem::printLog);
#endif
}

AndroidSystem *AndroidSystem::instance()
{
    if(_instance == nullptr) {
        _instance = new AndroidSystem();
    }
    return _instance;
}
/**
 * @brief AndroidSystem::requestCameraPeremision
 * request camera peremiasion in android
 */
void AndroidSystem::requestCameraPeremision()
{
    QCameraPermission camerPermission;
    qApp->requestPermission(camerPermission,this,[this](const QPermission &results) {
        //checking the result
        if(results.status() == Qt::PermissionStatus::Denied) {
            qDebug()<< "Camers Access Denied";
        } else if(results.status() == Qt::PermissionStatus::Undetermined) {
            qDebug()<< "Camera Status Undefined. Make sure that the Camera is Oky and try again";
        }else if(results.status() == Qt::PermissionStatus::Granted) {
            qDebug()<< "Camera Access granted";
        }

    });
}
/**
 * @brief AndroidSystem::setAnAndroidSystemBarColor
 * this function changes the android SystemBar color
 */
void AndroidSystem::setAnAndroidSystemBarColor()
{
#if defined(Q_OS_ANDROID)
    QNativeInterface::QAndroidApplication::runOnAndroidMainThread([=]()->QVariant {
        //getting the activity
        QJniObject activity = QNativeInterface::QAndroidApplication::context();
        if(!activity.isValid()){
            return QVariant();
        }
        //getting the window from the activity
        QJniObject window = activity.callObjectMethod("getWindow","()Landroid/view/Window;");
        if(!window.isValid()) {
            return QVariant();
        }
        window.callMethod<void>("addFlags","(I)V",0x80000000);
        window.callMethod<void>("clearFlags","(I)V",0x04000000);
        window.callMethod<void>("setStatusBarColor","(I)V",0xFF4CAF50); //0xFF4CAF50 = #4CAF50 //green
        return QVariant(true);
    }).waitForFinished();

#endif
}
/**
 * @brief AndroidSystem::StartSchedua
 * start the schedual
 */
void AndroidSystem::StartSchedua()
{
#if defined(Q_OS_ANDROID)
    qDebug()<<"Starting the Schedual";
    QJniObject activity = QNativeInterface::QAndroidApplication::context();
    if (activity.isValid()) {
        QJniObject::callStaticMethod<void>(
            "com/salesmate/WorkManagerHelper",
            "schedulePeriodicWork",
            "(Landroid/content/Context;)V",
            activity.object<jobject>()
            );
    }
#endif
}

void AndroidSystem::requestIgnoreBatteryOptimization()
{
#if defined(Q_OS_ANDROID)
    qDebug() << "Requesting battery optimization exemption";

    QJniObject activity = QNativeInterface::QAndroidApplication::context();
    if (activity.isValid()) {
        QJniObject::callStaticMethod<void>(
            "com/salesmate/BatteryOptimizationHelper",
            "requestIgnoreBatteryOptimization",
            "(Landroid/content/Context;)V",
            activity.object<jobject>()
            );
    }
#endif
}
/**
 * @brief AndroidSystem::increement
 * increement m_mun when invoked function is called from workmanager
 */
void AndroidSystem::printLog()
{
    __android_log_print(ANDROID_LOG_DEBUG, "AlarmHelper", "Hello from AlarmManager!!");
}
/**
 * @brief AndroidSystem::startAlarm
 * start the alarm for autometed works
 */
void AndroidSystem::startAlarm()
{
    QJniObject context = QNativeInterface::QAndroidApplication::context();
    if(context.isValid()) {
        QJniObject::callStaticMethod<void>(
            "com/salesmate/AlarmHelper",
            "scheduleExactAlarm",
            "(Landroid/content/Context;)V",
            context.object<jobject>()
            );
    }
}

void AndroidSystem::invoked()
{
    emit workerInvoked();
}




