import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import "../Utils"
import "../Utils/Utils.js" as Utils
import QtCore

Page {
    id: addOtherIncomePage
    objectName: "Other Income"

    ListModel {
        id: serviceModel
        //default values
        ListElement { name: "Printing"; sku: "p-0001"; servicePrice: "100"; itemPrice: "50" }
        ListElement { name: "Photocopying"; sku: "p-0002"; servicePrice: "50"; itemPrice: "50" }
        ListElement { name: "Laminating"; sku: "l-0001"; servicePrice: "200"; itemPrice: "800" }
        ListElement { name: "Graphics"; sku: "g-0001"; servicePrice: "0"; itemPrice: "0" }
        ListElement { name: "Binding"; sku: "b-0001"; servicePrice: "0"; itemPrice: "800" }
        ListElement { name: "Scanning"; sku: "s-0001"; servicePrice: "400"; itemPrice: "0" }
        ListElement { name: "Typing"; sku: "t-0001"; servicePrice: "400"; itemPrice: "0" }
        ListElement { name: "Photo Printing"; sku: "p-0003"; servicePrice: "0"; itemPrice: "0" }
        ListElement { name: "ID Photo Printing"; sku: "p-0004"; servicePrice: "0"; itemPrice: "0" }
        ListElement { name: "Business Card Printing"; sku: "p-0007"; servicePrice: "0"; itemPrice: "0" }
    }

    Settings {
        id: serviceSetting
    }

    Flickable {
        id: flickable
        width: parent.width
        height: parent.height
        contentHeight: mainLayout.height
        clip: true

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
        }

        ColumnLayout {
            id: mainLayout
            spacing: 10
            width: parent.width * 0.9

            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 10
            }

            Label {
                text: qsTr("Income Source")
                font.pixelSize: 16
            }

            ComboBox {
                id: serviceType
                Layout.fillWidth: true
                editable: true
                model: serviceModel
                textRole: "name"
                inputMethodHints: Qt.ImhSensitiveData

                popup.width: parent.width * 0.6
                popup.x: width - popup.width

                onCurrentIndexChanged: {
                    if (currentIndex >= 0) {
                        code.text = serviceModel.get(currentIndex).sku;
                        serviceprice.text = serviceModel.get(currentIndex).servicePrice
                        itemeprice.text = serviceModel.get(currentIndex).itemPrice
                    }
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignRight
                spacing: 10

                RoundButton {
                    id: edit
                    Layout.preferredWidth: 50
                    Layout.preferredHeight: 50
                    checkable: true

                    Image {
                        anchors.centerIn: parent
                        width: 16
                        height: 16
                        source: edit.checked ? "qrc:/Asserts/icons/Edit-pink.png" : "qrc:/Asserts/icons/Edit.png"
                        fillMode: Image.PreserveAspectFit
                    }
                }

                RoundButton {
                    id: addservice
                    Layout.preferredWidth: 50
                    Layout.preferredHeight: 50
                    visible: edit.checked

                    Image {
                        anchors.centerIn: parent
                        width: 16
                        height: 16
                        source: "qrc:/Asserts/icons/icons8-add-100.png"
                        fillMode: Image.PreserveAspectFit
                    }
                }
            }
            Pane {
                Layout.fillWidth: true
                visible: edit.checked

                ColumnLayout {
                    width: parent.width
                    spacing: 10 // Added spacing for better readability
                    Text {
                        text: qsTr("Edit Prices") // Change this to your preferred text
                        font.pixelSize: 16
                    }

                    TextField {
                        id: serviceprice
                        placeholderText: "Service Price"
                        Layout.fillWidth: true
                        inputMethodHints: Qt.ImhDigitsOnly
                    }

                    TextField {
                        id: itemeprice
                        placeholderText: "Item Price"
                        Layout.fillWidth: true
                        inputMethodHints: Qt.ImhDigitsOnly
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignRight
                        spacing: 10
                        RoundButton {
                            id: deleteservice
                            Layout.preferredWidth: 50
                            Layout.preferredHeight: 50
                            visible: edit.checked

                            Image {
                                anchors.centerIn: parent
                                width: 16
                                height: 16
                                source: "qrc:/Asserts/icons/delete.png"
                                fillMode: Image.PreserveAspectFit
                            }
                        }
                        Button {
                            id: savechanges
                            text: qsTr("Save")
                            //Layout.alignment: Qt.AlignRight // Ensures right alignment
                        }
                    }
                }
            }

            TextField {
                id: amountField
                placeholderText: "Amount"
                Layout.fillWidth: true
                inputMethodHints: Qt.ImhDigitsOnly
                readOnly: true
                visible: !edit.checked
            }

            TextField {
                id: dateField
                placeholderText: "YYYY-MM-DD"
                Layout.fillWidth: true
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                text: Utils.getCurrentDate()
                visible: !edit.checked

                onTextChanged: {
                    const validDateRegex = /^\d{0,4}(-\d{0,2}(-\d{0,2})?)?$/;
                    if (!validDateRegex.test(text)) {
                        text = text.slice(0, -1);
                    }
                }
            }

            Text {
                id: characterCounter
                text: "50 characters remaining"
                font.pixelSize: 12
                color: "gray"
                visible: !edit.checked
            }

            TextArea {
                id: descriptionField
                property int max_length: 50
                placeholderText: "Description (Max: 50 characters)"
                Layout.fillWidth: true
                Layout.preferredHeight: parent.height * 0.15
                wrapMode: TextArea.WordWrap
                font.pixelSize: 14
                visible: !edit.checked

                onTextChanged: {
                    limitCharacters(descriptionField, max_length);
                    characterCounter.text = (max_length - descriptionField.length) + " characters remaining";
                }

                function limitCharacters(textArea, maxLength) {
                    if (textArea.length > maxLength) {
                        var cursorPosition = textArea.cursorPosition;
                        textArea.text = textArea.text.substring(0, maxLength);
                        textArea.cursorPosition = Math.min(cursorPosition, maxLength);
                    }
                }
            }

            TextField {
                id: code
                placeholderText: "SKU"
                Layout.fillWidth: true
                inputMethodHints: Qt.ImhDigitsOnly
                readOnly: true
                visible: !edit.checked
            }

            CustomButton {
                id: save
                Layout.fillWidth: true
                btnColor: "#4CAF50"
                btnRadius: 5
                btnText: "Save"
                visible: !edit.checked

                onBtnClicked: {
                    console.log("Clicked")
                }
            }
        }
    }
}
