import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import "../Utils/Utils.js" as Utils
Popup {
    id: editProduct
    width: parent.width * 0.8
    height: parent.height * 0.85
    modal: true
    closePolicy: Popup.NoAutoClose
    anchors.centerIn: parent
    padding: 0
    property string title: ""
    property string sku: ""
    property string name: ""
    property string price: ""
    property string quantity: ""
    property string dataOfCreation: ""
    property bool isReadOnly: true
    //
    Rectangle {
        id:heading
        width:parent.width
        height: 40
        radius:3
        anchors {
            top:parent.top
        }
        color: "lightgreen"
        Text {
            id: noDataText
            text: qsTr(editProduct.title)
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
                        editProduct.close()
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
                    editProduct.close()
                }
            }
        }
    }
    ColumnLayout {
        id: mainLayout
        spacing: 10
        width: parent.width * 0.9
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: heading.bottom
            topMargin: 10
        }
        //sku
        TextField {
            id: sku
            placeholderText: "sku"
            readOnly: true
            Layout.preferredWidth: parent.width
            text: qsTr(editProduct.sku)
        }
        //item name
        TextField {
            id: itemName
            placeholderText: "Item Name"
            Layout.preferredWidth: parent.width
            readOnly: editProduct.isReadOnly;
            text: qsTr(editProduct.name)
        }
        //price
        TextField {
            id: amountField
            placeholderText: "Amount"
            Layout.preferredWidth: parent.width
            inputMethodHints: Qt.ImhDigitsOnly
            readOnly: editProduct.isReadOnly;
            text: qsTr(editProduct.price)
            //allowing only numbers
            onTextChanged: {
                const validDateRegex = /^[0-9]*$/;
                if (!validDateRegex.test(text)) {
                    text = text.slice(0, -1); // Remove invalid character
                }
            }
        }
        //quantity
        TextField {
            readOnly: editProduct.isReadOnly;
            id: quantityField
            placeholderText: "Quantity"
            text: qsTr(editProduct.quantity)
            Layout.fillWidth: true
            inputMethodHints: Qt.ImhDigitsOnly
            //allowing only numbers
            onTextChanged: {
                const validDateRegex = /^[0-9]*$/;
                if (!validDateRegex.test(text)) {
                    text = text.slice(0, -1); // Remove invalid character
                }
            }
        }
        //date
        TextField {
            id: dateField
            placeholderText: "Date of Creation"
            readOnly: true
            Layout.fillWidth: true
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            Component.onCompleted: {
                dateField.text = Utils.getCurrentDate()
            }

            onTextChanged: {
                const validDateRegex = /^\d{0,4}(-\d{0,2}(-\d{0,2})?)?$/;
                if (!validDateRegex.test(text)) {
                    text = text.slice(0, -1); // Remove invalid character
                }
            }

            onEditingFinished: {
                const fullDateRegex = /^\d{4}-\d{2}-\d{2}$/;
                if (!fullDateRegex.test(text)) {
                    console.log("Invalid date format! Use YYYY-MM-DD.");
                } else {
                    console.log("Valid date entered:", text);
                }
            }
        }
    }
    //edit btn
    RoundButton {
        id:edit
        width: 50
        height: width
        checkable: true
        //color: "lightgreen"
        // Camera Icon
        Image {
            id: _edit
            anchors.centerIn: parent
            width: 16
            height: width
            source: edit.checked ? "qrc:/Asserts/icons/icons8-edit-pink.png":"qrc:/Asserts/icons/icons8-edit-100.png"
            fillMode: Image.PreserveAspectFit
        }
        anchors {
            right: parent.right
            bottom: parent.bottom
            rightMargin: 10
            bottomMargin: 10
        }
        onCheckedChanged:{
            if(checked) {
                row.visible = true
                editProduct.isReadOnly = false
            } else {
                row.visible = false
                editProduct.isReadOnly = true
            }
        }
    }
    //
    Row{
        id:row
        visible: false
        RoundButton {
            id:_update
            width: 50
            height: width
            Image {
                id: update
                anchors.centerIn: parent
                width: 16
                height: width
                source: "qrc:/Asserts/icons/upload-48.png"
                fillMode: Image.PreserveAspectFit
            }
        }
        RoundButton {
            id:_delete
            width: 50
            height: width
            Image {
                id: deleteBtn
                anchors.centerIn: parent
                width: 16
                height: width
                source: "qrc:/Asserts/icons/delete.png"
                fillMode: Image.PreserveAspectFit
            }
        }
        anchors {
            right: edit.left
            verticalCenter: edit.verticalCenter
        }
    }
}
