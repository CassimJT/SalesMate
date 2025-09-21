import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "../Utils"


Page {
    id: profileEditPage
    objectName: "Profile"
    property alias avataDrawer: avataDrawer
    ColumnLayout {
        spacing: 10
        width: parent.width
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 10
            leftMargin: 10
            rightMargin: 10
        }

        // Avatar Component
        Avatar {
            id: avatar
            editIconSource: "qrc:/Asserts/icons/icons8-camera.png"
            iconBackgroundColor: "LightGreen"
            iconInsidebackgroundScaleFactor: 0.7
            avatarSize: 150
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                console.log("Avatar edit icon clicked!");
                avataDrawer.open()
            }
        }
        // User Info Row Layout
        RowLayout {
            spacing: 3
            Layout.preferredWidth : parent.width * 0.80
            Layout.alignment: Qt.AlignHCenter

            // Info Icon
            Image {
                id: info
                Layout.preferredWidth: 24
                Layout.preferredHeight: 24
                source: "qrc:/Asserts/icons/icons8-contact-100.png"
                fillMode: Image.PreserveAspectFit
            }

            // Name Section
            ColumnLayout {
                spacing: 2
                Layout.fillWidth: true

                Label {
                    id: title
                    text: qsTr("Name")
                    font.bold: true
                }

                Text {
                    id: fullname
                    text: qsTr("Sara Phiri")
                    font.pixelSize: 16
                }
            }


            // Edit Icon
            Image {
                id: edit
                Layout.preferredWidth: 28
                Layout.preferredHeight: 28
                Layout.alignment: Qt.AlignRight
                source: "qrc:/Asserts/icons/icons8-edit-100.png"
                fillMode: Image.PreserveAspectFit
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("Edit icon clicked!");
                        // ...
                    }
                }
            }
        }
    }
    Drawer {
        id: avataDrawer
        width: parent.width
        height: parent.height * 0.25
        dragMargin: 0
        edge: Qt.BottomEdge
        Rectangle{
            id: handle
            width: 40
            height: 3
            radius: 3
            color: "#333"
            anchors {
                top: parent.top
                horizontalCenter:parent.horizontalCenter
            }
        }
        AvataDrawerTools {
            id:tools
            anchors.centerIn:parent
            onCameraClicked: {
                console.log("Camera clicked")
                profileLoader.source = "CameraPage.qml"
            }
            onGalaryClicked: {
                console.log("Galary Clicked")
                //...
            }
        }

    }

}
