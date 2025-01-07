import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ItemDelegate {
    id: delegate
    width: parent.width
    height: 50 // Adjust height based on your requirement
    RowLayout {
        anchors {
            left: parent.left
            right: parent.right
            leftMargin: 16
            rightMargin: 15
            horizontalCenter: parent.horizontalCenter
            verticalCenter : parent.verticalCenter
        }

        // Item name
        Label {
            id: name
            text: qsTr(model.name)
            Layout.alignment: Qt.AlignLeft
            Layout.preferredWidth: 100 // Set a preferred width
            elide: Label.ElideRight // Prevent overflow
        }

        // Item quantity
        Label {
            id: quantity
            text: qsTr(model.quantity)
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: 50
        }

        // Item price
        Label {
            id: price
            text: qsTr("MK"+model.price)
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: 80
        }
        // Delete item icon
        Image {
            id: deleteItem
            source: "qrc:/Asserts/icons/delete.png"
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            fillMode: Image.PreserveAspectFit
            Layout.alignment: Qt.AlignRight
        }
    }
    MenuSeparator {
        width:parent.width
        anchors {
            bottom: parent.bottom
        }
    }
}
