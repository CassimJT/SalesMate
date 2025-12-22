import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

Page {
    id: root
    signal back()
    signal login(string businessId, string owner, string email)
    property bool isPasswordVisible: false

    ColumnLayout {
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: parent.height * 0.15
        }
        anchors.margins: 24
        spacing: 25

        Label {
            text: "Business Owner Login"
            font.pixelSize: 28
            font.weight: Font.DemiBold
            color: "#2E7D32"  // Dark green to match your app theme
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
        }

        ColumnLayout {
            spacing: 10
            TextField {
                placeholderText: "Email"
                Layout.fillWidth: true
                inputMethodHints: Qt.ImhEmailCharactersOnly
            }

            RowLayout {
                TextField {
                    placeholderText: "Password"
                    Layout.fillWidth: true
                    passwordCharacter: "*"
                    echoMode: root.isPasswordVisible ? TextInput.Normal : TextInput.Password

                }

                Image {
                    id: eye
                    Layout.preferredWidth: 24
                    Layout.preferredHeight: 24
                    source: isPasswordVisible ? "qrc:/Asserts/Welcome/visible.svg" : "qrc:/Asserts/Welcome/invisible.svg"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            root.isPasswordVisible = !root.isPasswordVisible
                        }
                    }
                }
            }

        }


        Button {
            text: "Login"
            Layout.fillWidth: true
            Material.background: Material.Green
            height: 56
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
