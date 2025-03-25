// MainSatckView.qml
import QtQuick 2.15
import QtQuick.Controls 2.15

StackView {
    property alias stackView: stackView
    id: stackView
    objectName: "StackView"
    anchors.fill: parent
    initialItem: "HomePage.qml"
    Keys.onBackPressed: {
        if(stackView.depth > 1) {
            stackView.pop()
        } else {
            Qt.quit()
        }

    }
}
