import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

Page {
    id: statistics
    objectName: "Statistics"

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: 0
        Summary {

        }
        Reports {

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
                    source: "qrc:/Asserts/icons/summary-100.png"
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
                     text:qsTr("Summary")
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
        //currentSale
        TabButton {
            text: qsTr("")
            Row {
                anchors.centerIn: parent
                //image
                Image {
                    id: giff
                    width: 36
                    height: width
                    source: "qrc:/Asserts/icons/reports-100.png"
                    fillMode:Image.PreserveAspectFit
                    anchors {
                        verticalCenter: parent.verticalCenter
                    }

                }
                Label {
                    id:showStockText
                    text:qsTr("Reports")
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
}
