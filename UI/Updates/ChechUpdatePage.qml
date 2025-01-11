import QtQuick 2.15
import QtQuick.Controls
Page {
    id: cheackForUpdates
    objectName: "Updates"
    Label {
        text: "Cureent version: 1.0"
        font.pixelSize: 16
        color: "gray"
        anchors {
            bottom: busyindicator.top
            bottomMargin: 10
            horizontalCenter: parent.horizontalCenter
        }
    }
    BusyIndicator {
        id: busyindicator
        anchors.centerIn: parent
    }
    Label {
        text: "Checking for Update ..."
       // font.pixelSize: 16
        color: "gray"
        anchors {
            top: busyindicator.bottom
            bottomMargin: 10
            horizontalCenter: parent.horizontalCenter
        }
    }

}
