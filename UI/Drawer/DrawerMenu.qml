import QtQuick 2.15
import QtQuick.Controls
ListView {
    id:listView
    clip:true
    model: DrawerModel{}
    delegate: DrawerDelegate{}
}
