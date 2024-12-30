import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Window
import QtQuick.Layouts
import "./UI/Drawer"

ApplicationWindow {
    id:window
    width: 300
    height: 480
    visible: true
    title: qsTr("SalesMate")
    Material.primary: Material.Green
    header: ToolBar {
        height: 60

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

    Drawer {
        id:drawer
        width: parent.width * 0.75
        height: parent.height
        clip: true
            Profile {
                id:profile
                height: parent.height * 0.20
                anchors {
                    left: parent.left
                    right: parent.right
                    top:parent.top
                }
            }
            DrawerMenu {
                id: drawerenu
                anchors {
                    top: profile.bottom
                    left: parent.left
                    right: parent.right
                    bottom: separator.top
                }
            }
            MenuSeparator {
                id: separator
                width: parent.width
                anchors {
                    bottom: update.top
                }
            }
            ItemDelegate {
                id:update
                width: parent.width
                height: implicitHeight
                anchors{
                    bottom: parent.bottom
                }

                RowLayout {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: 10
                    }

                    Image {
                        id: updateImage
                        Layout.preferredWidth: 24
                        Layout.preferredHeight: 24
                        source: "qrc:/Asserts/icons/icons8-installing-updates-50.png"
                        fillMode: Image.PreserveAspectFit

                    }
                  Text{
                      id: updaeText
                      text: qsTr("Check for Update")
                  }
                }
            }

    }

}
