import QtQuick 2.15
import QtQuick.Controls 2.15
import QtCharts 2.15

Page {
    ChartView {
        id: chart
        title: "Monthly Income"
        anchors.fill: parent
        antialiasing: true
        legend.visible: false
        animationOptions: ChartView.SeriesAnimations

        // X-Axis (Months)
        BarCategoryAxis {
            id: xAxis
            categories: ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
            labelsFont.pixelSize: 5
        }

        // Y-Axis (Income)
        ValueAxis {
            id: yAxis
            min: 0
            max: 6000  // Will be auto-adjusted
            labelFormat: "%.0f"
        }

        // Area Series
        AreaSeries {
            id: areaSeries
            axisX: xAxis
            axisY: yAxis
            color: "#E91E63"
            opacity: 0.5
            borderWidth: 2
            borderColor: "#C2185B"

            upperSeries: LineSeries { id: upperLine }
            lowerSeries: LineSeries { id: lowerLine }
        }
    }

    function updateMonthlyChart() {
        // Clear existing data
        upperLine.clear();
        lowerLine.clear();
        // Month order (must match xAxis.categories)
        var monthOrder = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                         "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        var monthMap = {};
        monthOrder.forEach(month => monthMap[month] = 0);

        // Process data from C++
        var rawData = ReportManger.monthlyData || [];
        console.log(rawData)
        for (var i = 0; i < rawData.length; i++) {
            var entry = rawData[i];
            if (entry && entry.month in monthMap) {
                monthMap[entry.month] = entry.income;
            }
        }

        var maxValue = 0;

        for (var j = 0; j < monthOrder.length; j++) {
            var income = monthMap[monthOrder[j]];
            upperLine.append(j, income);
            lowerLine.append(j, 0);

            if (income > maxValue) {
                maxValue = income;
            }
        }
        // Adjust Y-axis with 10% padding
        yAxis.max = maxValue > 0 ? Math.ceil(maxValue * 1.1) : 6000;
    }

    Component.onCompleted: updateMonthlyChart()
    Connections {
        target: ReportManger
        onMonthlyDataChanged: updateMonthlyChart()
    }
}
