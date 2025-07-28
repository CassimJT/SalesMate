import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Window
import QtQuick.Layouts
import Cisociety
import "./UI/Drawer"
import "./UI/Welcome"
import "./UI/Utils/Utils.js" as Utils

ApplicationWindow {
    id: root
    width: 300
    height: 580
    visible: true
    title: qsTr("SalesMate")
    Material.primary: Material.Green
    property alias drawer: drawer
    property alias barcodeEngine: barcodeEngine
    property var mainStakView
    BarcodeEngine {
        id: barcodeEngine
    }

    WelcomePage {
        id: welcomePage
        visible: false
    }

    header: ToolBar {
        id: toolbar
        visible: root.mainStakView.currentItem !== welcomePage // Compare with the instance
        height: 55
        RowLayout {
            anchors.fill: parent
            //menu button
            ToolButton {
                Image {
                    id: name
                    width: 36
                    height: width
                    source: Utils.getIconSource()
                    fillMode: Image.PreserveAspectFit
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if(root.mainStakView.depth > 1) {
                                root.mainStakView.pop()
                            } else if(mainStakViewLoader.item && mainStakViewLoader.item.objectName === "Stocks"){
                                mainStakViewLoader.source = "./UI/Home/MainSatckView.qml"
                            } else if(mainStakViewLoader.item && mainStakViewLoader.item.objectName === "Notification"){
                                mainStakViewLoader.source = "./UI/Stock/AddItemPage.qml"
                            }else {
                                drawer.open()
                            }
                        }
                    }
                    anchors.centerIn: parent
                }
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: 5
            }
            //pageTitle
            Label {
                text: {
                    if (root.mainStakView.currentItem && root.mainStakView.currentItem.objectName) {
                        return root.mainStakView.currentItem.objectName;
                    } else if (mainStakViewLoader.item && mainStakViewLoader.item.objectName) {
                        return mainStakViewLoader.item.objectName;
                    } else {
                        return ""; //show nothing
                    }
                }
                font.pointSize: 16
            }
            //current sales
            ToolButton {
                Image {
                    id: notification
                    width: 28
                    height: width
                    source: "qrc:/Asserts/icons/notification.png"
                    fillMode: Image.PreserveAspectFit
                    MouseArea {
                        anchors.fill: parent
                    }
                    anchors.centerIn: parent
                    Rectangle {
                        id: contentRec
                        color: "red"
                        width: 16
                        height: width
                        radius: width
                        anchors {
                            right: parent.right
                        }
                        Text {
                            id: contentTxt
                            text: "0"
                            font.pointSize: 9
                            anchors.centerIn: parent
                            color: "#ffffff"
                        }
                    }
                    //MouseArea
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if(mainStakViewLoader.item && mainStakViewLoader.item.objectName === "Stocks") {
                                mainStakViewLoader.source = "./UI/Notification/NotificationPage.qml"

                            }else {

                                if(root.mainStakView.depth > 1 && root.mainStakView.currentItem.objectName === "Notification" ) {
                                    root.mainStakView.pop()
                                } else {
                                    root.mainStakView.push("./UI/Notification/NotificationPage.qml")
                                }
                            }

                        }
                    }
                }
                Layout.alignment: Qt.AlignRight
                Layout.rightMargin: 5
            }
        }
    }
    Drawer {
        id:drawer
        width: parent.width * 0.75
        height: parent.height
        dragMargin: 0
        clip: true
        Profile {
            id:profile
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
            //click event
            onClicked: {
                root.mainStakView.push("./UI/Updates/ChechUpdatePage.qml")
                drawer.close()
            }
        }
    }
    //the main stark
    Loader {
        id: mainStakViewLoader
        property bool userIsSigned: true
        property bool isVerified: (userIsSigned && root.mainStakView && root.mainStakView.depth === 0)
        anchors.fill: parent
        source: userIsSigned ? "./UI/Home/MainSatckView.qml" : welcomePage
        onLoaded: {
            // Ensure the root.mainStakView references the loaded component
            root.mainStakView = mainStakViewLoader.item
        }
    }

}
