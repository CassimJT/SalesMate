import QtQuick 2.15
import QtQuick.Controls
//listmodel drawer
ListModel {
    id:listmodel
    ListElement{name:"Manage Stock";icon:"qrc:/Asserts/stock/item.svg";pageSource:"../Stock/AddItemPage.qml"}
    ListElement{name:"Add Expense";icon:"qrc:/Asserts/icons/add.png";pageSource:"../Stock/AddExpensePage.qml"}
    ListElement{name:"Services";icon:"qrc:/Asserts/icons/Service.png";pageSource:"../Stock/ServicesPage.qml"}
    ListElement{name:"About Salesmate";icon:"qrc:/Asserts/icons/info.png";pageSource:"../About/AboutSalesmate.qml"}
    ListElement{name:"Satatistics";icon:"qrc:/Asserts/icons/statistics-100.png";pageSource:"../Satatistics/Statistics.qml"}
    ListElement{name:"Settings";icon:"qrc:/Asserts/icons/settings.png";pageSource:"../Settings/SettingsPage.qml"}
}
