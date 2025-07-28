import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15


ItemDelegate {
    id: delegate
    width: parent.width
    height: 50 // Adjust height based on your requirement
    property var editProduct
    background: Rectangle {
        id: background
        anchors.fill: parent
        color: index % 2 === 0
               ? (parent.down ? "#d3d3d3" : "#f5f5f5")
               : (parent.down ? "#d3d3d3" : "#ffffff")
    }

    RowLayout {
        width: parent.width
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
            topMargin: 10
            leftMargin: 16
            rightMargin: 15
        }
        // Item name
        Label {
            id: name
            text: model.name
            Layout.alignment: Qt.AlignLeft
            Layout.preferredWidth: 120
            elide: Label.ElideRight
        }
        // Item quantity
        Label {
            id: quantity
            text: model.quantity
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: 100
        }

        // Item price
        Label {
            id: price
            text:model.price.toLocaleCurrencyString(Qt.locale("en-MW"))
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: 10
            Layout.preferredWidth: 80

        }
    }

    onClicked: {

        delegate.editProduct.title = model.name;
        delegate.editProduct.sku = model.sku;
        delegate.editProduct.name = model.name;
        delegate.editProduct.price = model.price;
        delegate.editProduct.cp = model.cp
        delegate.editProduct.quantity = model.quantity;
        delegate.editProduct.open()
    }
    Component.onCompleted: {
        console.log("quantitysold: "+ model.quantitysold)
    }
}
