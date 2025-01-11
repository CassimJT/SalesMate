import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

Row {
    id: row
    spacing: 15

    // Properties to track the clicked state
    property bool scannerClicked: false
    property bool torchClicked: false
    property bool searchClicked: false
    property bool generateClicked: false

    // Icon source properties
    property string scannerIconSource: ""
    property string torchIconSource: ""
    property string searchIconSource: ""
    property string generateIconSource: ""

    // Signals for activation
    signal scannerActivated(bool isActive)
    signal torchActivated(bool isActive)
    signal searchActivated(bool isActive)
    signal generateActivated(bool isActive)
    property color dynamicColor: "red" // Default color

    // Scanner
    Image {
        id: scanner
        width: 24
        height: width
        source: row.scannerIconSource
        visible: row.scannerIconSource != ""
        opacity: row.scannerClicked ? 1 : 0.5
        fillMode: Image.PreserveAspectFit

        MouseArea {
            anchors.fill: parent
            onClicked: {
                row.scannerClicked = !row.scannerClicked
                row.scannerActivated(row.scannerClicked) // Emit signal with current state
            }
        }
    }

    // Torch
    Image {
        id: torch
        width: 24
        height: width
        source: row.torchIconSource
        visible: row.torchIconSource != ""
        opacity: row.torchClicked ? 1 : 0.5
        fillMode: Image.PreserveAspectFit

        MouseArea {
            anchors.fill: parent
            onClicked: {
                row.torchClicked = !row.torchClicked
                row.torchActivated(row.torchClicked) // Emit signal with current state
            }
        }
    }

    // Search
    Image {
        id: search
        width: 24
        height: width
        source: row.searchIconSource
        visible: row.searchIconSource != ""
        opacity: row.searchClicked ? 1 : 0.5
        fillMode: Image.PreserveAspectFit

        MouseArea {
            anchors.fill: parent
            onClicked: {
                row.searchClicked = !row.searchClicked
                row.searchActivated(row.searchClicked) // Emit signal with current state
            }
        }

    }

    // Generate
    Image {
        id: generate
        width: 24
        height: width
        source: row.generateIconSource
        visible: row.generateIconSource != ""
        opacity: row.generateClicked ? 1 : 0.5
        fillMode: Image.PreserveAspectFit

        MouseArea {
            anchors.fill: parent
            onClicked: {
                row.generateClicked = !row.generateClicked
                row.generateActivated(row.generateClicked) // Emit signal with current state
            }
        }
    }
}
