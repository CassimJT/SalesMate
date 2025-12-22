import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: searchBar
    property real searchBarWidth: parent.width * 0.93
    property real searchBarHeight: 50
    property real searchBarRadius: 10
    property string searchBarBgColor: "lightgrey"
    property string searchBarIconSource:  "qrc:/Asserts/icons/icons8-search-100.png"
    property real searchBarIconHeight: 24
    property real searchBarIconWidth: 24
    property real searchBarOpacity: 0.5

    width: searchBar.searchBarWidth
    height: searchBar.searchBarHeight
    radius: searchBar.searchBarRadius
    color: searchBar.searchBarBgColor
    opacity: searchBar.searchBarOpacity

    anchors {
        top: parent.top
        topMargin: 10
        horizontalCenter: parent.horizontalCenter
    }

    property alias placeholderText: searchField.placeholderText
    property alias text: searchField.text

    signal textChangedSignal(string text)
    signal textEditFinished(string text)

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 10

        Image {
            id: img
            source: searchBar.searchBarIconSource
            Layout.preferredWidth: searchBar.searchBarIconWidth
            Layout.preferredHeight: searchBar.searchBarIconHeight
            fillMode: Image.PreserveAspectFit
        }

        TextField {
            id: searchField
            Layout.fillWidth: true
            placeholderText: qsTr("Search...")
            font.pixelSize: 16
            inputMethodHints: Qt.ImhSensitiveData // Disable input method hints
            background: Rectangle {
                color: "transparent"
            }
            padding: 4

            onTextChanged: {
                // Filter as you type
            }

            onEditingFinished: {
                // Filter when editing finishes
            }
        }

    }
}
