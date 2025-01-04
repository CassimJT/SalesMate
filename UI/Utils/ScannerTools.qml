import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

Row {
    id: row
    spacing: 15

    property bool scannerClicked: false
    property bool torchClicked: false
    property bool searchClicked: false

    signal scannerActivated()
    signal torchActivated()
    signal searchActivated()

    // Scanner
    Image {
        id: scanner
        width: 24
        height: width
        source: "qrc:/Asserts/icons/barcode-scan.png"
        opacity: row.scannerClicked ? 1 : 0.5
        fillMode: Image.PreserveAspectFit

        MouseArea {
            anchors.fill: parent
            onClicked: {
                row.scannerClicked = !row.scannerClicked
                row.scannerActivated()
            }
        }
    }

    // Torch
    Image {
        id: torch
        width: 24
        height: width
        source: "qrc:/Asserts/icons/touch.png"
        opacity: row.torchClicked ? 1 : 0.5
        fillMode: Image.PreserveAspectFit

        MouseArea {
            anchors.fill: parent
            onClicked: {
                row.torchClicked = !row.torchClicked
                row.torchActivated()
            }
        }
    }

    // Search
    Image {
        id: search
        width: 24
        height: width
        source: "qrc:/Asserts/icons/search.png"
        opacity: row.searchClicked ? 1 : 0.5
        fillMode: Image.PreserveAspectFit

        MouseArea {
            anchors.fill: parent
            onClicked: {
                row.searchClicked = !row.searchClicked
                row.searchActivated()
            }
        }
    }
}
