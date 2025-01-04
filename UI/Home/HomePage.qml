import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import "../Utils"
Page {
    id: homePage
    objectName: "Home"

    Flickable {
        id: flickable
        width: parent.width
        height: parent.height
        property real screanHeight: flickable.height
        contentHeight: mainLayout.height
        clip: true
        Component.onCompleted: {
            console.log(screanHeight)
        }

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
        }

        ColumnLayout {
            id: mainLayout
            spacing: 20
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
            }

            RowLayout {
                spacing: 5
                TextField {
                    id: quantityField
                    placeholderText: "Quantity"
                    Layout.fillWidth: true
                }
                RoundButton {
                    id: plus
                    text: qsTr("+")
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40
                }
            }

            BarcodeScanner {
                id: barcodeScanner
                Layout.fillWidth: true
                barCodeWidth: parent.width
            }

            Label {
                id: total
                text: qsTr("MK 00.00")
                font.pointSize: 22
                Layout.alignment: Qt.AlignHCenter
                color: "gray"
            }

            RowLayout {
                spacing: 5
                Layout.fillWidth: true
                TextField {
                    id:paymentField
                    placeholderText: "Payemnet"
                    Layout.fillWidth: true
                }
                TextField {
                    id:changeFiled
                    placeholderText: "Change"
                    Layout.fillWidth: true
                }

            }
            CustomButton {
                id: addToCart
                Layout.fillWidth: true
                btnColor: "#4CAF50"
                btnRadius: 5
            }
            CustomButton {
                id: makeSales
                Layout.fillWidth: true
                btnColor: "#4CAF50"
                btnRadius: 5
            }
        }
    }
}
