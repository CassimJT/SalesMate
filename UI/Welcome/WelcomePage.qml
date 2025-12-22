import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

Page {
    id:welcom
    objectName: "WelcomePage"
    StackLayout {
        id: stackLayout
        anchors.fill: parent

        WelcomeScreen {
            onAgree: stackLayout.currentIndex = 1
        }

        RoleSelectionScreen {
            onWorkerSelected: stackLayout.currentIndex = 2
            onOwnerSelected: stackLayout.currentIndex = 3
            onRegisterSelected: stackLayout.currentIndex = 4
            onBack: stackLayout.currentIndex = 0
        }

        WorkerLoginScreen {
            onBack: stackLayout.currentIndex = 1
        }

        OwnerLoginScreen {
            onBack: stackLayout.currentIndex = 1
        }

        NumberVerificationScreen {
            onBack: stackLayout.currentIndex = 1
            onNext: stackLayout.currentIndex = 5
        }

        BusinessVerificationScreen {
            onBack: stackLayout.currentIndex = 4
            onFinish: stackLayout.currentIndex = 6
        }
        OTPScreen {
            onBack: stackLayout.currentIndex = 5
        }
    }


}
