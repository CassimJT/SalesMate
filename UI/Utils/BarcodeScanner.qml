import QtQuick 2.15
import QtQuick.Controls
import QtMultimedia

Item {
    id: m_parent
    property color barCodAreaColor: "#B2EBF2"
    property real barcodeHight: 142
    property real barCodeWidth: parent.width * 0.9
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
                //send to backend
            }
        }

        videoOutput: output
    }
    //barcode area background
    Rectangle {
        id: scannerArea
        width: m_parent.barCodeWidth
        height: m_parent.barcodeHight
        radius: 15
        color: m_parent.barCodAreaColor
        BorderImage {
            id: bacground
            source: "qrc:/Asserts/icons/scannerRec.png"
            anchors.fill:parent
        }
        //VideoOutput
        VideoOutput {
            id: output
            anchors.fill: parent
            ScannerTools {
                id:scannerTools
                anchors {
                    bottom: parent.bottom
                    horizontalCenter:parent.horizontalCenter
                    bottomMargin: 6
                }
            }
            Rectangle {
                id:inidcator
                color: "red"
                width: 16
                height: width
                radius: width
                anchors {
                    top: parent.top
                    right: parent.right
                    topMargin: 10
                    rightMargin: 10
                }
            }
        }
    }
}
