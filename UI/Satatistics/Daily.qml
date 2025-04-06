import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import QtCharts 2.8

Page {
    ChartView {
        id: chart
        title: "Daily Income"
        anchors.fill: parent
        anchors.margins: 0
        antialiasing: true
        backgroundRoundness: 5
        legend.visible: false
        animationOptions:ChartView.SeriesAnimations

        BarCategoryAxis {
            id: xAxis
            categories: ["Ma", "Tu", "We", "Th", "Fr", "Su", "Sa"]
            visible: true
        }

        BarSeries {
            id: incomeSeries
            axisX: xAxis
            barWidth: 0.17

            BarSet {
                label: "Income"
                color: "#E91E63"
                values: [1000, 3000, 2500, 4500, 1500, 4000, 5000]
            }
        }
    }
    Component.onCompleted: {
        //console.log(ReportManger.getWeeklyReportData())
    }
}
