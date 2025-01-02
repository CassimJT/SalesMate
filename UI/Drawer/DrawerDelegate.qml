import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

ItemDelegate {
    id: itemDelegate
    width: parent.width
    height: 50
    RowLayout {
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 10
        }
        Image {
            id: icon
            source: model.icon
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            fillMode: Image.PreserveAspectFit
        }
        Text {
            id: text
            text: qsTr(model.name)
        }
    }
    onClicked: {
        mainStakView.push(model.pageSource)
        drawer.close()
    }
}
