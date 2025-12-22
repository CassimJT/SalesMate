// CountrySelector.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../Modles"

RowLayout {
    id: root
    spacing: 8

    signal countryChanged(string code)

    property alias currentIndex: combo.currentIndex
    property string selectedCode: combo.currentIndex >= 0
                                  ? combo.model.get(combo.currentIndex).code
                                  : ""

    onSelectedCodeChanged: {
        if (selectedCode !== "")
            countryChanged(selectedCode)
    }

    Image {
        id: flag
        source: combo.currentIndex >= 0
                ? combo.model.get(combo.currentIndex).flag
                : ""
        Layout.preferredWidth: 38
        Layout.preferredHeight: combo.height
        fillMode: Image.PreserveAspectFit
        Layout.alignment: Qt.AlignVCenter
    }

    ComboBox {
        id: combo
        model: CountryModel {}
        textRole: "name"
        Layout.fillWidth: true

        delegate: ItemDelegate {
            width: combo.width
            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 8

                Image {
                    source: model.flag
                    Layout.preferredWidth: 26
                    Layout.preferredHeight: 26
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    text: model.name + " (" + model.code + ")"
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        Component.onCompleted: {
            for (let i = 0; i < model.count; ++i) {
                if (model.get(i).name === "Malawi") {
                    currentIndex = i
                    break
                }
            }
        }
    }
}
