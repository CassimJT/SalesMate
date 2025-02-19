import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
Page {
    id: satatistics
    objectName: "Statistics"
    Flickable{
        id: flickable
        width: parent.width
        height: parent.height
        contentHeight: mainLayout.height
        clip: true
        ColumnLayout {
            id: mainLayout
            width: parent.width * 0.9
            anchors{
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 10
            }

            Row{
                Layout.preferredWidth: parent.width
                spacing: 10
                Rectangle {
                    id:expense
                    width: parent.width * 0.5
                    height: 100
                    color: "lightBlue"
                    radius: 10
                    Text {
                        id: eText
                        text: expenseModel.rowCount().toString().padStart(2,'0') //view tatal expense
                        anchors.centerIn: parent
                        font.bold: true
                        font.pixelSize: 24
                        color: "grey"
                    }
                }
                Rectangle {
                    id:income
                    width: parent.width *.5
                    height: 100
                    color: "lightGreen"
                    radius: 10
                    Text {
                        id: iText
                        text: qsTr("00")
                        anchors.centerIn: parent
                        font.bold: true
                        font.pixelSize: 24
                        color: "grey"
                    }
                }
            }

        }

    }



}
