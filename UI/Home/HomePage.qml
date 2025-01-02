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
        width:parent.width
        contentHeight: mainLayout.height
        ColumnLayout {
            id: mainLayout
            spacing:10
            width: parent.width * 0.9
            anchors {
                horizontalCenter:parent.horizontalCenter
                top:parent.top
                topMargin: 10
            }
            TextField {
                id:amountTextField
                placeholderText: "Amount"
                Layout.preferredWidth: parent.width
            }

            RowLayout {
                TextField {
                    id:quantityTxt
                    placeholderText:"Quantity"
                    Layout.preferredWidth: amountTextField.width - plus.width

                }
                RoundButton {
                    id:plus
                    text: qsTr("+")
                }
            }
           BarcodeScanner {
                id:bacodeScanner
                barCodeWidth: parent.width
           }


        }

    }


}
