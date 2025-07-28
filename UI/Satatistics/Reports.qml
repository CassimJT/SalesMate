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
        }

    }
    Component.onCompleted: {

    }
}
