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
                id:barset
                label: "Income"
                values: updateChart()
            }
        }
    }
    Component.onCompleted: {
        //console.log(ReportManger.getWeeklyReportData())
        updateChart()
    }
    Connections {
        target: ReportManger
        onWeeklyDataChanged: function() {
            updateChart()
        }
    }
    //extracting the values for the barset
    function updateChart() {
        var dayOrder = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
        var dayMap = {
            "Mon": 0,
            "Tue": 0,
            "Wed": 0,
            "Thu": 0,
            "Fri": 0,
            "Sat": 0,
            "Sun": 0
        };
        var rawData = ReportManger.weeklyData || [];
        for (var i = 0; i < rawData.length; i++) {
            var entry = rawData[i];
            if (entry && entry.day in dayMap) {
                dayMap[entry.day] = entry.income;
            }
        }
        var values = dayOrder.map(function(day) {
            return dayMap[day];
        });
        console.log("rawData:", JSON.stringify(rawData));
        console.log("Processed values:", values);
        //barset.replace(values);
        return values
    }


}
