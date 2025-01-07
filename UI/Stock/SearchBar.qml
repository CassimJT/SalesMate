import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: searchBar
    width: parent.width * 0.93
    height: 50 // Adjust height if needed
    radius: 10
    color: "LightGrey"
    //border.color: "none"

    anchors {
        top: parent.top
        topMargin: 10
        horizontalCenter: parent.horizontalCenter
    }

    property alias placeholderText: searchField.placeholderText
    property alias text: searchField.text

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10 // Add some margin for spacing
        spacing: 10 // Add spacing between the icon and the text field
        // Search Icon
        Image {
            id: img
            source: "qrc:/Asserts/icons/icons8-search-100.png" // Replace with your search icon
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            fillMode: Image.PreserveAspectFit
        }
        // Search Text Field
        TextField {
            id: searchField
            Layout.fillWidth: true
            placeholderText: qsTr("Search...")
            font.pixelSize: 16
            background: Rectangle {
                color: "transparent"
            }
            padding: 4 // Add padding for better appearance
        }
    }
}
