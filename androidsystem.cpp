#include "androidsystem.h"

AndroidSystem::AndroidSystem(QObject *parent)
    : QObject{parent}
{
    //constractor
    setAnAndroidSystemBarColor();
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
        window.callMethod<void>("setStatusBarColor","(I)V",0xFF2196F3); //lightBlue
        return QVariant(true);
    }).waitForFinished();

#endif

}
