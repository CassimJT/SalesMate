#include "androidsystem.h"

AndroidSystem::AndroidSystem(QObject *parent)
    : QObject{parent}
{
//constractor
#if defined(Q_OS_ANDROID)
    setAnAndroidSystemBarColor();
#endif
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




