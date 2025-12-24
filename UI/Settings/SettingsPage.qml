import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

Page {
    id: settingsPage
    title: "Settings"

    Flickable {
        anchors.fill: parent
        anchors.topMargin: 10
        contentHeight: contentColumn.height
        clip: true
        ColumnLayout {
            id: contentColumn
            width: parent.width
            spacing: 24

            GroupBox {
                title: "Business & Localization"
                Layout.preferredWidth: parent.width * 0.90
                Layout.fillWidth: false
                Layout.alignment: Qt.AlignHCenter

                ColumnLayout {
                    spacing: 12
                    width: parent.width   // Simple and reliable

                    TextField {
                        Layout.fillWidth: true
                        placeholderText: "Business Name"
                    }
                    ComboBox {
                        Layout.fillWidth: true
                        model: ["MWK", "USD", "ZAR"]
                    }
                    ComboBox {
                        Layout.fillWidth: true
                        model: ["Before amount", "After amount"]
                    }
                }
            }

            GroupBox {
                title: "Sales Behavior"
                Layout.preferredWidth: parent.width * 0.90
                Layout.fillWidth: false
                Layout.alignment: Qt.AlignHCenter

                ColumnLayout {
                    spacing: 12
                    width: parent.width

                    Switch { text: "Prices include tax" }
                    SpinBox { Layout.fillWidth: true; from: 0; to: 100 }
                    Switch { text: "Allow discounts" }
                }
            }

            GroupBox {
                title: "Payment Settings"
                Layout.preferredWidth: parent.width * 0.90
                Layout.fillWidth: false
                Layout.alignment: Qt.AlignHCenter

                ColumnLayout {
                    spacing: 5
                    width: parent.width
                    CheckBox { text: "Cash" }
                    CheckBox { text: "Mobile Money" }
                    CheckBox { text: "Bank Transfer" }
                }
            }
        }
    }
}
