import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

RowLayout {
    id: directionText
    spacing: 10
    anchors {
        left:parent.left
        leftMargin: 15
    }

    Image {
        id: infoIcon
        Layout.preferredWidth: 16
        Layout.preferredHeight: 16
        source: "qrc:/Asserts/icons/icons8-info-100.png"
        fillMode: Image.PreserveAspectFit
    }

    Label {
        id: info
        text: qsTr("Field cannot be Empty or 0")
        color: "red"
        wrapMode: Text.Wrap
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
    }
}
