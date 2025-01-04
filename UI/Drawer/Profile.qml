import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import "ImageProcessor.js" as ProcessImage

Rectangle {
    id: profile
    width: parent.width
    height: 180
    clip:true
    property string imageSource: ""
    property string defaultImageSource: "qrc:/Asserts/icons/profile.png"

    ColumnLayout {
        width:profile.width
        spacing: 8
        anchors {
            left: parent.left
            right: parent.right
            leftMargin: 10
            rightMargin: 10
            top:parent.top

        }
        // The Text element
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing:1
            Image {
                id: sales
                Layout.preferredWidth: 36
                Layout.preferredHeight: 36
                source: "qrc:/Asserts/icons/HDPI.png"
                fillMode: Image.PreserveAspectFit
            }
            Label {
                id:apptitle
                text: qsTr("SalesMate")
                font.pointSize: 16
            }
        }

        MenuSeparator{
            Layout.fillWidth: true
        }
        RowLayout {

            Rectangle {
                id: avataRect
                Layout.preferredWidth : 80
                Layout.preferredHeight: Layout.preferredWidth
                radius: width / 2
                color: "transparent" //for now to be descided later
                clip: true

                Canvas {
                    id: avataCanvas
                    anchors.fill: parent

                    onPaint: {
                        const ctx = getContext("2d");
                        ctx.clearRect(0, 0, width, height);

                        // Drawing a circular mask
                        ctx.beginPath();
                        ctx.arc(width / 2, height / 2, width / 2, 0, 2 * Math.PI);
                        ctx.clip();

                        // Drawing the image onto the canvas
                        ctx.drawImage(imageObj, 0, 0, width, height);
                    }

                    Component.onCompleted: {
                        requestPaint(); // Trigger the canvas painting
                    }
                }

                // Offscreen QML Image to load the source
                Image {
                    id: imageObj
                    source: profile.imageSource || profile.defaultImageSource
                    visible: false // Hiding it as its only needed  for Canvas
                    onStatusChanged: {
                        if (status === Image.Ready) {
                            avataCanvas.requestPaint(); // Repaint the canvas when the image is ready
                        }
                    }
                }
                //edit image
                Image {
                    id: edit
                    width: 24
                    height:width
                    source: "qrc:/Asserts/icons/Edit.png"
                    fillMode: Image.PreserveAspectFit
                    anchors {
                        bottom: parent.bottom
                        right:parent.right
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            //code......
                            mainStakView.push("../Profile/ProfileEditPage.qml")
                            drawer.close()
                        }
                    }
                }

            }
            Column {
                Label {
                    id: username
                    text: qsTr("Sara Phiri")
                    font.pointSize: 24
                    //font.bold: true
                }
                Label {
                    id: position
                    text: qsTr("Tela 1")
                    font.pointSize: 14
                    color: "grey"
                }
            }
        }
        MenuSeparator{
            Layout.fillWidth: true
        }
    }
}
