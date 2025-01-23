import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: searchBar
    width: parent.width * 0.93
    height: 50
    radius: 10
    color: "lightgrey"

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
            source: "qrc:/Asserts/icons/icons8-search-100.png"
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
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

            // Use displayText to ensure it works better on Android
           // displayText: searchField.text

            // Optionally, you can use a Validator if needed for specific input filtering
            // validator: RegExpValidator { regExp: /^[a-zA-Z0-9]+$/ }

            onTextChanged: {
                searchBar.textChangedSignal(searchField.text)
                productFilterModel.setFilterName(searchField.text) // Filter as you type
            }

            onEditingFinished: {
                searchBar.textEditFinished(searchField.text)
                productFilterModel.setFilterName(searchField.text) // Filter when editing finishes
            }
        }

    }
}
