import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

Page {
    id: root
    signal finish()
    signal back()

    ColumnLayout {
        width: parent.width * 0.80
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: parent.height * 0.15
        }
        anchors.margins: 24
        spacing: 20

        Label {
            text: "Business Details"
            font.pixelSize: 28
            font.weight: Font.DemiBold
            color: "#2E7D32"  // Dark green to match your app theme
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
        }

        ColumnLayout {
            spacing: 10
            TextField {
                id: businessName
                placeholderText: "Business name"
                Layout.fillWidth: true
            }
            Label {
                text: qsTr("District / City")
            }

            ComboBox {
                id: location
                Layout.fillWidth: true
                model: ['Mzuzu','Lilongwe']
                currentIndex: 0
            }
            TextField {
                id: address
                placeholderText: "Address / Location / Village"
                Layout.fillWidth: true
            }
            TextField {
                id: email
                placeholderText: "Email"
                Layout.fillWidth: true
            }

        }
        Button {
            text: "Complete Setup"
            Layout.fillWidth: true
            height: 56
            Material.background: Material.Green
            onClicked: root.finish()
        }

    }

    RoundButton {
        id: bac
        width: 60
        height: width
        icon.source: "qrc:/Asserts/icons/iback.svg"
        Material.background: Material.Green
        onClicked: {
            root.back()
        }
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: parent.height * 0.10
        }
    }
}
