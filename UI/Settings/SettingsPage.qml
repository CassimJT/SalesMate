import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import "../Modles"

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
                    spacing: 8
                    width: parent.width   // Simple and reliable

                    TextField {
                        Layout.fillWidth: true
                        placeholderText: "Business Name"
                    }
                    Label{
                        text: qsTr("Currency")
                    }

                    ComboBox {
                        id: currrencySymbo
                        Layout.fillWidth: true
                        editable: true
                        textRole: "currency"
                        popup.width: parent.width * 0.6
                        popup.x: width - popup.width
                        model: CurrencyModel{}

                        delegate: ItemDelegate {
                            width: parent.width
                            RowLayout {
                                anchors {
                                    left: parent.left
                                    leftMargin: 15
                                }

                                spacing: 8

                                Image {
                                    source: model.flag
                                    Layout.preferredWidth: 26
                                    Layout.preferredHeight: 26
                                    fillMode: Image.PreserveAspectFit
                                }

                                Text {
                                    text: model.currency
                                }
                            }
                        }
                    }
                    TextField {
                        id:city
                        Layout.fillWidth: true
                        placeholderText: "District / city"
                    }

                    TextField {
                        id:adress
                        Layout.fillWidth: true
                        placeholderText: "Adress / location"
                    }
                }
            }
            MenuSeparator {
                Layout.preferredWidth: parent.width * 0.90
                Layout.alignment: Qt.AlignHCenter
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
                    Switch { text: "Auto-print / auto-generate receipt" }
                }
            }

        }
    }
}
