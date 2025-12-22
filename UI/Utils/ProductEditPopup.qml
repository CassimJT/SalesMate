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
    property string cp: ""
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
            id: skuField
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
        //item cost price
        TextField {
            id: costPrice
            placeholderText: "Cost Price"
            Layout.preferredWidth: parent.width
            inputMethodHints: Qt.ImhDigitsOnly
            readOnly: editProduct.isReadOnly;
            text: qsTr(editProduct.cp)
            //allowing only numbers
            onTextChanged: {
                const validDateRegex = /^[0-9]*$/;
                if (!validDateRegex.test(text)) {
                    text = text.slice(0, -1); // Remove invalid character
                }
            }
        }
        //price
        TextField {
            id: priceField
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
            id: quantityField
            readOnly: editProduct.isReadOnly;
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
    Row {
        id: infoRow
        width: parent.width * 0.85
        spacing: 10
        anchors {
            top: mainLayout.bottom
            topMargin: 5
            horizontalCenter:parent.horizontalCenter
        }

        Image {
            id: infoIcon
            width: 16
            height: width
            source: "qrc:/Asserts/icons/icons8-info-100.png"
            fillMode: Image.PreserveAspectFit
        }

        Label {
            id: info
            width: parent.width - infoIcon.width - editProduct.spacing
            height: implicitHeight
            text: qsTr("Click the pencil to switch to edit mode")
            color: "red"
            wrapMode: Text.Wrap
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
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
                info.text = qsTr("Click the pencil to switch to edit mode")
            } else {
                row.visible = false
                info.text = qsTr("Click the pencil to switch to edit mode")
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
                source: "qrc:/Asserts/icons/save.png"
                fillMode: Image.PreserveAspectFit
            }
            onClicked:{
                const name = itemName.text
                const sku = skuField.text
                const quantity = quantityField.text
                const price = parseFloat (priceField.text)
                const cp = parseFloat(costPrice.text)
                databaseManager.updateProduct(name,sku,quantity,price,cp)
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
            onClicked: {
                //open the popup
                confirmDelete.open()
            }
        }
        anchors {
            right: edit.left
            verticalCenter: edit.verticalCenter
        }
    }
    Connections {
        target: databaseManager
       function onProductAlreadyExist() {
            console.log("Product aleady exist")
            info.text = "No Changes to update!!"
        }
        function onProductUpdated() {
            console.log("Update succes!!")
            info.text = "Update succes!!"
        }
        //emited when the product is succefuly removed
        function onProductRemoved() {
            successPopup.open()
        }
    }
    InfoPopup {
        id: confirmDelete
        iconSource: "qrc:/Asserts/icons/icons8-error.gif"
        message: qsTr("This operation will delete the Product from the system.")
        buttonText: qsTr("Ok")
        isCancelVisible: true
        onClicked: {
            confirmDelete.close();
            const sku = skuField.text
            databaseManager.removeProduct(sku)
        }
    }
    InfoPopup {
        id: successPopup
        iconSource: "qrc:/Asserts/icons/success.gif"
        message: qsTr("Stock Deleted Successfully")
        buttonText: qsTr("Ok")
        onClicked: {
            successPopup.close();
            editProduct.close()
        }
    }

}
