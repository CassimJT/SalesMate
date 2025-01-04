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
                barCodeWidth: parent.width
                barcodeHight: homePage.totalHeightFor3Item * 0.30
                scanneriIconSource: "qrc:/Asserts/icons/barcode-scan.png"
                torshIconSource: "qrc:/Asserts/icons/touch.png"
                searchIconSource: "qrc:/Asserts/icons/search.png"

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
                }
            }
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
        AnimatedImage {
            id: giff
            width: 36
            height: width
            anchors {
                horizontalCenter:parent.horizontalCenter
            }
            source: "qrc:/Asserts/icons/animeted-cart.gif"
            fillMode:Image.PreserveAspectFit
            Rectangle {
                id: contentRec
                color: "red"
                width: 14
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
                }
                //MouseArea
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if(mainStakView.depth > 1) {
                            mainStakView.pop()
                        }else {
                            mainStakView.push("../Stock/ShowSalesPage.qml")
                        }
                    }
                }
            }
        }
    }
}
