import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: heading
    width: parent.width
    height: 50
    anchors {
        top: directionText.bottom
    }
    RowLayout {
        width: parent.width
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
            topMargin: 10
            leftMargin: 16
            rightMargin: 15
        }

        //name
        Label {
            id: name
            text: qsTr("Name")
            Layout.alignment: Qt.AlignLeft
            font.bold: true
            Layout.preferredWidth: 100
        }
        //quantity
        Label {
            id: quantity
            text: qsTr("Quantity")
            Layout.alignment: Qt.AlignCenter
            font.bold: true
            Layout.preferredWidth: 100
        }
        //price
        Label {
            id: price
            text: qsTr("Unit Price")
            Layout.alignment: Qt.AlignRight
            font.bold: true
            Layout.preferredWidth: 70
        }
    }
}
