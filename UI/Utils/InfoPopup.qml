// InfoPopup.qml
import QtQuick 2.15
import QtQuick.Controls 2.15

Popup {
    id: infoPopup
    width: parent.width * 0.8
    height: 180
    modal: true
    closePolicy: Popup.NoAutoClose
    anchors.centerIn: parent

    Rectangle {
        anchors.fill: parent
        color: "#FFFFFF" // Background color for popup
        border.color: "#CCCCCC"
        border.width: 1
        radius: 8 // Rounded corners

        Column {
            anchors.centerIn: parent
            spacing: 10 // Add spacing between elements
            width: parent.width * 0.9

            AnimatedImage {
                id: success
                width: 50
                height: 50
                fillMode: Image.PreserveAspectFit
                source: "qrc:/Asserts/icons/success.gif"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: successTxt
                text: qsTr("Stock added successfully")
                font.pixelSize: 16
                color: "gray"
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: okTxt
                text: qsTr("Close")
                font.pixelSize: 14
                color: "blue" // Highlight clickable text
                horizontalAlignment: Text.AlignHCenter
                anchors {
                    right: parent.right
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        infoPopup.close()
                    }
                }
            }
        }
    }
}
