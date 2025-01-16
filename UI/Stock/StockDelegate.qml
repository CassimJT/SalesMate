import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ItemDelegate {
    id: delegate
    width: parent.width
    height: 50 // Adjust height based on your requirement
    Rectangle {
        id: background
        anchors.fill: parent
        color: index % 2 === 0 ? "#f5f5f5":"#ffffff"
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
        // Item name
        Label {
            id: name
            text: model.name
            Layout.alignment: Qt.AlignLeft
            Layout.preferredWidth: 120
            elide: Label.ElideRight
        }
        // Item quantity
        Label {
            id: quantity
            text: model.quantity
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: 100
        }

        // Item price
        Label {
            id: price
            text:"K"+ model.price
            Layout.alignment: Qt.AlignRight
            Layout.preferredWidth: 70

        }
    }

}
