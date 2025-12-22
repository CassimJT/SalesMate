import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../Utils"

Page {
    id: welcomeRoot
    objectName: "WelcomePage"
    signal agree()

    ColumnLayout {
        id: mainColumn
        width: parent.width * 0.80
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: parent.height * 0.10
        }

        spacing: 20

        // Logo
        Image {
            id: logo
            Layout.preferredWidth: 160
            Layout.preferredHeight: 160
            Layout.alignment: Qt.AlignHCenter
            source: "qrc:/Asserts/icons/xxxhdpi.png"
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
        }

        // App name / Welcome title
        Text {
            text: qsTr("Welcome to SalesMate")
            font.pixelSize: 28
            font.weight: Font.DemiBold
            color: "#2E7D32"  // Dark green to match Material.Green theme
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
        }

        // Tagline / Motto
        Text {
            text: qsTr("Your Smart Business Companion")
            font.pixelSize: 16
            color: "#555555"
            opacity: 0.8
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
            Layout.maximumWidth: welcomeRoot.width * 0.8
            wrapMode: Text.WordWrap
        }

        // Optional subtle description (recommended for professionalism)
        Text {
            text: qsTr("Manage sales, track inventory, and grow your business effortlessly.")
            font.pixelSize: 14
            color: "#666666"
            opacity: 0.7
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
            Layout.maximumWidth: welcomeRoot.width * 0.8
            wrapMode: Text.WordWrap
        }
        // Privacy & Terms notice
        RowLayout {
            id: row
            Layout.fillWidth: true
            spacing: 8

            CheckBox {
                id: policy
                Layout.alignment: Qt.AlignTop
            }

            Text {
                text: qsTr(
                          "Read our <a href='#'>Privacy Policy</a>. "
                          + "Tap \"Agree and continue\" to accept the "
                          + "<a href='#'>Terms of Service</a>."
                          )
                font.pixelSize: 14
                color: "#666666"
                wrapMode: Text.WordWrap
                textFormat: Text.RichText

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter

                onLinkActivated: (link) => {
                                     console.log("Link clicked:", link)
                                 }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.NoButton
                    cursorShape: parent.hoveredLink
                                 ? Qt.PointingHandCursor
                                 : Qt.ArrowCursor
                }
            }
        }

        // Get Started Button
        CustomButton {
            id: getStartedBtn
            isAnabled: policy.checked
            btnText: qsTr("Agree and continue")
            btnWidth: 250
            btnHeight: 52
            opacity: policy.checked ? 1 : 0.4
            btnColor:  "#4CAF50"  // Material Green
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 50
            onBtnClicked: {
                if( getStartedBtn.isAnabled) {
                    welcomeRoot.agree()
                }
            }
        }
    }
}
