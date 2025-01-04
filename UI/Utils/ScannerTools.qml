import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

Row {
    id: row
    spacing: 15

    property bool scannerClicked: false
    property bool torchClicked: false
    property bool searchClicked: false
     property bool gerarateClicked: false
    property string scanneriIconSource: ""
    property string torshIconSource: ""
    property string searchIconSource: ""
    property string generateIcconSource: ""

    signal scannerActivated()
    signal torchActivated()
    signal searchActivated()
    signal generateActivated()

    // Scanner
    Image {
        id: scanner
        width: 24
        height: width
        source: row.scanneriIconSource
        visible: row.scanneriIconSource != ""
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
        visible: row.torshIconSource != ""
        source:row.torshIconSource
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
        source:row.searchIconSource
        visible: row.searchIconSource != ""
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
    // generate
    Image {
        id: generate
        width: 24
        height: width
        source:row.generateIcconSource
        visible: row.generateIcconSource != ""
        opacity: row.gerarateClicked ? 1 : 0.5
        fillMode: Image.PreserveAspectFit

        MouseArea {
            anchors.fill: parent
            onClicked: {
                row.gerarateClicked = !row.gerarateClicked
                row.generateActivated()
            }
        }
    }
}
