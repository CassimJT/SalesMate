import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

Row{
    //scanner
    spacing: 10
    Image {
        id: scanner
        width: 24
        height: width
        source: "qrc:/Asserts/icons/barcode-scan.png"
        fillMode: Image.PreserveAspectFit
    }
    //torch
    Image {
        id: torsh
        width: 24
        height: width
        source: "qrc:/Asserts/icons/touch.png"
        fillMode: Image.PreserveAspectFit
    }
    //search
    Image {
        id: search
        width: 24
        height: width
        source: "qrc:/Asserts/icons/search.png"
        fillMode: Image.PreserveAspectFit
    }
}
