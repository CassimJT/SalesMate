import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import "../Utils"
import "../Profile"

Rectangle {
    id: profile
    width: parent.width
    height: 180
    clip:true
    property string imageSource: ""
    property string defaultImageSource: "qrc:/Asserts/icons/profile.png"

    ColumnLayout {
        width:profile.width
        spacing: 8
        anchors {
            left: parent.left
            right: parent.right
            leftMargin: 10
            rightMargin: 10
            top:parent.top

        }
        // The Text element
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing:1
            Image {
                id: sales
                Layout.preferredWidth: 36
                Layout.preferredHeight: 36
                source: "qrc:/Asserts/icons/HDPI.png"
                fillMode: Image.PreserveAspectFit
            }
            Label {
                id:apptitle
                text: qsTr("SalesMate")
                font.pointSize: 16
            }
        }

        MenuSeparator{
            Layout.fillWidth: true
        }
        RowLayout {
            //Avatar
            Avatar {
                id:avata
                iconInsidebackgroundScaleFactor: 0.85
                onClicked: {
                    mainStakView.push("../Profile/ProfilePage.qml")
                    drawer.close()
                }
            }
            Column {
                Label {
                    id: username
                    text: qsTr("Sara Phiri")
                    font.pointSize: 24
                    //font.bold: true
                }
                Label {
                    id: position
                    text: qsTr("Tela 1")
                    font.pointSize: 14
                    color: "grey"
                }
            }
        }
        MenuSeparator{
            Layout.fillWidth: true
        }
    }
}
