import QtQuick 2.15
import QtQuick.Controls
Popup {
    id: editProduct
    width: parent.width * 0.8
    height: parent.height * 0.7
    anchors.centerIn: parent

    //
    property string name: ""
    Label {
        anchors.centerIn:parent
        text: editProduct.name
    }
}
