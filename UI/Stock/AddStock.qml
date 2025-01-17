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
                scanneriIconSource: "qrc:/Asserts/icons/barcode-scan.png"
                torshIconSource: "qrc:/Asserts/icons/touch.png"
            }

            TextField {
                id: itemName
                placeholderText: "Item Name"
                Layout.preferredWidth: parent.width
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
                property int value: 0
                TextField {
                    id: quantityField
                    placeholderText: "Quantity"
                    text: qsTr(row.value)
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
                    Layout.preferredWidth: 40 * page.scalingFactor
                    Layout.preferredHeight: 40 * page.scalingFactor
                    onClicked :{
                        row.value += 1
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
                    text = Utils.getCurrentDate(); // Use the function to set the date
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
                btnColor: "#4CAF50"
                btnRadius: 5
                btnHeight: page.buttonHeight
                btnText: "Save"
                onBtnClicked: {
                   if (itemName.text === "") {
                        itemName.focus = false;
                        itemName.forceActiveFocus()
                        itemName.placeholderText = "Enter item name";
                        return;
                    } else if (amountField.text === "") {
                        amountField.focus = false;
                        amountField.forceActiveFocus()
                        amountField.placeholderText = "Enter amount";
                        return;
                    } else if (quantityField.text === "") {
                        quantityField.focus = false;
                        quantityField.forceActiveFocus()
                        quantityField.placeholderText = "Enter quantity";
                        return;
                    } else if(barcodeScn.barcode === "") {
                        return;
                    }

                    const name = itemName.text;
                    const sku = barcodeScn.barcode;
                    const quantity = parseInt(quantityField.text);
                    const price = parseFloat(amountField.text);

                    // Add entry to the database
                    databaseManager.addProductToDatabase(name, sku, quantity, price);
                    // Clear fields after saving
                    reset();
                }
            }
        }
    }
    function reset() {
        itemName.text = "";
        amountField.text = "";
        quantityField.text = "";
        dateField.text = ""
        barcodeScn.showRecycle = false
        barcodeScn.camera.stop()
        barcodeScn.camera.start()
        barcodeScn.output.visible = true
        barcodeScn.frameTimer.restart()
    }
    //information Popup
        InfoPopup {
            id: infor
            visible: false // Start with popup hidden
        }
    //when a new product is added succsesfuly
    Connections {
        target: databaseManager
        onNewProductAdded: function (){
            infor.open()
            barcodeScn.barcode  = ""
        }
    }
}
