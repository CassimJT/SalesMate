// ReceiptText.qml
import QtQuick
import QtQuick.Controls

Text {
    // Required properties
    property bool bold: false

    // Styling
    font.family: "Courier New"
    font.pixelSize: 12
    font.bold: bold
    horizontalAlignment: Qt.AlignLeft
    wrapMode: Text.WrapAnywhere
    width: parent?.width ?? implicitWidth
}
