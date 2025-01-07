import QtQuick 2.15
import QtQuick.Controls

Page {
    // ListView
    objectName: "Notification"
    ListView {
        id: listview
        clip: true
        model: NotificationModel{}
        delegate: NotificationDelegate {}
        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
            bottom: parent.bottom
            topMargin: 10
        }
    }

    Text {
        id: noDataText
        text: qsTr("No Notification")
        anchors.centerIn: parent
        font.pixelSize: 16
        color: "gray"
        visible: listview.model.count === 0 // Show text only when model is empty
    }
}
