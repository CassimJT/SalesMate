import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import SalesModel
<<<<<<< HEAD
=======
import "../Utils"
>>>>>>> origin/main

Page {
    id: salesPage
    objectName: "Sales"
<<<<<<< HEAD

    // Search Bar
    SearchBar {
        id: searchBar
        anchors.top: parent.top
        anchors.topMargin: 10
    }
    
=======
>>>>>>> origin/main
    // ListView

    ListView {
        id: listview
        clip: true
        model:SalesModel
        delegate: CurrentSalesDelegate{}
        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
            bottom: parent.bottom
           // topMargin: 5
        }
    }
    Text {
        id: noDataText
        text: qsTr("No current sale")
        anchors.centerIn: parent
        font.pixelSize: 16
        color: "gray"
        visible: listview.model.count === 0 // Show text only when model is empty
    }

}
