import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import "../Stock"
import SalesModel
Page {
    id: addItemPage
    objectName: "Home"
    SwipeView{
        id: swipeView
        anchors.fill:parent
        currentIndex: 0
        //home
        Home {
        }
        //current Sales
        ShowSalesPage {
        }
    }
    footer: TabBar {
        currentIndex: swipeView.currentIndex
        id: bar
        width: parent.width
        //Home
        TabButton {
            Row {
                spacing: 5
                anchors.centerIn: parent
                Image {
                    id: addstock
                    source: "qrc:/Asserts/icons/POS.png"
                    width: 33
                    height: 33
                    fillMode: Image.PreserveAspectFit
                    Layout.alignment: Qt.AlignVCenter
                    anchors {
                        verticalCenter: parent.verticalCenter
                    }
                }
                Label {
                    id:addStockText
                     text:qsTr("POS")
                    Layout.alignment: Qt.AlignVCenter
                    anchors {
                        verticalCenter: addstock.verticalCenter
                    }
                }
            }
            onClicked: {
                swipeView.currentIndex = 0
                //reload()
            }
        }
        //currentSale
        TabButton {
            text: qsTr("")
            Row {
                anchors.centerIn: parent
                //image
                AnimatedImage {
                    id: giff
                    width: 36
                    height: width
                    source: "qrc:/Asserts/icons/animeted-cart.gif"
                    fillMode:Image.PreserveAspectFit
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
                            text: SalesModel.modelSize() || 0;
                            font.pointSize: 9
                            anchors.centerIn: parent
                            color: "#ffffff"
                        }

                    }
                    anchors {
                        verticalCenter: parent.verticalCenter
                    }

                }
                Label {
                    id:showStockText
                    text:qsTr("Carrent Sales")
                    Layout.alignment: Qt.AlignVCenter
                    anchors {
                        verticalCenter: giff.verticalCenter
                    }
                }
            }
            onClicked: {
                swipeView.currentIndex = 1
            }
        }
    }
    function reload() {
        stackView.replace("HomePage.qml")
    }
}
