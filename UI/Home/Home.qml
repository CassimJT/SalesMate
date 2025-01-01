import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

Item {
    ToolBar {
        width: parent.width
        height: 60
        anchors {
            top:parent.top
        }

        RowLayout {
            anchors.fill:parent
            ToolButton {
                Image {
                    id: name
                    width: 28
                    height: width
                    source: "qrc:/Asserts/icons/menu-48.png"
                    fillMode: Image.PreserveAspectFit
                    MouseArea {
                        anchors.fill:parent
                        onClicked: {
                            drawer.open()
                        }
                    }
                    anchors.centerIn: parent
                }

            }
            Label {
                text:qsTr("")
            }
            ToolButton {
                Image {
                    id: cart
                    width: 28
                    height: width
                    source: "qrc:/Asserts/icons/cart.png"
                    fillMode: Image.PreserveAspectFit
                    MouseArea {
                        anchors.fill:parent
                    }
                    anchors.centerIn: parent
                    Rectangle {
                        id:contentRec
                        color:"red"
                        width: 14
                        height: width
                        radius:width
                        anchors {
                            right:parent.right
                        }
                        Text {
                            id:contentTxt
                            text:"0"
                            font.pointSize: 9
                            anchors.centerIn:parent
                        }
                    }
                }
                Layout.alignment: Qt.AlignRight
            }
        }
    }

}
