import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

RowLayout {
    spacing: 40 // Space between the Camera and Gallery columns
    anchors.centerIn: parent // Optional, if you want to center the RowLayout in its parent

    // Camera Section
    Column {
        Layout.alignment: Qt.AlignCenter // Center align the Column in the RowLayout
        spacing: 10 // Space between the icon and label

        // Circular background for the Camera icon
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
        Layout.alignment: Qt.AlignCenter // Center align the Column in the RowLayout
        spacing: 10 // Space between the icon and label

        // Circular background for the Gallery icon
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
        }

        Label {
            id: galleryLabel
            text: qsTr("Gallery")
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
