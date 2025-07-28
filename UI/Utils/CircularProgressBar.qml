import QtQuick 
import QtQuick.Shapes 

Item {
    id: progress
    implicitWidth: parent.width *0.65
    implicitHeight: implicitWidth

    // Properties
    // General
    property bool roundCap: true
    property int startAngle: -240
    property real maxValue: 100
    property real value: 40
    property int samples: 4
    // Bg Circle
    property color bgColor: "transparent"
    property color bgStrokeColor: "#7e7e7e"
    property int strokeBgWidth: 16
    // Progress Circle
    property color progressColor: "#55aaff"
    property int progressWidth: 16
    // Text
    property string text: ""
    property bool textShowValue: true
    property string textFontFamily: "Segoe UI"
    property int textSize: 12
    property color textColor: "#7c7c7c"

    //image
    property string iconSource: ""
    property bool iconIsVisible: false

    //inner text
    property real netIncom: 0
    property real expectedIncom: 0
    property real profit: 0
    property bool isSigned: flase
    property string sign:isSigned ? "" : "-"


    Shape{
        id: shape
        anchors.fill: parent
        layer.enabled: true
        layer.samples: progress.samples

        ShapePath{
            id: pathBG
            strokeColor: progress.bgStrokeColor
            fillColor: progress.bgColor
            strokeWidth: progress.strokeBgWidth
            capStyle: progress.roundCap ? ShapePath.RoundCap : ShapePath.FlatCap

            PathAngleArc{
                radiusX: (progress.width / 2) - (progress.progressWidth / 2)
                radiusY: (progress.height / 2) - (progress.progressWidth / 2)
                centerX: progress.width / 2
                centerY: progress.height / 2
                startAngle: progress.startAngle
                sweepAngle: 300
            }
        }

        ShapePath{
            id: path
            strokeColor: progress.progressColor
            fillColor: "transparent"
            strokeWidth: progress.progressWidth
            capStyle: progress.roundCap ? ShapePath.RoundCap : ShapePath.FlatCap

            PathAngleArc{
                radiusX: (progress.width / 2) - (progress.progressWidth / 2)
                radiusY: (progress.height / 2) - (progress.progressWidth / 2)
                centerX: progress.width / 2
                centerY: progress.height / 2
                startAngle: progress.startAngle
                sweepAngle: (300 / progress.maxValue * progress.value)
            }
        }

        Item {
            id: innaContent
            anchors.centerIn: parent
            width: parent.width * 0.7
            height: parent.height * 0.7

            Column {
                anchors.centerIn: parent
                spacing: 5

                // Income section
                Column {
                    width: parent.width
                    spacing: 2
                    //icon
                    Image {
                        id: icon
                        width: 36
                        height: width
                        source: progress.iconSource
                        visible: progress.iconIsVisible
                        fillMode: Image.PreserveAspectFit
                        anchors.horizontalCenter: parent.horizontalCenter

                    }
                    Text {
                        id: incomeText
                        text: progress.netIncom.toLocaleCurrencyString(Qt.locale("en-MW"))
                        color: "#4CAF50" // Green for income
                        font.pixelSize: 20
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        text:"Of " + progress.expectedIncom.toLocaleCurrencyString(Qt.locale("en-MW"))
                        color: "lightgray"
                        font.pixelSize: 12
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                // Profit/Loss section
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 15

                    Column {
                        spacing: 2

                        Text {
                            text: "Profit"
                            color: "Gray"
                            font.pixelSize: 12
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Text {
                            text: progress.profit.toLocaleCurrencyString(Qt.locale("en-MW")) // Placeholder for profit
                            color: "#4CAF50" // Green for profit
                            font.pixelSize: 12
                            font.bold: true
                            anchors.horizontalCenter: parent.horizontalCenter

                        }
                    }

                }
            }
        }

    }
}


