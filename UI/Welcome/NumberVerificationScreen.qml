import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import "../Utils"

Page {
    id: root
    signal back()
    signal next(string phone)

    ColumnLayout {
        width: parent.width * 0.80
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: parent.height * 0.15
        }
        spacing: 25

        Label {
            text: "Provide Phone Number"
            font.pixelSize: 28
            font.weight: Font.DemiBold
            color: "#2E7D32"  // Dark green to match your app theme
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            text: "We will send you a verification code."
            wrapMode: Text.WordWrap
        }

        ColumnLayout {
            spacing: 15
            Layout.fillWidth: true

            CountrySelector {
                id: countrySelector
                onCountryChanged: {
                    phoneField.text = code
                }
            }

            TextField {
                id: phoneField
                placeholderText: "Phone number"
                Layout.fillWidth: true
                inputMethodHints: Qt.ImhDigitsOnly
            }
        }

        Button {
            text: "Next"
            Layout.fillWidth: true
            height: 56
            enabled: phoneField.text.length >= 9
            icon.source: "qrc:/Asserts/Welcome/next.svg"
            display: AbstractButton.TextBesideIcon
            Material.background: Material.Green
            onClicked: root.next(phoneField.text)
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
