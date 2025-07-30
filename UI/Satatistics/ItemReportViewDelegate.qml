import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import SalesModel

ItemDelegate {
    id: delegate
    width: parent.width
    height: Math.max(65, implicitHeight)
    padding: 0  // We'll handle margins in the content

    // Properties with default values
    property real sold_item: model.quantitysold
    property real total_item: sold_item + (model.quantity || 0)
    property real sold_item_price: sold_item * (model.price || 0)
    property real total_item_price: total_item * model.price
    property real sold_item_percent: total_item_price > 0 ? (sold_item / total_item) * 100 : 0
    property var details
    property real totalCp: model.cp * model.price

    //property for the drawer detsil
    property real sold_percent: (sold_item / total_item) * 100
    property real profit: sold_item_price - totalCp

    Item {
        width: parent.width * .85
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter

        RowLayout {
            anchors.fill: parent
            spacing: 10

            // Child 1 - Product Info (left-aligned)
            ColumnLayout {
                Layout.preferredWidth: parent.width * 0.40
                Layout.alignment: Qt.AlignVCenter
                spacing: 5

                Label {
                    text: model.name || "No name"
                    font {
                        pixelSize: Qt.application.font.pixelSize * 1.1
                        bold: true
                    }
                    elide: Text.ElideRight
                    maximumLineCount: 1
                    Layout.fillWidth: true
                }

                Label {
                    text: qsTr("Sold %1 of %2").arg(delegate.sold_item || 0).arg(delegate.total_item)
                    font.pixelSize: Qt.application.font.pixelSize * 0.9
                    elide: Text.ElideRight
                    color: "gray"
                    maximumLineCount: 1
                    Layout.fillWidth: true
                }
            }

            // Child 2 - Progress Bar (centered)
            Item {
                Layout.preferredWidth: parent.width * 0.36
                Layout.alignment: Qt.AlignCenter

                ProgressBar {
                    width: parent.width
                    anchors.centerIn: parent
                    from: 0
                    to: 100
                    value: sold_item_percent

                    background: Rectangle {
                        implicitWidth: parent.width
                        implicitHeight: 6
                        color: "#e0e0e0"
                        radius: 3
                    }

                    contentItem: Item {
                        implicitWidth: parent.width
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
            }

            // Child 3 - Percentage ()
            Label {
                text: qsTr("Sold %1%").arg(sold_item_percent.toFixed(1))
                font.pixelSize: Qt.application.font.pixelSize * 0.9
                color: "gray"
                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                Layout.preferredWidth: parent.width * 0.24
               // horizontalAlignment: Text.AlignRight
                elide: Text.ElideRight
            }
        }


    }
    // Menu separator lines (inside the 90% width container)
    MenuSeparator {
        width: parent.width * 0.9
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
        }
    }

    onClicked: {
        details.open()
        details.progressValue = delegate.sold_percent
        details.cp = model.cp
        details.sp = model.price
        details.itemname = model.name
        details.sold = delegate.sold_item
        details.profit = (model.quantitysold * model.price) - (model.cp * delegate.total_item)
        details.at = delegate.sold_item_price
        console.log(totalCp)
    }
}
