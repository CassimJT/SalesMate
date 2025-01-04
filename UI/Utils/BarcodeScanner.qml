import QtQuick 2.15
import QtQuick.Controls
import QtMultimedia
Item {
    id: m_parent
    width: parent.width
    height: implicitHeight
    property color barCodAreaColor: "#B2EBF2"
    property real barcodeHight: 142
    property real barCodeWidth: parent.width * 0.9
    property string scanneriIconSource: ""
    property string torshIconSource: ""
    property string searchIconSource: ""
    property string generateIcconSource: ""

    implicitHeight: scannerArea.height

    CaptureSession {
        id: session
        camera: Camera {
            id: camera
            focusMode: Camera.FocusModeAutoNear
        }
        imageCapture: ImageCapture {
            id: imagecapture
            onImageCaptured: function (imageid, preview) {
                console.log("Image captured...");
                // Send to backend
            }
        }
        videoOutput: output
    }

    // Barcode area background
    Rectangle {
        id: scannerArea
        width: m_parent.barCodeWidth
        height: m_parent.barcodeHight
        radius: 10
        color: m_parent.barCodAreaColor

        BorderImage {
            id: background
            source: "qrc:/Asserts/icons/scannerRec.png"
            anchors {
                fill: parent
                margins: 8
            }
        }

        // VideoOutput
        VideoOutput {
            id: output
            anchors.fill: parent

            ScannerTools {
                id: scannerTools
                scanneriIconSource: m_parent.scanneriIconSource
                torshIconSource: m_parent.torshIconSource
                searchIconSource: m_parent.searchIconSource
                generateIcconSource: m_parent.generateIcconSource
                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    bottomMargin: 6
                }
                onScannerActivated: {
                    console.log("Scanner button clicked!");
                }
                onTorchActivated: {
                    console.log("Torch button clicked!");
                }
                onSearchActivated: {
                    console.log("Search button clicked!");
                }
                onGenerateActivated: {
                     console.log("Gererate button clicked!");
                }
            }

            Rectangle {
                id: indicator
                color: "red"
                width: 12
                height: width
                radius: width
                anchors {
                    top: parent.top
                    right: parent.right
                    topMargin: 20
                    rightMargin: 20
                }
            }
        }
    }
}
