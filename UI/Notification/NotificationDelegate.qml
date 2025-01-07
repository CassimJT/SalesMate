import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ItemDelegate {
    id: delegate
    width: parent.width
    height: implicitHeight // Adjust height based on your requirement
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
        Text{
            id:msg
            text: qsTr(model.msg)
            Layout.preferredWidth: parent.width - deleteItem.width
            wrapMode: TextArea.WordWrap
        }
        Image {
            id: deleteItem
            source: "qrc:/Asserts/icons/delete.png"
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            fillMode: Image.PreserveAspectFit
            Layout.alignment: Qt.AlignRight
        }
    }

}
