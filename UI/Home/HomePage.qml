import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import "../Utils"

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
                Layout.preferredWidth: parent.width
                inputMethodHints: Qt.ImhDigitsOnly
                text: qsTr("MK" + homePage.itemPrice)
            }

            RowLayout {
                spacing: 5
                TextField {
                    id: quantityField
                    placeholderText: "Quantity"
                    Layout.fillWidth: true
                    inputMethodHints: Qt.ImhDigitsOnly
                }
                RoundButton {
                    id: plus
                    text: qsTr("+")
                    Layout.preferredWidth: 40 * homePage.scalingFactor
                    Layout.preferredHeight: 40 * homePage.scalingFactor
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
                text: qsTr("MK 00.00")
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
                id: addToCart
                Layout.fillWidth: true
                btnColor: "#4CAF50"
                btnRadius: 5
                btnHeight: homePage.buttonHeight
                btnIconSrc: "qrc:/Asserts/icons/cart.png"
                btnText: "Cart"
                onBtnClicked: {
                    console.log("Clicked")
                    barcodeScanner.output.visible = true
                    if(!barcodeScanner.camera.active){
                        barcodeScanner.camera.start()
                        barcodeScanner.frameTimer.start()
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
                }
            }
        }
    }
    footer: Rectangle {
        id: status
        width:parent.width
        height: 50
        Row {
            anchors.centerIn: parent
            spacing: 15
            AnimatedImage {
                id: giff
                width: 36
                height: width
                source: "qrc:/Asserts/icons/animeted-cart.gif"
                fillMode:Image.PreserveAspectFit
                Rectangle {
                    id: contentRec
                    color: "red"
                    width: 16
                    height: width
                    radius: width
                    anchors {
                        right: parent.right
                    }
                    Text {
                        id: contentTxt
                        text: "0"
                        font.pointSize: 9
                        anchors.centerIn: parent
                        color: "#ffffff"
                    }
                    //MouseArea
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            mainStakView.push("../Stock/ShowSalesPage.qml")
                        }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        mainStakView.push("../Stock/ShowSalesPage.qml")
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
            } else {
                console.log("Product not found for SKU:", sku);
            }
        }
    }
}
