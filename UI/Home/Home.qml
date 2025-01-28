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

    Flickable {
        id: flickable
        width: parent.width
        height: parent.height
        contentHeight: mainLayout.height
        clip: true

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
            Wanning {
                id: warning
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
                scanneriIconSource: "qrc:/Asserts/icons/barcode-scan.png"
                torshIconSource: "qrc:/Asserts/icons/touch.png"
                searchIconSource: "qrc:/Asserts/icons/icons8-search-100.png"

            }

            Label {
                id: total
                text: SalesModel.totalSale().toLocaleCurrencyString(Qt.locale("en-MW"), "MWK")
                font.pointSize: 24 * homePage.scalingFactor
                Layout.alignment: Qt.AlignHCenter
                color: "gray"
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
                        changeField.text = Number(homePage.totalSale - Number(paymentField.text)).toLocaleCurrencyString(Qt.locale("en-MW"), "MWK")
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
                    console.log("Clicked")
                    homePage.totalSale = 0.0
                    SalesModel.clearModel() //claering the model
                    Utils.resetField()
                    ////
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
