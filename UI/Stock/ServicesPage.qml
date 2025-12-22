import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import "../Utils"
import "../Utils/Utils.js" as Utils
import "../Receipt"
import QtCore
import SalesModel

Page {
    id: otherIncome
    objectName: "Services"
    property bool succesStatus: false
    property alias directionText: directionText
    signal showReceipt()

    Settings {
        id: serviceSetting
    }
    BarcodeSearch {
        id:barcode_Search
        property string selectedSku: ""
        property string _itemPrice: ""
        onClosed: {
            if(selectedSku === "" ) {
                itemsku.text = serviceModel.get(currentIndex).sku
                itemeprice.text = serviceModel.get(currentIndex).itemprice
            }else {
                itemsku.text = selectedSku
                itemeprice.text = _itemPrice
            }
        }
    }

    Flickable {
        id: flickable
        width: parent.width
        height: parent.height
        contentHeight: mainLayout.height
        clip: true

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
        }

        ColumnLayout {
            id: mainLayout
            spacing: 10
            width: parent.width * 0.9

            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 10
            }
            DirectionalText {
                id:info
                directionalText: "Click the pencil to add/delete/edit a service"
            }

            Label {
                text: qsTr("Income Source")
                font.pixelSize: 16
            }

            ComboBox {
                id: serviceType
                Layout.fillWidth: true
                editable: true
                model: serviceModel
                textRole: "name"
                currentIndex: 0
                inputMethodHints: Qt.ImhSensitiveData

                popup.width: parent.width * 0.6
                popup.x: width - popup.width

                onCurrentIndexChanged: {
                    if (currentIndex >= 0) {
                        direction.visible = false
                        code.text = serviceModel.get(currentIndex).sku;
                        serviceprice.text = serviceModel.get(currentIndex).servicePrice
                        itemeprice.text = serviceModel.get(currentIndex).itemPrice
                        itemsku.text = serviceModel.get(currentIndex).sku
                    }
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignRight
                spacing: 10

                RoundButton {
                    id: edit
                    Layout.preferredWidth: 50
                    Layout.preferredHeight: 50
                    checkable: true

                    Image {
                        anchors.centerIn: parent
                        width: 16
                        height: 16
                        source: edit.checked ? "qrc:/Asserts/icons/Edit-pink.png" : "qrc:/Asserts/icons/Edit.png"
                        fillMode: Image.PreserveAspectFit
                    }
                    onCheckedChanged: {
                        if(!checked) {
                            direction.visible = false
                        }
                    }
                }

            }
            //the edit pane
            Pane {
                Layout.fillWidth: true
                visible: edit.checked
                padding: 0

                ColumnLayout {
                    width: parent.width
                    spacing: 10 // Added spacing for better readability
                    Text {
                        text: qsTr("Edit Prices") // Change this to your preferred text
                        font.pixelSize: 16
                    }

                    TextField {
                        id: serviceprice
                        placeholderText: "Service Price"
                        Layout.fillWidth: true
                        inputMethodHints: Qt.ImhDigitsOnly
                    }

                    TextField {
                        id: itemeprice
                        placeholderText: "Item Price"
                        Layout.fillWidth: true
                        inputMethodHints: Qt.ImhDigitsOnly
                    }
                    DirectionalText {
                        id: sku_direction
                        directionalText: "The SKU must match the stock. Use the search button to check."
                        visible: itemeprice.text > 0
                    }

                    RowLayout {
                        spacing: 8
                        visible: itemeprice.text > 0

                        TextField {
                            id: itemsku
                            placeholderText: "Item SKU"
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            inputMethodHints: Qt.ImhDigitsOnly
                        }

                        RoundButton {
                            id: search
                            Layout.alignment: Qt.AlignVCenter

                            Image {
                                anchors.centerIn: parent
                                width: 20
                                height: 20
                                source: "qrc:/Asserts/icons/search.png"
                                fillMode: Image.PreserveAspectFit
                            }

                            onClicked: {
                                // Search logic here
                                barcode_Search.open()
                            }
                        }
                    }

                    DirectionalText {
                        id: direction
                        visible: false
                        directionalText: "Changes Applied Successifuly"
                    }


                    RowLayout {
                        Layout.alignment: Qt.AlignRight
                        spacing: 10
                        RoundButton {
                            id: addservice
                            Layout.preferredWidth: 50
                            Layout.preferredHeight: 50
                            visible: edit.checked

                            Image {
                                anchors.centerIn: parent
                                width: 16
                                height: 16
                                source: "qrc:/Asserts/icons/icons8-add-pink.png"
                                fillMode: Image.PreserveAspectFit
                            }
                            Layout.alignment: Qt.AlignCenter
                            onClicked: {
                                newService.open()
                            }
                        }
                        RoundButton {
                            id: deleteservice
                            Layout.preferredWidth: 50
                            Layout.preferredHeight: 50
                            visible: edit.checked

                            Image {
                                anchors.centerIn: parent
                                width: 16
                                height: 16
                                source: "qrc:/Asserts/icons/delete.png"
                                fillMode: Image.PreserveAspectFit
                            }
                            onClicked: {
                                deleteService(serviceType.currentText)
                                serviceprice.text = ""
                                itemeprice.text = ""
                                //edit.checked = false
                            }
                        }
                        RoundButton {
                            id: savebtn
                            Layout.preferredWidth: 50
                            Layout.preferredHeight: 50
                            visible: edit.checked

                            Image {
                                anchors.centerIn: parent
                                width: 16
                                height: 16
                                source: "qrc:/Asserts/icons/save.png"
                                fillMode: Image.PreserveAspectFit
                            }
                            onClicked: {
                                saveServices(serviceType.currentText,serviceprice.text,itemeprice.text,itemsku.text)

                                direction.visible = true
                            }
                        }
                    }
                    MenuSeparator {
                        Layout.fillWidth: true
                    }

                }
            }
            DirectionalText {
                id: amountDirectionalText
                visible: false
            }

            TextField {
                id: amountField
                placeholderText: "Amount"
                Layout.fillWidth: true
                inputMethodHints: Qt.ImhDigitsOnly
                visible: !edit.checked
                onTextEdited: {
                    directionText.visible = false
                    amountDirectionalText.visible = false
                }
            }

            TextField {
                id: dateField
                placeholderText: "YYYY-MM-DD"
                Layout.fillWidth: true
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                text: Utils.getCurrentDate()
                visible: !edit.checked

                onTextChanged: {
                    const validDateRegex = /^\d{0,4}(-\d{0,2}(-\d{0,2})?)?$/;
                    if (!validDateRegex.test(text)) {
                        text = text.slice(0, -1);
                    }
                }
            }

            Text {
                id: characterCounter
                text: "50 characters remaining"
                font.pixelSize: 12
                color: "gray"
                visible: !edit.checked
            }

            TextArea {
                id: descriptionField
                property int max_length: 50
                placeholderText: "Description (Max: 50 characters)"
                Layout.fillWidth: true
                Layout.preferredHeight: parent.height * 0.15
                wrapMode: TextArea.WordWrap
                font.pixelSize: 14
                visible: !edit.checked

                onTextChanged: {
                    limitCharacters(descriptionField, max_length);
                    characterCounter.text = (max_length - descriptionField.length) + " characters remaining";
                    directionText.visible = false
                    amountDirectionalText.visible = false
                }

                function limitCharacters(textArea, maxLength) {
                    if (textArea.length > maxLength) {
                        var cursorPosition = textArea.cursorPosition;
                        textArea.text = textArea.text.substring(0, maxLength);
                        textArea.cursorPosition = Math.min(cursorPosition, maxLength);
                    }
                }
            }

            TextField {
                id: code
                placeholderText: "SKU"
                Layout.fillWidth: true
                inputMethodHints: Qt.ImhDigitsOnly
                readOnly: true
                visible: !edit.checked
            }
            //save btn
            CustomButton {
                id: save
                Layout.fillWidth: true
                btnColor: "#4CAF50"
                btnRadius: 5
                btnText: "Save"
                visible: !edit.checked
                onBtnClicked: {
                    const sku = code.text.trim()
                    const date = Utils.convertToDate(dateField.text.trim())
                    const name = serviceType.currentText.trim()
                    const unit_serviceprice = parseFloat(serviceModel.get(serviceType.currentIndex).servicePrice)
                    const unit_itemprice = parseFloat(serviceModel.get(serviceType.currentIndex).itemPrice)
                    const description = descriptionField.text.trim()
                    const total = parseFloat(amountField.text.trim())
                    // Check for empty fields
                    if (total === 0.0  || isNaN(total)) {
                        amountDirectionalText.directionalText = "Amount cannot be empty."
                        amountDirectionalText.visible = true
                        return
                    } else {
                        SalesModel.addSale(name, total, 1,sku)
                        ServiceModel.addService(sku, date, name, unit_serviceprice, unit_itemprice, description, total)
                        otherIncome.succesStatus = true
                    }

                }
            }
            //Derection Text
            DirectionalText {
                id:directionText
                visible: false

            }

        }
    }
    //reserting the field
    function resertField() {
        console.log("clearing...")
        amountField.text = ""
        descriptionField.text = ""
    }

    //listmodel
    ListModel {
        id: serviceModel
        //default values
        ListElement { name: "Printing"; sku: "p-0001"; servicePrice: "100"; itemPrice: "50" }
        ListElement { name: "Photocopying"; sku: "p-0002"; servicePrice: "50"; itemPrice: "50" }
        ListElement { name: "Laminating"; sku: "l-0001"; servicePrice: "200"; itemPrice: "800" }
        ListElement { name: "Graphics"; sku: "g-0001"; servicePrice: "0"; itemPrice: "0" }
        ListElement { name: "Binding"; sku: "b-0001"; servicePrice: "0"; itemPrice: "800" }
        ListElement { name: "Scanning"; sku: "s-0001"; servicePrice: "400"; itemPrice: "0" }
        ListElement { name: "Typing"; sku: "t-0001"; servicePrice: "400"; itemPrice: "0" }
        ListElement { name: "Photo Printing"; sku: "p-0003"; servicePrice: "0"; itemPrice: "0" }
        ListElement { name: "ID Photo Printing"; sku: "p-0004"; servicePrice: "0"; itemPrice: "0" }
        ListElement { name: "Business Card Printing"; sku: "p-0007"; servicePrice: "0"; itemPrice: "0" }
    }
    // Saving settings
    function saveServices(name, newserviceprice, newitemprice, newsku) {
        for (var i = 0; i < serviceModel.count; i++) {
            var service = serviceModel.get(i);
            if (service && service.name === name) {
                serviceModel.setProperty(i, "servicePrice", newserviceprice);
                serviceModel.setProperty(i, "itemPrice", newitemprice);
                serviceModel.setProperty(i,"sku",newsku)
                return; // Exit loop early once found
            }
        }
        console.warn("Service not found:", name);
    }
    // Persisting services
    function persistServices() {
        var dataArry = [];
        for (var i = 0; i < serviceModel.count; i++) {
            var service = serviceModel.get(i);
            if (service) {
                dataArry.push(service);
            }
        }
        var jsonData = JSON.stringify(dataArry);
        serviceSetting.setValue("listModel", jsonData);
    }

    // Loading services into the model
    function loadServices() {
        let savedData = serviceSetting.value("listModel", "[]"); // Load stored data
        let parsedData;

        try {
            parsedData = JSON.parse(savedData);
        } catch (error) {
            console.error("Error parsing saved services:", error);
            return; // Exit early to prevent clearing default values
        }

        if (Array.isArray(parsedData) && parsedData.length > 0) {
            serviceModel.clear(); // Only clear if we have new data
            parsedData.forEach(item => serviceModel.append(item));
        } else {
            console.warn("No saved data found. Keeping default values.");
        }
    }

    //add a service
    function addService(newName, newServicePrice, newItemPrice) {
        if (![newName, newServicePrice, newItemPrice].every(value => value && value.trim() !== "")) {
            console.warn("Service name, service price, and item price cannot be empty");
            return false;
        }

        // Check if the service already exists
        for (var i = 0; i < serviceModel.count; i++) {
            if (serviceModel.get(i).name === newName) {
                console.warn("Service already exists:", newName);
                return false;
            }
        }
        // Append new service
        serviceModel.append({
                                name: newName,
                                sku: "custom-" + (serviceModel.count + 1),
                                servicePrice: newServicePrice,
                                itemPrice: newItemPrice
                            });

        persistServices(); // Save changes
        return true
    }

    function deleteService(name) {
        for (var i = 0; i < serviceModel.count; i++) {
            if (serviceModel.get(i).name === name) {
                serviceModel.remove(i);
                persistServices(); // Save changes after deletion
                return;
            }
        }
        console.warn("Service not found:", name);
    }

    Component.onCompleted: {
        //saving the defalt service
        loadServices();
        if (serviceType.model.length === 0) {
            persistServices();
        }
        serviceType.currentIndex = 0
    }
    Component.onDestruction: {
        console.log("OnDestration...")
        persistServices()
    }

    AddNewService{
        id:newService
        otherIncome: otherIncome

    }
    Connections {
        target: ServiceModel
        function onTotalServiceChanged () {
            resertField() // Clearing the fields
            directionText.directionalText = "Saved!!"
            directionText.colorTxt = "green"
            directionText.visible = true
        }
        function onError(){
            directionText.directionalText = "Error: Not saved!!"
            directionText.visible = true
        }
    }


}
