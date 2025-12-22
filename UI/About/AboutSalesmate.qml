import QtQuick 2.15
import QtQuick.Controls

Page {
    id:aboutAppPage
    objectName:"AboutApp"
    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        visible: false
    }

    Component.onCompleted:  {
        busyIndicator.visible = true
    }
}
