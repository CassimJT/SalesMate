import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Window
import QtQuick.Layouts
import "./UI/Drawer"
import "./UI/Welcome"

ApplicationWindow {
    id:mainWindow
    width: 300
    height: 480
    visible: true
    title: qsTr("SalesMate")
    Material.primary: Material.Green
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
        }
    }
    //the main stark
    StackView {
        id: mainStakView
        property bool userIsSigned: true
        anchors.fill: parent
        initialItem:(userIsSigned && mainStakView.depth == 0)? "./UI/Home/Home.qml":"./UI/Welcome/Welcome.qml"
    }

    onHeightChanged: {
        console.log("Window height changed. Refreshing UI.");

    }
}
