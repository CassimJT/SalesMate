import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import SalesModel

ItemDelegate {
    id: delegate
    width: parent.width
    height: 70
    padding: 10

    // Properties with default values
    property real sold_item: model.quantitysold
    property real total_item: sold_item + (model.quantity || 0)
    property real sold_item_price: sold_item * (model.price || 0)
    property real total_item_price: model.quantity * model.price
    property real sold_item_percent: total_item_price > 0 ? (sold_item / total_item) * 100 : 0

    Component.onCompleted: {
        //...
    }

    RowLayout {
        Layout.preferredWidth: parent.width * 0.8
        anchors.centerIn: parent
        spacing: 20
        //child 1
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 5

            Label {
                text: model.name || "No name"
                Layout.preferredWidth: 100
                font {
                    pixelSize: 14
                    bold: true
                }
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignLeft
                Layout.fillWidth: true
            }

            Label {
                text: qsTr("Sold %1 of %2").arg(delegate.sold_item || 0).arg(delegate.total_item)
                font.pixelSize: 12
                Layout.preferredWidth: 100
                elide: Text.ElideRight
                color: "gray"
                Layout.fillWidth: true
            }
        }
        //child 2
        ProgressBar {
            Layout.preferredWidth: 100
            Layout.alignment: Qt.AlignVCenter
            from: 0
            to: 100
            value: sold_item_percent

            background: Rectangle {
                implicitWidth: 100
                implicitHeight: 6
                color: "#e0e0e0"
                radius: 3
            }

            contentItem: Item {
                implicitWidth: 100
                implicitHeight: 6

                Rectangle {
                    width: parent.width * (parent.parent.value / 100)
                    height: parent.height
                    radius: 3
                    color: {
                        var ratio = parent.parent.value / 100;
                        if (ratio < 0.3) return "#ff5722";
                        if (ratio < 0.7) return "#ffc107";
                        return "#4caf50";
                    }
                }
            }
        }
        //child 3
        Label {
            text: qsTr("Sold %1%").arg(sold_item_percent.toFixed(1))
            font.pixelSize: 12
            color: "gray"
            Layout.preferredWidth: 50
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignLeft
            textFormat: Text.PlainText
        }
    }
    //menu seperator lines
    MenuSeparator {
        width: parent.width * 0.9
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
        }
    }
}
