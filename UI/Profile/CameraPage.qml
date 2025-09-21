import QtQuick
import QtQuick.Controls
import QtMultimedia
import QtQuick.Layouts
import QtQuick.Controls.Material
Page {
    id: cameraPage
    objectName: "Camera"
    width: parent.width
    height: parent.height
    anchors.fill: parent
    signal imageCaptured()
    property real btnSize: 70
    property bool isFrontCamera: false


    MediaDevices {
        id: mediaDevices
    }

    CaptureSession {
        id: captureSession
        camera: Camera {
            id: camera
            focusMode: Camera.FocusModeAuto
            onErrorChanged: {
                if (error !== Camera.NoError) {
                    console.log("Camera error:", errorString)
                }
            }
        }
        videoOutput: videoOutput
    }

    Rectangle {
        id: videoOutputRec
        color: "black"
        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
            bottom: bottomBar.top
        }
        VideoOutput {
            id: videoOutput
            anchors.fill: parent
            fillMode: VideoOutput.PreserveAspectCrop
        }
    }

    Rectangle {
        id: bottomBar
        width: parent.width
        height: parent.height * 0.30
        color: "#333"

        ColumnLayout {
            Label {
                text: qsTr("Photo")
                color: "white"
                font.bold: true
                font.pointSize: 16
            }
            Rectangle {
                width: 7
                height: width
                radius: 7
                color: "green"
                Layout.alignment: Qt.AlignHCenter
            }
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 10
            }
        }

        RowLayout {
            anchors.centerIn: parent
            spacing: 20
            Rectangle {
                id: back
                width: cameraPage.btnSize * 0.7
                height: width
                radius: width / 2
                border.color: "white"
                border.width: 2
                color: Qt.rgba(0, 0, 0, 0)

                Image {
                    id: backArrow
                    width: parent.width * 0.65
                    height: width
                    source: "qrc:/Asserts/icons/back-100.png"
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            profileLoader.source = "ProfileEditPage.qml"

                        }
                    }
                }
            }
            Rectangle {
                id: captureBtnFlame
                width: cameraPage.btnSize
                height: width
                radius: width / 2
                border.color: "white"
                border.width: 2
                color: Qt.rgba(0, 0, 0, 0)
                RoundButton {
                    id: capture
                    width: parent.width * 0.8
                    height: width
                    anchors.centerIn: parent
                    icon.name: "camera" // Material icon for capture
                    icon.color: "white"
                    onClicked: {
                        console.log("Capture button clicked")
                        // Add image capture logic here if needed
                    }
                }
            }
            Rectangle {
                id: swichCamera
                width: cameraPage.btnSize * 0.7
                height: width
                radius: width / 2
                border.color: "white"
                border.width: 2
                color: Qt.rgba(0, 0, 0, 0)

                Image {
                    id: switchCamera
                    width: parent.width * 0.65
                    height: width
                    source: "qrc:/Asserts/icons/switch-camera-100.png"
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            var cameras = mediaDevices.videoInputs
                            backFrontCameraClicked()
                        }
                    }
                }
            }
        }
        anchors {
            bottom: parent.bottom
        }
    }

    Component.onCompleted: {
        camera.start()
    }
    function backFrontCameraClicked() {
        var listOfCameras = mediaDevices.videoInputs
        if (camera.cameraDevice.position === CameraDevice.FrontFace) {
            for (var i = 0; i < listOfCameras.length; i++) {
                if (listOfCameras[i].position === CameraDevice.BackFace) {
                    camera.cameraDevice = listOfCameras[i]
                    return
                }
            }
        }
        else {
            for (var j = 0; j < listOfCameras.length; j++) {
                if (listOfCameras[j].position === CameraDevice.FrontFace) {
                    camera.cameraDevice = listOfCameras[j]
                    return
                }
            }
        }
    }


}
