import QtQuick 2.15
import QtQuick.Controls
//listmodel drawer
ListModel {
    id:listmodel
    ListElement{name:"Add Item";icon:"qrc:/Asserts/icons/add.png"}
    ListElement{name:"Add Expense";icon:"qrc:/Asserts/icons/minus.png"}
    ListElement{name:"Other Income";icon:"qrc:/Asserts/icons/income.png"}
    ListElement{name:"About App";icon:"qrc:/Asserts/icons/sale.png"}
    ListElement{name:"About Us";icon:"qrc:/Asserts/icons/info.png"}
}
