import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15

Page {
    id: rolePage

    signal workerSelected()
    signal ownerSelected()
    signal registerSelected()
    signal back()
    property color btnColor: "#333"


    ColumnLayout {
        id: mainColumn
        width: parent.width * 0.85
        anchors.centerIn: parent
        spacing: 32

        // Title
        Text {
            text: qsTr("Choose your role")
            font.pixelSize: 28
            font.weight: Font.DemiBold
            color: "#2E7D32"  // Dark green to match your app theme
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
        }

        // Subtitle
        Text {
            text: qsTr("Select how you'll be using SalesMate")
            font.pixelSize: 16
            color: "#555555"
            opacity: 0.85
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            Layout.maximumWidth: parent.width
        }

        // Role Buttons - Styled as cards for better visual hierarchy
        ColumnLayout {
            spacing: 5
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true

            Button {
                text: qsTr("Worker / Cashier")
                onClicked: rolePage.workerSelected()
                Layout.alignment: Qt.AlignHCenter
                icon.source: "qrc:/Asserts/Welcome/cashier.svg"
                Material.background: Material.Green
                Material.foreground: rolePage.btnColor
                font.pointSize: 12
                padding: 10

            }
            MenuSeparator{Layout.preferredWidth: parent.width}

            Button {
                text: qsTr("Business Owner")
                onClicked: rolePage.ownerSelected()
                Layout.alignment: Qt.AlignHCenter
                icon.source: "qrc:/Asserts/Welcome/landlord.svg"
                Material.background: Material.Green
                Material.foreground: rolePage.btnColor
                padding: 5

            }
            MenuSeparator{Layout.preferredWidth: parent.width}
            Button {
                text: qsTr("Register New Business")
                Layout.alignment: Qt.AlignHCenter
                onClicked: rolePage.registerSelected()
                icon.source: "qrc:/Asserts/Welcome/new.svg"
                Material.background: Material.Green
                Material.foreground: rolePage.btnColor
                padding: 5

            }
        }

        // Optional subtle footer note
        Text {
            text: qsTr("You can change your role later in settings")
            font.pixelSize: 13
            color: "#777777"
            opacity: 0.7
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 20
        }

        RoundButton {
            id: bac
            Layout.preferredWidth:  60
            Layout.preferredHeight: 60
            height: width
            icon.source: "qrc:/Asserts/icons/iback.svg"
            Layout.alignment: Qt.AlignHCenter
            Material.background: Material.Green
            onClicked: {
                rolePage.back()
            }
        }
    }
}
