import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

RowLayout {
    spacing: 40
    anchors.centerIn: parent
    signal cameraClicked()
    signal galaryClicked()

    // Camera Section
    Column {
        Layout.alignment: Qt.AlignCenter
        spacing: 10

        Rectangle {
            width: 60
            height: 60
            radius: width / 2
            color: "lightgreen"
            anchors.horizontalCenter: parent.horizontalCenter

            // Camera Icon
            Image {
                id: camera
                anchors.centerIn: parent
                width: 28
                height: width
                source: "qrc:/Asserts/icons/icons8-camera-green.png"
                fillMode: Image.PreserveAspectFit
            }
            //mouse area
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    cameraClicked()
                }
            }
        }

        Label {
            id: cameraLabel
            text: qsTr("Camera")
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    // Gallery Section
    Column {
        Layout.alignment: Qt.AlignCenter
        spacing: 10

        Rectangle {
            width: 60
            height: 60
            radius: width / 2
            color: "lightblue"
            anchors.horizontalCenter: parent.horizontalCenter

            // Gallery Icon
            Image {
                id: gallery
                anchors.centerIn: parent
                width: 28
                height: width
                source: "qrc:/Asserts/icons/icons8-gallery-100.png"
                fillMode: Image.PreserveAspectFit
            }
            //mouse area
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    galaryClicked();
                }
            }
        }

        Label {
            id: galleryLabel
            text: qsTr("Gallery")
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
