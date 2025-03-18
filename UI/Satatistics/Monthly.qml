import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import QtCharts 2.8

Page {

    ChartView {
        id: chart
        title: "Monthly Income"
        anchors.fill: parent
        antialiasing: true
        legend.visible: false
        animationOptions: ChartView.SeriesAnimations

        // X-Axis: Months (BarCategoryAxis for months)
        BarCategoryAxis {
            id: xAxis
            categories: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
            visible: true
            labelsFont.pixelSize: 5
        }

        // Y-Axis: Income range (Use CategoryAxis for the Y-Axis)
        CategoryAxis {
            id: yAxis
            min: 0
            max: 6000
            tickCount: 7
            labelFormat: "d"
            labelsVisible: true
            labelsFont.pixelSize: 7
        }

        // Smooth line chart for income (LineSeries)
        SplineSeries {
            id: incomeSeries
            axisX: xAxis
            color: "#E91E63"
            pointsVisible: true
            width: 2 // Adjust line width for smoothness

            // Data points for the months (Jan, Feb, Mar, etc.)
            XYPoint { x: 0; y: 1000 }
            XYPoint { x: 1; y: 3000 }
            XYPoint { x: 2; y: 2500 }
            XYPoint { x: 3; y: 4500 }
            XYPoint { x: 4; y: 1500 }
            XYPoint { x: 5; y: 4000 }
            XYPoint { x: 6; y: 5000 }
            XYPoint { x: 7; y: 3200 }
            XYPoint { x: 8; y: 4100 }
            XYPoint { x: 9; y: 2900 }
            XYPoint { x: 10; y: 4700 }
            XYPoint { x: 11; y: 5300 }
        }
    }

}
