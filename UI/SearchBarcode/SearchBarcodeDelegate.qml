import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

ItemDelegate {
    id: searchBarcodeDelegate
    width: parent.width
    height: 50

    // Declare the property
    property var popupReference
    background: Rectangle {
        id: background
        anchors.fill: parent
        color: index % 2 === 0
               ? (parent.down ? "#d3d3d3" : "#f5f5f5")
               : (parent.down ? "#d3d3d3" : "#ffffff")
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
            Layout.preferredWidth: parent.width / 2
            elide: Label.ElideRight
        }

        // Item quantity
        Label {
            id: sku
            text: model.sku
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: parent.width / 2

        }
    }
    onClicked: {
        console.log("Sku: "+ model.sku)
        barcodeEngine.setBarcode(model.sku)
        if (popupReference) {
            console.log("Popup reference found. Closing...");
            popupReference.close();
        } else {
            console.warn("Popup reference is null!");
        }
    }
}
