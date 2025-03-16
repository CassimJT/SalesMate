import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
Page {
    id: addItemPage
    objectName: "Stocks"
    SwipeView{
        id: swipeView
        anchors.fill:parent
        currentIndex: 0
        AddStock {
        }
        ShowStock {
            id: showStockPage

        }
        onCurrentIndexChanged: {
            if (currentIndex === 0) {
                showStockPage.searchBar.text = ""
            }
        }

    }
    footer: TabBar {
        currentIndex: swipeView.currentIndex
        id: bar
        width: parent.width
        TabButton {
            Row {
                spacing: 5
                anchors.centerIn: parent
                Image {
                    id: addstock
                    source: "qrc:/Asserts/icons/icons8-add-100.png"
                    width: 36
                    height: 36
                    fillMode: Image.PreserveAspectFit
                    Layout.alignment: Qt.AlignVCenter
                    anchors {
                        verticalCenter: parent.verticalCenter
                    }
                }
                Label {
                    id:addStockText
                    text:qsTr("Add Stock")
                    Layout.alignment: Qt.AlignVCenter
                    anchors {
                        verticalCenter: addstock.verticalCenter
                    }
                }
            }
            onClicked: {
                swipeView.currentIndex = 0
            }
        }
        TabButton {
            text: qsTr("")
            Row {
                anchors.centerIn: parent
                Image {
                    id: showstock
                    source: "qrc:/Asserts/icons/all-stock.png"
                    width: 36
                    height: 36
                    fillMode: Image.PreserveAspectFit
                    anchors {
                        verticalCenter: parent.verticalCenter
                    }
                }
                Label {
                    id:showStockText
                    text:qsTr("All Stock")
                    Layout.alignment: Qt.AlignVCenter
                    anchors {
                        verticalCenter: showstock.verticalCenter
                    }
                }
            }
            onClicked: {
                swipeView.currentIndex = 1
            }

        }
    }

}
