import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import QtCharts 2.8

Page {
    Flickable {
        id: flickable
        width: parent.width
        height: parent.height
        contentHeight: mainLayout.height
        clip: true
        bottomMargin: 20

        ColumnLayout {
            id: mainLayout
            width: parent.width * 0.9
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 20
            }
            spacing: 20

            // Day and Date Section
            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                Label {
                    text: Qt.formatDateTime(new Date(), "dddd, MMMM d yyyy")
                    font.bold: true
                    font.pixelSize: 14
                    color: "#333"
                }
            }

            // Row 1: Expenses & Total Inventory
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 120
                spacing: 15

                // Expenses Card
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 115
                    radius: 12
                    color: "#E57373" // Soft Red
                    border.color: "#D32F2F"
                    border.width: 1

                    Column {
                        anchors.centerIn: parent
                        spacing: 5
                        Label {
                            text: qsTr("Total Expenses")
                            font.bold: true
                            color: "white"
                        }
                        Text {
                            text: expenseModel.rowCount().toString().padStart(2, '0')
                            font.bold: true
                            font.pixelSize: 26
                            color: "white"
                        }
                        Text {
                            text: expenseModel.totalCost.toLocaleCurrencyString(Qt.locale("en-MW"))
                            font.bold: true
                            font.pixelSize: 13
                            color: "white"
                        }
                    }
                }

                // Inventory Card
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 115
                    radius: 12
                    color: "#81C784" // Soft Green
                    border.color: "#388E3C"
                    border.width: 1

                    Column {
                        anchors.centerIn: parent
                        spacing: 5
                        Label {
                            text: qsTr("Total Inventory")
                            font.bold: true
                            color: "white"
                        }
                        Text {
                            text: databaseManager.rowCount().toString().padStart(2, '0')
                            font.bold: true
                            font.pixelSize: 26
                            color: "white"
                        }
                        Text {
                            text: databaseManager.totalInventory.toLocaleCurrencyString(Qt.locale("en-MW"));
                            font.bold: true
                            font.pixelSize: 13
                            color: "white"
                        }
                    }
                }
            }

            // Grouped Financial Cards
            RowLayout {
                spacing: 10
                Layout.fillWidth: true
                Layout.preferredHeight: 140

                // Large Card: Total Income
                Pane {
                    id: totalincome
                    Layout.fillWidth: true
                    Layout.preferredHeight: 140
                    Material.elevation: 3
                    padding: 10

                    Column {
                        anchors.centerIn: parent
                        spacing: 5
                        Label {
                            text: qsTr("Net Income")
                            font.bold: true
                            color: "#333"
                            Layout.alignment: Qt.AlignCenter
                        }
                        Text {
                            id:netincomtxt
                            text: incomeModel.totalNetIncome.toLocaleCurrencyString(Qt.locale("en-MW"))
                            font.bold: true
                            font.pixelSize: 19
                            color: "#333"
                        }
                    }
                }

                // Column: Two Smaller Cards (Total Services & COGS)
                ColumnLayout {
                    spacing: 10
                    Layout.fillWidth: true

                    Pane {
                        id: totalServices
                        Layout.fillWidth: true
                        Layout.preferredHeight: 65
                        Material.elevation: 3
                        padding: 10

                        Column {
                            anchors.centerIn: parent
                            spacing: 3
                            Label {
                                text: qsTr("Total Services")
                                font.bold: true
                                color: "#333"
                            }
                            Text {
                                text: ServiceModel.totalService.toLocaleCurrencyString(Qt.locale("en-MW"))
                                font.bold: true
                                font.pixelSize: 14
                                color: "#333"
                            }
                        }
                    }

                    Pane {
                        id: cogs
                        Layout.fillWidth: true
                        Layout.preferredHeight: 65
                        Material.elevation: 3
                        padding: 10

                        Column {
                            anchors.centerIn: parent
                            spacing: 3
                            Label {
                                text: qsTr("Total Cost")
                                font.bold: true
                                color: "#333"
                            }
                            Text {
                                id:cp
                                text: databaseManager.totalCostPrice().toLocaleCurrencyString(Qt.locale("en-MW"))
                                font.bold: true
                                font.pixelSize: 14
                                color: "#333"
                            }
                        }
                    }
                }
            }
            // Line Graph Section (Placeholder)
            Pane {
                Layout.fillWidth: true
                Layout.preferredHeight: 225
                Material.elevation: 2
                padding: 0
                //
                SwipeView {
                    id:view
                    anchors.fill: parent
                    currentIndex: 0
                    //DailyChart
                    Daily{

                    }
                    //Monthly Chart
                    Monthly {

                    }
                }
                PageIndicator {
                    id: indicator

                    count: view.count
                    currentIndex: view.currentIndex

                    anchors.bottom: view.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                }

            }
            Component.onCompleted: {
                incomeModel.updateView()
                netincomtxt.text = incomeModel.totalNetIncome.toLocaleCurrencyString(Qt.locale("en-MW"))
                cp.text = databaseManager.totalCostPrice().toLocaleCurrencyString(Qt.locale("en-MW"))
            }
        }
    }
}
