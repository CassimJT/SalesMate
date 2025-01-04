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
    property real totalHeightFor4Item: totalTextFiledHeight
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
            //barcode scanner
            BarcodeScanner {
                id: barcodeScanner
                Layout.fillWidth: true
                barCodeWidth: parent.width
                barcodeHight: homePage.totalHeightFor3Item * 0.30
                scanneriIconSource: "qrc:/Asserts/icons/barcode-scan.png"
                torshIconSource: "qrc:/Asserts/icons/touch.png"
                generateIcconSource: "qrc:/Asserts/icons/generate.png"
            }
            TextField {
                id: itenName
                placeholderText: "Item Name"
                Layout.preferredWidth: parent.width
                //inputMethodHints: Qt.ImhDigitsOnly
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
            TextField {
                id: dateField
                placeholderText: "YYYY-MM-DD"
                Layout.fillWidth: true

                // Limit input to numbers and dashes
                inputMethodHints: Qt.ImhFormattedNumbersOnly

                // Validate and enforce date format
                onTextChanged: {
                    const validDateRegex = /^\d{0,4}(-\d{0,2}(-\d{0,2})?)?$/;
                    if (!validDateRegex.test(text)) {
                        text = text.slice(0, -1); // Remove invalid character
                    }
                }

                // Optional: Provide feedback for valid/invalid dates
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
                btnHeight: homePage.buttonHeight
                // btnIconSrc: "qrc:/Asserts/icons/cart.png"
                btnText: "Save"
                onBtnClicked: {
                    console.log("Clicked")
                }
            }

        }
    }

}
