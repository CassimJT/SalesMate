import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

RowLayout {
    id: direction
    spacing: 10
    //width: parent.width
    property color colorTxt: "red"
    property string directionalText: ""
    property string directionalIcon: "qrc:/Asserts/icons/icons8-info-100.png" //defalt

    Image {
        id: infoIcon
        Layout.preferredWidth: 16
        Layout.preferredHeight: 16
        source: direction.directionalIcon
        fillMode: Image.PreserveAspectFit
    }

    Label {
        id: info
        //Layout.preferredWidth: parent.width
        Layout.fillWidth: true
        text: direction.directionalText
        color: direction.colorTxt
        wrapMode: Text.Wrap
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
    }
}
