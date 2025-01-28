// InfoPopup.qml
import QtQuick 2.15
import QtQuick.Controls 2.15

Popup {
    id: infoPopup
    width: parent.width * 0.8
    height: 220
    modal: true
    closePolicy: Popup.NoAutoClose
    anchors.centerIn: parent

    // Public properties to make it reusable
    property string iconSource: "" // Path to the icon/gif
    property string message: "Default message" // Display message
    property string buttonText: "Close" // Button text
    property color backgroundColor: "#FFFFFF"
    property color borderColor: "#CCCCCC"
    property bool isCancelVisible: false
    property int borderRadius: 8
    signal clicked()
    signal canceled()

    Rectangle {
        anchors.fill: parent
        color: infoPopup.backgroundColor
        border.color: infoPopup.borderColor
        border.width: 1
        radius: infoPopup.borderRadius

        Column {
            id: column
            anchors.centerIn: parent
            spacing: 10
            width: parent.width * 0.9
            anchors {
                top: parent.top
                topMargin: 10
            }

            // Optional icon
            AnimatedImage {
                id: iconImage
                visible: infoPopup.iconSource !== ""
                width: 50
                height: 50
                fillMode: Image.PreserveAspectFit
                source: infoPopup.iconSource
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // Dynamic message
            Text {
                id: messageText
                text: infoPopup.message
                width: parent.width * 0.8
                font.pixelSize: 16
                color: "gray"
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.Wrap
            }

            // Dynamic button
        }
        Row {
            anchors {
                right: parent.right
                bottom: parent.bottom
                rightMargin:10
                bottomMargin:10
                top: column.bottom
                topMargin: 10
            }
            spacing: 20
            Text {
                id: cancelText
                text: qsTr("Cancel")
                font.pixelSize: 14
                color: "green" // Highlight clickable text
                horizontalAlignment: Text.AlignHCenter
                visible: infoPopup.isCancelVisible

                MouseArea {
                    anchors.fill:parent
                    onClicked:{
                        infoPopup.close()
                    }
                }

            }
            Text {
                id: buttonTextItem
                text: infoPopup.buttonText
                font.pixelSize: 14
                color: "green" // Highlight clickable text
                horizontalAlignment: Text.AlignHCenter

                MouseArea {
                    anchors.fill:parent
                    onClicked:{
                        infoPopup.clicked();
                    }
                }

            }
        }
    }
}
