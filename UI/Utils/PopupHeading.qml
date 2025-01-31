import QtQuick 2.15
import QtQuick.Controls
Rectangle {
    id:heading
    //
   property string title: ""
    signal clicked()

    width:parent.width
    height: 40
    radius:3
    anchors {
        top:parent.top
    }
    color: "lightgreen"
    Text {
        id: noDataText
        text: qsTr(heading.title)
        anchors.centerIn: parent
        font.pixelSize: 16
        color: "gray"
    }
    Rectangle {
        width: 28
        height: width
        radius: width / 2
        color: "lightblue"
        // Close Icon
        Image {
            id: close
            anchors.centerIn: parent
            width: 16
            height: width
            source: "qrc:/Asserts/icons/close-100-red.png"
            fillMode: Image.PreserveAspectFit
            MouseArea {
                anchors.fill:parent
                onClicked: {
                    heading.clicked()
                }
            }
        }
        anchors {
            right: parent.right
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }
        MouseArea {
            anchors.fill:parent
            onClicked: {
                heading.clicked()
            }
        }
    }
}

