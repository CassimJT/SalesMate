import QtQuick 2.15
import QtQuick.Controls

Popup {
    id: camera
    width: parent.width * 0.8
    height: parent.height * 0.8
    anchors.centerIn: parent
    signal imageCaptured()
}
