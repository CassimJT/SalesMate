import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

Popup {
    id: newService
    width: parent.width * 0.8
    height: parent.height * 0.55
    modal: true
    closePolicy: Popup.NoAutoClose
    anchors.centerIn: parent
    signal clicked()
    property var otherIncome
    padding: 0
    Rectangle {
        id:heading
        width:parent.width
        height: 50
        radius:3
        anchors {
            top:parent.top
        }
        color: "lightgreen"
        Text {
            id: noDataText
            text: qsTr("New Service")
            anchors.centerIn: parent
            font.pixelSize: 16
            color: "gray"
        }
    }
    ColumnLayout {
        width: parent.width
        anchors {
            top: heading.bottom
            topMargin: 10
            right: parent.right
            left: parent.left
            leftMargin: 10
            rightMargin: 10
        }

        spacing: 10
        TextField {
            id:servicename
            Layout.fillWidth: true
            placeholderText: "Service Name"
            onTextChanged: {
                direction.visible = false
            }
        }
        TextField {
            id:servicePrice
            Layout.fillWidth: true
            placeholderText: "Service Price"
        }
        TextField {
            id:itePrice
            Layout.fillWidth: true
            placeholderText: "Item Price"
        }
        DirectionalText {
            Layout.fillWidth: true
            id: direction
            visible: false
        }

    }

    Row {
        anchors {
            right: parent.right
            bottom: parent.bottom
            rightMargin: 10
            bottomMargin: 10
        }

        RoundButton {
            id: close
            width: 50
            height: 50
            visible: edit.checked

            Image {
                id: closeIcon
                anchors.centerIn: parent
                width: 16
                height: width
                source: "qrc:/Asserts/icons/close-100-red.png"
                fillMode: Image.PreserveAspectFit
            }
            onClicked: {
                newService.close()
            }
        }

        RoundButton {
            id: savebtn
            width: 50
            height: 50
            visible: edit.checked

            Image {
                anchors.centerIn: parent
                width: 16
                height: 16
                source: "qrc:/Asserts/icons/save.png"
                fillMode: Image.PreserveAspectFit
            }
            onClicked: {
                if(otherIncome.addService(servicename.text,servicePrice.text,itePrice.text)) {
                    direction.directionalText = "Service Added"
                    servicePrice.text = ""
                    itePrice.text = ""
                    servicename.text = ""
                    direction.visible = true
                } else {
                    direction.directionalText = "Service already exist / check that all field are not empty"
                    direction.visible = true
                }

            }
        }

    }
    onClosed: {
        console.log("Closed..")
        direction.visible = false
    }

}
