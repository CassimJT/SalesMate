// Receipt.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import SalesModel

Popup {
    id: receipt
    width: 280  // Standard receipt width (72mm in pixels)
    modal: true
    anchors.centerIn: parent
    closePolicy: Popup.NoAutoClose
    signal clicked()

    property string storeName: "Salesmate"
    property string storePhone: "Tel: +256 883 560 759"
    property string rigion: "Northen Rigion"
    property string storeAddress: "P.O Box 1, Mzuzu"
    property date transactionDate: new Date()
    property string cashier: "Cashier: John"
    property var items: [
        { name: "Milk 1L  ", price: 2.50, qty: 2 },
        { name: "Bread", price: 1.80, qty: 1 }
    ]
    property real taxRate: 0.0
    property string paymentMethod: "CASH"

    Column {
        width: parent.width
        spacing: 8
        ReceiptText {
            text: "*** START OF RECEIPT ***";
            horizontalAlignment: Text.AlignHCenter
            font.bold: true
        }
        // Logo
        Image {
            id: sales
            width: 46
            height: width
            source: "qrc:/Asserts/icons/HDPI.png"
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Header
        ReceiptText { text: storeName; font.bold: true; horizontalAlignment: Text.AlignHCenter }
        ReceiptText { text: storeAddress; horizontalAlignment: Text.AlignHCenter }
        ReceiptText { text: storePhone; horizontalAlignment: Text.AlignHCenter }

        ReceiptText { text: "-----------------------------"; horizontalAlignment: Text.AlignHCenter }

        // Transaction Info
        ReceiptText { text: "Date: " + Qt.formatDateTime(transactionDate, "yyyy-MM-dd hh:mm") }
        ReceiptText { text: cashier }

        // Items Table Header
        RowLayout {
            width: parent.width
            spacing: 20  // Adjust spacing as needed

            ReceiptText {
                text: "<b>ITEM</b>"
                Layout.fillWidth: true  // Ensures equal spacing
            }
            ReceiptText {
                text: "<b>QTY</b>"
                Layout.minimumWidth: 50
                Layout.alignment: Qt.AlignHCenter
            }
            ReceiptText {
                text: "<b>PRICE</b>"
                Layout.minimumWidth: 80
                Layout.alignment: Qt.AlignRight
            }
        }

        // Items Table Body

        Repeater {
            model:  SalesModel.onGoingSale()
            delegate: RowLayout {
                width: parent.width
                spacing: 20  // Same spacing as the header

                ReceiptText {
                    text: modelData.name
                    Layout.fillWidth: true
                }
                ReceiptText {
                    text: String(modelData.quantity)
                    Layout.minimumWidth: 50
                    Layout.alignment: Qt.AlignHCenter
                }
                ReceiptText {
                    text: (modelData.totalprice).toFixed(2)
                    Layout.minimumWidth: 80
                    Layout.alignment: Qt.AlignRight
                }
            }
        }

        // Totals
        ReceiptText { text: "-----------------------------"; horizontalAlignment: Text.AlignHCenter }
        ReceiptText {
            textFormat: Text.RichText  // Enables HTML formatting
            text: {
                const subtotal = SalesModel.totalSale();
                const tax = subtotal * taxRate;
                const total = (subtotal + tax).toLocaleCurrencyString(Qt.locale("en-MW"));

                return [
                            `SUBTOTAL:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ${subtotal.toFixed(2)}`,
                            `TAX (${taxRate * 100}%):&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ${tax.toFixed(2)}`,
                            `<b>TOTAL:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ${total}</b>`
                        ].join("<br>");  // Line breaks for proper display
            }
        }


        // Footer
        ReceiptText { text: "Payment: " + paymentMethod }
        ReceiptText {
            text: "*** END OF RECEIPT ***";
            horizontalAlignment: Text.AlignHCenter
            font.bold: true
        }

        // Buttons
        RowLayout {
            spacing: 10
            anchors {

                right: parent.right
                rightMargin: 10
            }

            RoundButton {
                // text: "Cancel"
                Layout.preferredWidth: 60
                Layout.preferredHeight: 50
                Image {
                    anchors.centerIn: parent
                    width: 24
                    height: width
                    source: "qrc:/Asserts/icons/icons8-cancel-100.png"
                    fillMode: Image.PreserveAspectFit
                }
                onClicked: receipt.close()

            }

            RoundButton {
                // text: "OK"
                Layout.preferredWidth: 60
                Layout.preferredHeight: 50
                Image {
                    anchors.centerIn: parent
                    width: 24
                    height: width
                    source: "qrc:/Asserts/icons/icons8-sale-100.png"
                    fillMode: Image.PreserveAspectFit
                }
                onClicked :{
                    receipt.clicked()
                }

            }
        }
    }
}
