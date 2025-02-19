import QtQuick 2.15
import QtQuick.Controls
//listmodel drawer
ListModel {
    id:listmodel
    ListElement{name:"Add Stock";icon:"qrc:/Asserts/icons/add.png";pageSource:"../Stock/AddItemPage.qml"}
    ListElement{name:"Add Expense";icon:"qrc:/Asserts/icons/minus.png";pageSource:"../Stock/AddExpensePage.qml"}
    ListElement{name:"Other Income";icon:"qrc:/Asserts/icons/income.png";pageSource:"../Stock/OtherIncomePage.qml"}
    ListElement{name:"About App";icon:"qrc:/Asserts/icons/sale.png";pageSource:"../About/AboutAppPage.qml"}
    ListElement{name:"About Us";icon:"qrc:/Asserts/icons/info.png";pageSource:"../About/AboutUsPage.qml"}
    ListElement{name:"Satatistics";icon:"qrc:/Asserts/icons/statistics-100.png";pageSource:"../Satatistics/Statistics.qml"}
}
