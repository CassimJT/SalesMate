import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material 2.15
Page {
    id: root
    signal back()
    signal login(string name, string userId)
    ColumnLayout {
        width: parent.width * 0.80
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: parent.height * 0.15
        }

        anchors.margins: 24
        spacing: 25

        Label {
            text: "Worker Login"
            font.pixelSize: 28
            font.weight: Font.DemiBold
            color: "#2E7D32"  // Dark green to match your app theme
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
        }

        ColumnLayout {
            spacing: 10
            Layout.alignment: Qt.AlignHCenter
            TextField {
                id: businessNameField
                placeholderText: "Business name"
                Layout.fillWidth: true
            }
            TextField {
                id: nameField
                placeholderText: "Worker name"
                Layout.fillWidth: true
            }

            TextField {
                id: idField
                placeholderText: "User ID"
                Layout.fillWidth: true
            }
        }

        Button {
            text: "Login"
            Layout.fillWidth: true
            height: 56
            enabled: nameField.text.length && idField.text.length
            Material.background: Material.Green
            onClicked: root.login(nameField.text, idField.text)
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

