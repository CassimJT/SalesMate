import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import "../Utils"

Page {
    id: reports
    objectName: "Reports"
    property int totalitemSold: databaseManager.totalQuantitySold()
    property int allitems: databaseManager.totalQuantity() + totalitemSold
    property real soldPercentage: (totalitemSold / allitems) * 100
    property real profit: databaseManager.totalSoldValue() - databaseManager.totalCostPrice()

    property alias details: details
    SearchBar{
        id: searchBar

        anchors {
            top: parent.top
            topMargin: 10
            horizontalCenter: parent.horizontalCenter
        }
    }
    CircularProgressBar {
        id: progressBar
        strokeBgWidth: 5
        progressColor: "#E91E63"
        bgStrokeColor: "lightgray"
        progressWidth: 10
        iconSource: "qrc:/Asserts/icons/profit.png"
        iconIsVisible: true
        opacity: 0.8
        value: soldPercentage
        netIncom: databaseManager.totalSoldValue()
        expectedIncom: databaseManager.expectedNetIncome()
        profit: reports.profit
        anchors {
            top: searchBar.bottom
            topMargin: 15
            horizontalCenter: parent.horizontalCenter
        }
    }
    ListView {
        id:itemReportView
        clip: true
        anchors {
            top: progressBar.bottom
            right: parent.right
            left: parent.left
            bottom: parent.bottom
        }
        model: productFilterModel
        delegate: ItemReportViewDelegate{
            width: ListView.view.width
            details: reports.details
        }

    }
    Component.onCompleted: {
        //do something when the componet is loaded
    }
    Drawer {
        id: details
        width: parent.width
        height: Math.min(parent.height * 0.4, 300) // Limit maximum height
        dragMargin: 0
        edge: Qt.BottomEdge
        padding: 0

        property real progressValue: 0.0
        property string itemname: "Name"
        property real cp: 0.0
        property real sp: 0.0
        property real profit: 0.0
        property int sold: 0.0
        property real at: 0.0

        Rectangle {
            id: handle
            width: 40
            height: 4
            radius: height/2
            color: "#333"
            anchors {
                top: parent.top
                topMargin: 8
                horizontalCenter: parent.horizontalCenter
            }
        }

        Flickable {
            anchors {
                top: handle.bottom
                topMargin: 10
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            contentHeight: contentColumn.height
            clip: true

            ColumnLayout {
                id: contentColumn
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 12

                // Item Name
                Label {
                    id: itemnameLabel
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 5
                    text: details.itemname
                    font {
                        pixelSize: 18
                        bold: true
                    }
                    elide: Text.ElideRight
                    maximumLineCount: 1
                }

                // Details Grid
                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    columnSpacing: 10
                    rowSpacing: 8

                    // Sold
                    Label {
                        text: "Sold:"
                        font.pixelSize: 14
                        color: "#666"
                        Layout.alignment: Qt.AlignRight
                    }
                    Label {
                        text: details.sold + " Items "
                        font.pixelSize: 14
                        font.bold: true
                    }
                    // at
                    Label {
                        text: "At:"
                        font.pixelSize: 14
                        color: "#666"
                        Layout.alignment: Qt.AlignRight
                    }
                    Label {
                        text: details.at.toLocaleCurrencyString(Qt.locale("en-MW"))
                        font.pixelSize: 14
                        font.bold: true
                    }

                    // Cost Price
                    Label {
                        text: "Cost Price:"
                        font.pixelSize: 14
                        color: "#666"
                        Layout.alignment: Qt.AlignRight
                    }
                    Label {
                        text: details.cp.toLocaleCurrencyString(Qt.locale("en-MW")) + " each "
                        font.pixelSize: 14
                        font.bold: true
                    }

                    // Selling Price
                    Label {
                        text: "Selling Price:"
                        font.pixelSize: 14
                        color: "#666"
                        Layout.alignment: Qt.AlignRight
                    }
                    Label {
                        text: details.sp.toLocaleCurrencyString(Qt.locale("en-MW")) + " each "
                        font.pixelSize: 14
                        font.bold: true
                    }

                    // Profit
                    Label {
                        text: "Net Result:"
                        font.pixelSize: 14
                        color: "#666"
                        Layout.alignment: Qt.AlignRight
                    }
                    Label {
                        text: {
                            var formatted = details.profit.toLocaleCurrencyString(Qt.locale("en-MW"))
                            return (details.profit < 0 && !formatted.includes("-"))
                                    ? "-" + formatted
                                    : formatted;
                        }

                        font.pixelSize: 14
                        font.bold: true
                        color: details.profit >= 0 ? "#4CAF50" : "#F44336"
                    }
                }

                // Progress Bar
                ColumnLayout {
                    Layout.topMargin: 10
                    Layout.preferredWidth: parent.width
                    spacing: 5

                    ProgressBar {
                        id: itemProgress
                        Layout.preferredWidth: parent.width
                        Layout.alignment: Qt.AlignHCenter
                        from: 0
                        to: 100
                        value: details.progressValue

                        background: Rectangle {
                            implicitWidth: parent.width
                            implicitHeight: 8
                            color: "#e0e0e0"
                            radius: 4
                        }

                        contentItem: Item {
                            implicitWidth: parent.width
                            implicitHeight: 8

                            Rectangle {
                                width: parent.width * (parent.parent.value / 100)
                                height: parent.height
                                radius: 4
                                color: {
                                    var ratio = parent.parent.value / 100;
                                    if (ratio < 0.3) return "#ff5722";
                                    if (ratio < 0.7) return "#ffc107";
                                    return "#4caf50";
                                }
                            }
                        }
                    }

                    // Percentage Label
                    Label {
                        Layout.alignment: Qt.AlignHCenter
                        text: qsTr("%1% Sold").arg(itemProgress.value.toFixed(1))
                        font {
                            pixelSize: 16
                            bold: true
                        }
                        color: {
                            var ratio = itemProgress.value / 100;
                            if (ratio < 0.3) return "#ff5722";
                            if (ratio < 0.7) return "#ffc107";
                            return "#4caf50";
                        }
                    }
                }
            }
        }
    }
}
