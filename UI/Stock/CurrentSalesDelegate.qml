import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import SalesModel

ItemDelegate {
    id: delegate
    width: parent.width
    height: 50
    background: Rectangle {
        id: background
        anchors.fill: parent
        color: index % 2 === 0
               ? ("#f5f5f5")
               : ("#ffffff")
    }

    RowLayout {
        anchors {
            left: parent.left
            right: parent.right
            leftMargin: 16
            rightMargin: 15
            horizontalCenter: parent.horizontalCenter
            verticalCenter : parent.verticalCenter
        }

        // Item name
        Label {
            id: name
            text: qsTr(model.name)
            Layout.alignment: Qt.AlignLeft
            Layout.preferredWidth: 100
            elide: Label.ElideRight
        }

        // Item quantity
        Label {
            id: quantity
            text: model.quantity
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: 50
        }

        // Item price
        Label {
            id: price
            text: Number(model.price).toLocaleCurrencyString(Qt.locale("en-MW"), "MWK")
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: 80
        }
        // Delete item icon
        Image {
            id: deleteItem
            source:  model.quantity > 1 ? "qrc:/Asserts/icons/minus.png": "qrc:/Asserts/icons/delete.png"
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            opacity: clicked ? 0.8 : 1
            fillMode: Image.PreserveAspectFit
            Layout.alignment: Qt.AlignRight
            MouseArea{
                anchors.fill: parent
                onClicked:{
                    if(model.quantity > 1) {
                        SalesModel.decrementQuantity(index)
                    }else {
                        SalesModel.deleteSale(index);
                    }
                }
            }
        }
    }
}
