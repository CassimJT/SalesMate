import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

Page {
    id: root
    signal verify(string otp)
    signal back()

    ColumnLayout {
        width: parent.width * 0.80
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: parent.height * 0.15
        }
        anchors.margins: 24
        spacing: 16

        Label {
            text: "Enter OTP"
            font.pixelSize: 28
            font.weight: Font.DemiBold
            color: "#2E7D32"  // Dark green to match your app theme
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
        }

        ColumnLayout {
            spacing: 15
            Text {
                text: "Enter the 6-digit code sent to your phone / email."
                wrapMode: Text.WordWrap
            }

            TextField {
                id: otpField
                placeholderText: "OTP"
                Layout.fillWidth: true
                inputMethodHints: Qt.ImhDigitsOnly
                maximumLength: 6
            }
        }
        ToolButton {
            text: qsTr("Resend code")
            Material.foreground: Material.Green
        }

        Button {
            text: "Verify"
            Layout.fillWidth: true
            height: 56
            Material.background: Material.Green
            enabled: otpField.text.length === 6
            onClicked: root.verify(otpField.text)
        }
    }

    RoundButton {
        id: bac
        width: 60
        height: width
        icon.source: "qrc:/Asserts/icons/iback.svg"
        Material.background: Material.Green
        onClicked: {
            root.back()
        }
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: parent.height * 0.20
        }
    }
}
