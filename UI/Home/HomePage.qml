import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import "../Stock"
import SalesModel
import "../Receipt"
import "../Utils"
import "../Utils/Utils.js" as Utils
import QtQuick.Controls.Material
Page {
    id: addItemPage
    objectName: "Home"
    property int btnPadding: 6
    SwipeView{
        id: swipeView
        anchors.fill:parent
        currentIndex: 0
        //home
        Home {
            id:home
        }
        //service Page
        ServicesPage {
            id: services

        }
        //current Sales
        ShowSalesPage {
        }
        onCurrentIndexChanged: {
            services.directionText.visible = false
        }
    }
    footer: TabBar {
        id: bar
        width: parent.width
        height: 65
        currentIndex: swipeView.currentIndex
        topPadding: addItemPage.btnPadding
        Material.elevation: 1

        // POS Tab
        TabButton {
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 4
                Item {
                    Layout.fillHeight: false
                    Layout.preferredHeight: addItemPage.btnPadding
                }

                Image {
                    source: "qrc:/Asserts/icons/POS.png"
                    Layout.preferredWidth: 28
                    Layout.preferredHeight: 28
                    fillMode: Image.PreserveAspectFit
                    Layout.alignment: Qt.AlignHCenter
                }

                Label {
                    text: qsTr("POS")
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            onClicked: swipeView.currentIndex = 0
        }

        // Services Tab
        TabButton {
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 4
                Item {
                    Layout.fillHeight: false
                    Layout.preferredHeight: addItemPage.btnPadding
                }

                Image {
                    source: "qrc:/Asserts/icons/Service.png"
                    Layout.preferredWidth: 28
                    Layout.preferredHeight: 28
                    fillMode: Image.PreserveAspectFit
                    Layout.alignment: Qt.AlignHCenter
                }

                Label {
                    text: qsTr("Services")
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            onClicked: swipeView.currentIndex = 1
        }

        // Current Sales Tab
        TabButton {
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 4
                Item {
                    Layout.fillHeight: false
                    Layout.preferredHeight: addItemPage.btnPadding
                }

                Item {
                    width: 28
                    height: 28
                    Layout.alignment: Qt.AlignHCenter

                    AnimatedImage {
                        id: giff
                        anchors.fill: parent
                        source: "qrc:/Asserts/icons/a_cart.gif"
                        fillMode: Image.PreserveAspectFit
                    }

                    Rectangle {
                        id: contentRec
                        color: "red"
                        width: 16
                        height: 16
                        radius: 8
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.margins: -4

                        Text {
                            text: SalesModel.modelSize() || 0
                            font.pixelSize: 9
                            color: "white"
                            anchors.centerIn: parent
                        }
                    }
                }

                Label {
                    text: qsTr("Current Sales")
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            onClicked: swipeView.currentIndex = 2
        }
    }
    //receipt
    Receipt {
        id: receipt
        onPrintClicked: {
            //print
        }
        onCancelClicked: {
            home.totalSale = 0.0;
            Utils.resetField();
            home.payementDiretionText.visible = false;
            SalesModel.clearModel()
            home.paymentField.text = ""
            home.changeField.text = ""
            receipt.close()
        }
        onSaveClicked: {
            //save

        }
        onShareClicked: {
            //share

        }
    }
    Connections {
        target: databaseManager
       function onSalesProcessed() {
            if (stackView.currentItem && stackView.currentItem.objectName === "Home") {
                receipt.open();
            }
        }
    }

}
