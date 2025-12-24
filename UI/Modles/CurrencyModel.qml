import QtQuick 2.15
import QtQuick.Controls
ListModel {
    id: currencyModle
    ListElement { name: "Malawi";        currency: "MWK"; flag: "qrc:/Asserts/flags/mw.png" }
    ListElement { name: "Mozambique";    currency: "MZN"; flag: "qrc:/Asserts/flags/mz.png" }
    ListElement { name: "Tanzania";      currency: "TZ"; flag: "qrc:/Asserts/flags/tz.png" }
    ListElement { name: "South Africa";  currency: "ZAR"; flag: "qrc:/Asserts/flags/za.png" }
    ListElement { name: "Zambia";        currency: "ZMW"; flag: "qrc:/Asserts/flags/zm.png" }
    ListElement { name: "Zimbabwe";      currency: "ZWL"; flag: "qrc:/Asserts/flags/zw.png" }
}
