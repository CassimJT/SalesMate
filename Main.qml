import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Window
import QtQuick.Layouts
import "./UI/Drawer"
import "./UI/Welcome"

ApplicationWindow {
    id: root
    width: 300
    height: 480
    visible: true
    title: qsTr("SalesMate")
    Material.primary: Material.Green
    property alias mainStakView: mainStakView
    property alias drawer: drawer

    WelcomePage {
        id: welcomePage // Declare an instance
        visible: false // Prevent it from being displayed here
    }

    header: ToolBar {
        id: toolbar
        visible: mainStakView.currentItem !== welcomePage // Compare with the instance
        RowLayout {
            anchors.fill: parent
            //menu button
            ToolButton {
                Image {
                    id: name
                    width: 28
                    height: width
                    source: mainStakView.depth > 1 ? "qrc:/Asserts/icons/styled-back.png" :"qrc:/Asserts/icons/menu-48.png"
                    fillMode: Image.PreserveAspectFit
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if(mainStakView.depth > 1) {
                                mainStakView.pop()
                            } else {
                                drawer.open()
                            }
                        }
                    }
                    anchors.centerIn: parent
                }
            }
            //pageTitle
            Label {
                text: qsTr("")
            }
            //current sales
            ToolButton {
                z:1
                Image {
                    id: cart
                    width: 28
                    height: width
                    source: "qrc:/Asserts/icons/cart.png"
                    fillMode: Image.PreserveAspectFit
                    MouseArea {
                        anchors.fill: parent
                    }
                    anchors.centerIn: parent
                    Rectangle {
                        id: contentRec
                        color: "red"
                        width: 14
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
                        }
                        //MouseArea
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if(mainStakView.depth > 1) {
                                    mainStakView.pop()
                                }else {
                                     mainStakView.push("./UI/Stock/ShowSalesPage.qml")
                                }
                            }
                        }
                    }
                }
                Layout.alignment: Qt.AlignRight
                //click event
                onClicked: {
                    if(mainStakView.depth > 1) {
                        mainStakView.pop()
                    }else {
                         mainStakView.push("./UI/Stock/ShowSalesPage.qml")
                    }
                }
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
                mainStakView.push("./UI/Updates/ChechUpdatePage.qml")
                drawer.close()
            }
        }
    }
    //the main stark
    StackView {
        id: mainStakView
        property bool userIsSigned: true
        property bool isVerified: (userIsSigned && mainStakView.depth == 0)
        anchors.fill: parent
        initialItem: userIsSigned ? "./UI/Home/HomePage.qml" : welcomePage
    }
}
