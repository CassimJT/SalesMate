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
    property bool showRecycle: false
    property string generateIcconSource: ""
    property bool startSession: false
    property alias imagecapture: imagecapture
    property alias  camera: camera
    property alias output: output
    property alias frameTimer: frameTimer
    property string barcode: ""

    //exposing the Scanner tool propeties
    // Signals to expose scanner tool events
    signal searchBtnClciked()

    implicitHeight: scannerArea.height
    CaptureSession {
        id: session
        camera: Camera {
            id: camera
            focusMode: Camera.FocusModeAuto
            // zoomFactor: 2.0

        }
        imageCapture: ImageCapture {
            id: imagecapture
            onImageCaptured: function (imageId, preview) {
                barcodeEngine.processImage(preview)
            }
        }
        videoOutput: output
    }
    // Barcode area background
    Rectangle {
        id: scannerArea
        width: m_parent.barCodeWidth
        height: m_parent.barcodeHight
        radius: 5
        color: m_parent.barCodAreaColor
        Label {
            id:code
            anchors.centerIn:parent
            text: m_parent.barcode
            visible: false
        }
        // VideoOutput
        VideoOutput {
            id: output
            anchors.fill: parent
            fillMode: VideoOutput.PreserveAspectCrop

            BorderImage {
                id: background
                source: "qrc:/Asserts/icons/bar-frame-small.png"
                anchors {
                    fill: parent
                    margins: 8
                }
                MouseArea {
                    anchors.fill:parent
                    onClicked:{
                        //restarting the camera
                        camera.stop()
                        camera.start()
                        frameTimer.restart()
                    }
                }
            }

            ScannerTools {
                id: scannerTools
                scannerIconSource: m_parent.scanneriIconSource
                torchIconSource: m_parent.torshIconSource
                searchIconSource: m_parent.searchIconSource
                generateIconSource: m_parent.generateIcconSource


                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    bottomMargin: 6
                }
                onScannerActivated: {
                    Android.requestCameraPeremision()
                    if (scannerTools.scannerClicked) {
                        camera.start();
                        frameTimer.start()
                    } else {
                        camera.stop();
                        frameTimer.stop()
                    }
                }
                onTorchActivated: {
                    console.log("Torch button clicked! Active: " + scannerTools.torchClicked);
                    camera.torchMode = scannerTools.torchClicked ? Camera.FlashOn : Camera.FlashOff;
                }
                onSearchClicked: {
                    m_parent.searchBtnClciked();
                }

            }
            Rectangle {
                id: indicator
                color: camera.active ? "green" : "red"
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
            /*Component.onCompleted: {
                 barcodeEngine.setVideoSink(videoSink)
            }*/
        }
        //receycling buttun
        Image {
            id: recycle
            width: 36
            height: width
            source: "qrc:/Asserts/icons/recycle-100.png"
            fillMode: Image.PreserveAspectFit
            visible: m_parent.showRecycle
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }
            MouseArea {
                anchors.fill: parent
                onClicked : {
                    reset()
                }
            }
        }
    }
    MediaPlayer {
        id:barcodeSound
        source: "qrc:/Asserts/sound/store-scanner-beep.wav"
        audioOutput: AudioOutput{}
    }
    //signal
    Connections {
        target: barcodeEngine
        onBarcodeChanged: function () {
            frameTimer.stop();
            camera.stop()
            barcodeSound.play()
            output.visible = false;
            code.visible = true;
            m_parent.showRecycle = true
            m_parent.barcode = barcodeEngine.barcode;
            scannerTools.scannerClicked = "false"
        }
    }
    Timer {
        id:frameTimer
        interval: 3000
        running:true
        repeat: true
        onTriggered: {
            imagecapture.capture()
        }
    }

    function reset() {
        camera.stop()
        camera.start()
        output.visible = true
        frameTimer.restart()
        m_parent.showRecycle = false
        output.visible = true
    }
}
