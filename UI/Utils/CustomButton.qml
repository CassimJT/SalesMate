import QtQuick 2.15
import QtQuick.Controls

Rectangle {
    id: customButton
    property real btnWidth: 100
    property real btnHeight: 50
    property real btnRadius: 15
    property color btnColor: "#333"
    property color btnClickedColor: "#32CD32" // Color when clicked
    property string btnIconSrc: ""
    property string btnText: ""
    signal btnClicked

    width: btnWidth
    height: btnHeight
    radius: btnRadius
    color: btnColor
    focus: true  // Enable focus for this button

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onPressed: {
            customButton.color = customButton.btnClickedColor;
            customButton.forceActiveFocus(); // Move focus to this button
        }
        onReleased: {
            customButton.color = customButton.btnColor;
            customButton.btnClicked();
        }
    }

    Row {
        id: contentRow
        spacing: 8
        anchors.centerIn: parent

        Image {
            id: btnIcon
            visible: customButton.btnIconSrc !== ""
            source: customButton.btnIconSrc
            width: customButton.btnHeight * 0.6
            height: customButton.btnHeight * 0.6
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: btnTextLabel
            text: customButton.btnText
            color: "white"
            font.pixelSize: customButton.btnHeight * 0.4
            visible: customButton.btnText !== ""
        }
    }
}
