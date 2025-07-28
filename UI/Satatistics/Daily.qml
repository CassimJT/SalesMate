import QtQuick 2.15
import QtQuick.Controls 2.15
import QtCharts 2.15

Page {
    ChartView {
        id: chart
        title: "Daily Income"
        anchors.fill: parent
        antialiasing: true
        legend.visible: false
        animationOptions: ChartView.SeriesAnimations

        BarCategoryAxis {
            id: xAxis
            categories: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
            labelsFont.pixelSize: 10
        }

        ValueAxis {
            id: yAxis
            min: 0
            max: 1000
            labelFormat: "%.0f"
        }

        SplineSeries {
            id: splineSeries
            axisX: xAxis
            axisY: yAxis
            color: "#E91E63"
            width: 2
            pointsVisible: true
        }
    }

    function updateChart() {
        var dayOrder = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
        var dayMap = {};
        dayOrder.forEach(day => dayMap[day] = 0);

        // Process data
        var rawData = ReportManger.weeklyData || [];
        for (var i = 0; i < rawData.length; i++) {
            var entry = rawData[i];
            if (entry && entry.day in dayMap) {
                dayMap[entry.day] = entry.income;
            }
        }

        // Update series
        splineSeries.clear();
        for (var j = 0; j < dayOrder.length; j++) {
            splineSeries.append(j, dayMap[dayOrder[j]]);
        }

        // Auto-scale Y axis
        var maxValue = Math.max(...Object.values(dayMap));
        yAxis.max = maxValue > 0 ? Math.ceil(maxValue * 1.1) : 1000;
    }

    Component.onCompleted: updateChart()
    Connections {
        target: ReportManger
        onWeeklyDataChanged: updateChart()
    }
}
