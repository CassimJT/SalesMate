import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import "../Utils"
import "../Stock"
import "../SearchBarcode"

Popup {
    id:searchBarcode
    //
    property alias heading: heading

    width: parent.width * 0.8
    height: parent.height * 0.85
    modal: true
    closePolicy: Popup.NoAutoClose
    anchors.centerIn: parent
    padding: 0
    PopupHeading{
        id: heading
        title: "Search for item"
        onClicked: {
            searchBarcode.close()
        }
    }
    SearchBar {
        id: searchBar

        onTextChangedSignal: {
            productFilterModel.setFilterName(searchBar.text); // Ensure this is correct
        }
        anchors {
            top: heading.bottom
            topMargin: 10
        }
    }
    // ListView
    ListView {
        id: listview
        clip: true
        model:productFilterModel
        delegate: SearchBarcodeDelegate {
            popupReference: searchBarcode
        }
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
        visible: false // Show text only when model is empty
    }
    onClosed: {
        searchBar.text = ""
    }

}
