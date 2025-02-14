// MainSatckView.qml
import QtQuick 2.15
import QtQuick.Controls 2.15

StackView {
    id: stackView
    objectName: "StackView"
    anchors.fill: parent
    initialItem: "HomePage.qml"
    Keys.onBackPressed: {

    }
}
