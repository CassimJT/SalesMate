import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import "../Utils"
import "../Utils/Utils.js" as Utils

Page {
    id: page
    objectName: "Add Stock"
    property real screenWidth: Screen.width
    property real screenHeight: Screen.height

    property real scalingFactor: Math.min(screenWidth / 360, screenHeight / 640)
    property real totalTextFiledHeight: amountField.height * 3
    property real totalHeightFor4Item: totalTextFiledHeight
    property int totalHeightFor3Item: Math.round(screenHeight) - totalHeightFor4Item
    property bool isTablet: screenHeight > 800 || screenWidth > 600
    property real buttonHeight: isTablet ? totalHeightFor3Item * 0.07 : totalHeightFor3Item * 0.10
    property bool isScanMode: false


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
            // Barcode Scanner
            BarcodeScanner {
                id: barcodeScn
                Layout.fillWidth: true
                barCodeWidth: parent.width
                barcodeHight: page.totalHeightFor3Item * 0.30
                scanneriIconSource: "qrc:/Asserts/icons/barcode-scan-green.png"
                torshIconSource: "qrc:/Asserts/icons/touch-green.png"
            }

            TextField {
                id: itemName
                placeholderText: "Item Name"
                Layout.preferredWidth: parent.width
            }
            TextField {
                id: costPrice
                placeholderText: "Order Price"
                Layout.preferredWidth: parent.width
                inputMethodHints: Qt.ImhDigitsOnly
                //allowing only numbers
                onTextChanged: {
                    const validDateRegex = /^[0-9]*$/;
                    if (!validDateRegex.test(text)) {
                        text = text.slice(0, -1); // Remove invalid character
                    }
                }
            }

            TextField {
                id: amountField
                placeholderText: "Amount"
                Layout.preferredWidth: parent.width
                inputMethodHints: Qt.ImhDigitsOnly
                //allowing only numbers
                onTextChanged: {
                    const validDateRegex = /^[0-9]*$/;
                    if (!validDateRegex.test(text)) {
                        text = text.slice(0, -1); // Remove invalid character
                    }
                }
            }

            RowLayout {
                spacing: 5
                id: row

                TextField {
                    id: quantityField
                    placeholderText: "Quantity"
                    text: parseInt(0)
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
                RoundButton {
                    id: plus
                    text: qsTr("+")
                    Layout.preferredWidth: 50 * page.scalingFactor
                    Layout.preferredHeight: 50 * page.scalingFactor

                    property bool isFocused: quantityField.activeFocus

                    onClicked: {
                        // Check if the field is already focused before calling forceActiveFocus
                        if (!isFocused) {
                            quantityField.forceActiveFocus();
                            isFocused = true; // Track the state of the focus manually
                        }

                        // Increment the value in the field
                        let currentValue = parseInt(quantityField.text) || 0;  // Default to 0 if not a valid number
                        quantityField.text = (currentValue + 1).toString();
                    }

                    // Reset the focus state when focus changes
                    onFocusChanged: {
                        isFocused = quantityField.activeFocus;
                    }
                }

            }

            TextField {
                id: dateField
                placeholderText: "YYYY-MM-DD"
                Layout.fillWidth: true
                inputMethodHints: Qt.ImhFormattedNumbersOnly

                // Set the current date on component initialization
                Component.onCompleted: {
                    text = Utils.getCurrentDate();
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
            CustomButton {
                id: save
                Layout.fillWidth: true
                btnIconSrc: isScanMode ? "qrc:/Asserts/icons/barcode-scan.png":"qrc:/Asserts/icons/save.png"
                btnColor: "#4CAF50"
                btnRadius: 6
                btnHeight: page.buttonHeight
                btnText: isScanMode ? "Scan" : "Save"

                onBtnClicked: {

                    // ────────────── SCAN MODE ──────────────
                    if (!isScanMode) {
                        // ────────────── VALIDATION ──────────────
                        if (itemName.text.trim() === "") {
                            itemName.forceActiveFocus()
                            itemName.placeholderText = "Enter item name"
                            return
                        }

                        if (costPrice.text.trim() === "") {
                            costPrice.forceActiveFocus()
                            costPrice.placeholderText = "Enter cost price"
                            return
                        }

                        if (amountField.text.trim() === "") {
                            amountField.forceActiveFocus()
                            amountField.placeholderText = "Enter amount"
                            return
                        }

                        if (quantityField.text.trim() === "") {
                            quantityField.forceActiveFocus()
                            quantityField.placeholderText = "Enter quantity"
                            return
                        }

                        if (barcodeScn.barcode === "") {
                            console.log("No barcode scanned")
                            return
                        }

                        // ────────────── SAVE ──────────────
                        const name = itemName.text
                        const sku = barcodeScn.barcode
                        const quantity = parseInt(quantityField.text)
                        const quantitysold = 0
                        const price = parseFloat(amountField.text)
                        const cp = parseFloat(costPrice.text)
                        const date = Utils.convertToDate(dateField.text)

                        console.log("Adding Product:", name, sku, quantity, quantitysold, price, date)

                        databaseManager.addProduct(
                                    name,
                                    sku,
                                    quantity,
                                    quantitysold,
                                    price,
                                    cp,
                                    date
                                    )

                    }else {
                        barcodeScn.camera.start()
                        BarcodeEngine.setVideoSink(barcodeScn.output.videoSink)
                        page.isScanMode = false
                    }

                }
            }

        }
    }
    function reset() {
        itemName.text = "";
        amountField.text = "";
        quantityField.text = "";
        //dateField.text = ""
        barcodeScn.showRecycle = false
        barcodeScn.camera.stop()
        barcodeScn.camera.start()
        barcodeScn.output.visible = true
        barcodeScn.isCameraActive = false

    }
    //information Popup when success
    InfoPopup {
        id: successPopup
        iconSource: "qrc:/Asserts/icons/success.gif"
        message: qsTr("Stock added successfully")
        buttonText: qsTr("Okay")
        onClicked: {
            reset();
            successPopup.close();
        }
    }
    //popup info when the ite aready exist
    InfoPopup {
        id:error
        iconSource: "qrc:/Asserts/icons/icons8-error.gif"
        message: qsTr("Product Already Exist")
        buttonText: qsTr("Okay")
        onClicked: {
            //clear field
            reset();
            error.close();
        }
    }
    //Floating button
    Button {
        id: next
        icon.source: "qrc:/Asserts/stock/item.svg"
        text: qsTr("Next")
        visible: barcodeScn.isCameraActive
        opacity: 0.7
        x: parent.width - width - 24
        y: (parent.height - height) * 0.61
        font.pixelSize: 12
        Material.background: Material.accent

        DragHandler {
            target: next
            grabPermissions: PointerHandler.CanTakeOverFromAnything
        }

        onClicked: {
            reset()
        }
    }
    //when a new product is added succsesfuly
    Connections {
        target: databaseManager
        function onNewProductAdded() {
            successPopup.open()
            barcodeScn.barcode  = ""
        }
        function onProductExists() {
            error.open()
            barcodeScn.barcode  = ""
        }
    }
    Component.onCompleted: {
        page.isScanMode = true
    }
}
