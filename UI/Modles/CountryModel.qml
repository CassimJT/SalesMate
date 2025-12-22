import QtQuick 2.15
import QtQuick.Controls

ListModel {
    id: countryModel
    ListElement { name: "Malawi";        code: "+265"; flag: "qrc:/Asserts/flags/mw.png" }
    ListElement { name: "Mozambique";    code: "+258"; flag: "qrc:/Asserts/flags/mz.png" }
    ListElement { name: "Tanzania";      code: "+255"; flag: "qrc:/Asserts/flags/tz.png" }
    ListElement { name: "South Africa";  code: "+27";  flag: "qrc:/Asserts/flags/za.png" }
    ListElement { name: "Zambia";        code: "+260"; flag: "qrc:/Asserts/flags/zm.png" }
    ListElement { name: "Zimbabwe";      code: "+263"; flag: "qrc:/Asserts/flags/zw.png" }
}
