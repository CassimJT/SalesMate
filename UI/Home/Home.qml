import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import "../Utils"
import "../Utils/Utils.js" as Utils
import "../Stock"
import SalesModel

Page {
    id: homePage
    objectName: "Home"

    property real screenWidth: Screen.width
    property real screenHeight: Screen.height

    // Scaling factor for proportional resizing
    property real scalingFactor: Math.min(screenWidth / 360, screenHeight / 640)

    // Height calculations with tablet support
    property real totalTextFiledHeight: amountField.height * 3
    property real totalHeightFor4Item: totalTextFiledHeight + total.height
    property int totalHeightFor3Item: Math.round(screenHeight) - totalHeightFor4Item

    // Example adjustments for tablet vs. phone
    property bool isTablet: screenHeight > 800 || screenWidth > 600
    property real buttonHeight: isTablet ? totalHeightFor3Item * 0.07 : totalHeightFor3Item * 0.10
    property real itemPrice: 0.0
    property int quantity: 0
    property real totalSale: 0.0

    //current sale variable
    property string name : ""
    //property alias currentSalesModel: currentSalesModel

    //a popup to search for a barcode if scannaer not working
    BarcodeSearch {
        id:searchItem
    }
    Flickable {
        id: flickable
        width: parent.width
        height: parent.height
        contentHeight: mainLayout.height
        clip: true
        bottomMargin: 20

        Component.onCompleted: {
            console.log("ScreenHeight: " + homePage.screenHeight)
            console.log("ScreenWidth: " + homePage.screenWidth)
            console.log("Scaling Factor: " + homePage.scalingFactor)
        }

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

            TextField {
                id: amountField
                placeholderText: "Amount"
                readOnly: true
                text: Number(homePage.itemPrice).toLocaleCurrencyString(Qt.locale("en-MW"), "MWK")
                Layout.preferredWidth: parent.width
                inputMethodHints: Qt.ImhDigitsOnly
            }
            DirectionalText {
                id: warning
                directionalText: "Quantity cannot be 0/empty"
                visible: homePage.quantity === 0 || quantityField.text === "" ? true : false
            }
            RowLayout {
                spacing: 5
                id: row

                TextField {
                    id: quantityField
                    placeholderText: "Quantity"
                    text: homePage.quantity !== undefined ? homePage.quantity.toString() : ""
                    Layout.fillWidth: true
                    inputMethodHints: Qt.ImhDigitsOnly
                    onTextChanged: {

                        const validDateRegex = /^[0-9]*$/;
                        if (!validDateRegex.test(quantityField.text)) {
                            // Remove the last invalid character
                            quantityField.text = quantityField.text.slice(0, -1);
                        }
                    }
                    onTextEdited: {
                        if (quantityField.text !== "" && homePage.quantity !== 0) {
                            homePage.quantity = Number(quantityField.text);
                            SalesModel.updateItem(homePage.name, homePage.quantity, homePage.itemPrice);
                        }
                    }
                }

                RoundButton {
                    id: plus
                    text: qsTr("+")
                    Layout.preferredWidth: 50 * homePage.scalingFactor
                    Layout.preferredHeight: 50 * homePage.scalingFactor
                    property bool isFocused: quantityField.activeFocus
                    onClicked: {
                        // Check if the field is already focused before calling forceActiveFocus
                        if (!isFocused) {
                            quantityField.forceActiveFocus();
                            isFocused = true; // Track the state of the focus manually
                        }
                        homePage.quantity += 1;
                        homePage.totalSale += homePage.itemPrice
                        SalesModel.updateItem(homePage.name, homePage.quantity, homePage.itemPrice);
                    }
                    // Reset the focus state when focus changes
                    onFocusChanged: {
                        isFocused = quantityField.activeFocus;
                    }
                }
            }

            BarcodeScanner {
                id: barcodeScanner
                Layout.fillWidth: true
                //visible: mainStakView.currentItem.objectName ? "true": false
                barCodeWidth: parent.width
                barcodeHight: homePage.totalHeightFor3Item * 0.30
                scanneriIconSource: "qrc:/Asserts/icons/barcode-scan-green.png"
                torshIconSource: "qrc:/Asserts/icons/touch-green.png"
                searchIconSource: "qrc:/Asserts/icons/icons8-search-green.png"
                onSearchBtnClciked: {
                    console.log("Seach clicked ..")
                    searchItem.open()
                }
            }

            Label {
                id: total
                text: SalesModel.totalSale().toLocaleCurrencyString(Qt.locale("en-MW"), "MWK")
                font.pointSize: 24 * homePage.scalingFactor
                Layout.alignment: Qt.AlignHCenter
                color: "gray"
            }
            DirectionalText {
                id:  payementDiretionText
                visible: false
                directionalText: "Payment and total cannot be empty"
            }

            RowLayout {
                spacing: 5
                Layout.fillWidth: true
                TextField {
                    id: paymentField
                    placeholderText: "Payment"
                    Layout.fillWidth: true
                    inputMethodHints: Qt.ImhDigitsOnly
                    onTextEdited : {
                        payementDiretionText.visible = false
                        changeField.text = ( Number(paymentField.text) - SalesModel.totalSale() ).toLocaleCurrencyString(Qt.locale("en-MW"), "MWK")
                    }

                }
                TextField {
                    id: changeField
                    placeholderText: "Change"
                    Layout.fillWidth: true
                    readOnly:true
                }
            }
            //add to cart b
            CustomButton {
                id: nextItem
                Layout.fillWidth: true
                btnColor: "#4CAF50"
                btnRadius: 5
                btnHeight: homePage.buttonHeight
                btnIconSrc: "qrc:/Asserts/icons/nextitem.png"
                btnText: "Next Item"
                onBtnClicked: {
                    console.log("Clicked")
                    //appeding items to current sales page
                    barcodeScanner.output.visible = true
                    if(!barcodeScanner.camera.active){
                        barcodeScanner.camera.start()
                        barcodeScanner.frameTimer.start()
                        barcodeScanner.showRecycle = false
                        //reset all filed
                        Utils.resetField()
                    }else{
                        ///
                    }
                }
            }
            //make sales btn
            CustomButton {
                id: makeSales
                Layout.fillWidth: true
                btnColor: "#4CAF50"
                btnRadius: 5
                btnHeight: homePage.buttonHeight
                btnIconSrc: "qrc:/Asserts/icons/sale.png"
                btnText: "Make Sales"
                onBtnClicked: {
                    let paymentAmount = Number(paymentField.text); // Convert text to a number
                    let totalSaleAmount = SalesModel.totalSale(); // Get total sale amount

                    if (paymentField.text !== "" && totalSaleAmount > 0) {
                        if (paymentAmount >= totalSaleAmount) {
                            homePage.totalSale = 0.0;
                            Utils.resetField();
                            payementDiretionText.visible = false; // Hide error message
                            //.....

                            SalesModel.clearModel()
                        } else {
                            payementDiretionText.directionalText = "Payment must be greater than total";
                            payementDiretionText.visible = true;
                        }
                    } else {
                        payementDiretionText.visible = true;
                    }
                }

            }
        }
    }
    Connections {
        target: barcodeEngine
        onBarcodeChanged: {
            console.log("Signal Triggered..");
            const sku = barcodeEngine.barcode;
            const product = databaseManager.queryDatabase(sku);
            if (product) {
                console.log("Price:", product.price);
                homePage.itemPrice = product.price
                homePage.name = product.name
                homePage.quantity = 1
                homePage.totalSale += product.price
                SalesModel.addSale(homePage.name,homePage.itemPrice,homePage.quantity)
            } else {
                console.log("Product not found for SKU:", sku);
            }
        }
    }

}
