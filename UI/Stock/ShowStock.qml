import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: salesPage
    objectName: "Sales"

    // Search Bar
    SearchBar {
        id: searchBar
        anchors.top: parent.top
        anchors.topMargin: 10
    }


    // ListView
    ListView {
        id: listview
        clip: true
        model: StockModel{}
        delegate: StockDelegate{}
        anchors {
            top: searchBar.bottom
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
        visible: listview.model.count === 0 // Show text only when model is empty
    }

}
