import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import "../Utils"

Page {
    id: salesPage
    objectName: "Sales"
    property alias editProduct: editProduct

    SearchBar {
        id: searchBar

        onTextChangedSignal: {
            productFilterModel.setFilterName(searchBar.text); // Ensure this is correct
        }
        onTextEditFinished: {
            productFilterModel.setFilterName(searchBar.text); // Ensure this is correct
        }

    }
    Label {
        id:directionText
        text: qsTr("Click a row to view details / edit a product")
        color: "red"
        anchors {
            top: searchBar.bottom
            topMargin:10
            left:parent.left
            leftMargin: 15
        }
    }
    Rectangle {
        id: heading
        width: parent.width
        height: 50
        anchors {
            top: directionText.bottom
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

            //name
            Label {
                id: name
                text: qsTr("Name")
                Layout.alignment: Qt.AlignLeft
                font.bold: true
                Layout.preferredWidth: 100
            }
            //quantity
            Label {
                id: quantity
                text: qsTr("Quantity")
                Layout.alignment: Qt.AlignCenter
                font.bold: true
                Layout.preferredWidth: 100
            }
            //price
            Label {
                id: price
                text: qsTr("Unit Price")
                Layout.alignment: Qt.AlignRight
                font.bold: true
                Layout.preferredWidth: 70
            }
        }
    }

    // ListView
    ListView {
        id: listview
        clip: true
        model:productFilterModel
        delegate: StockDelegate{
            editProduct: salesPage.editProduct
        }
        anchors {
            top: heading.bottom
            right: parent.right
            left: parent.left
            bottom: parent.bottom
            topMargin: 10
        }
    }
    Text {
        id: noDataText
        text: qsTr("No Stock Available")
        anchors.centerIn: parent
        font.pixelSize: 16
        color: "gray"
        visible: false // Show text only when model is empty
    }

    ProductEditPopup {
        id: editProduct

    }

}
