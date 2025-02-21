import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import "../Utils"
import "../Utils/Utils.js" as Utils

Page {
    id: addOtherIncomePage
    objectName: "Other Income"

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
                id: sourceLabel
                text: qsTr("Income Source")
                font.pixelSize: 16
            }
            //Service type
            ComboBox {
                id: serviceType
                Layout.fillWidth: true
                popup.width: parent.width * 0.6
                popup.x: width - popup.width
                editable: true
                model: serviceModel
                textRole: "name"
                inputMethodHints: Qt.ImhSensitiveData

                onCurrentIndexChanged: {
                    if (currentIndex >= 0) {
                        code.text = serviceModel.get(currentIndex).sku;
                    }
                }

                onEditTextChanged: {
                    var found = false;
                    for (var i = 0; i < serviceModel.count; i++) {
                        if (serviceModel.get(i).name === editText) {
                            found = true;
                            currentIndex = i;
                            break;
                        }
                    }

                    if (!found) {
                        code.text = "G-0000"; // Default code when no match is found
                        amountField.text = "";
                    }
                    /*
                    // Auto-complete logic
                    if (editText.length === 0) {
                        return; // Avoid filtering on empty input
                    }

                    for (var i = 0; i < serviceModel.count; i++) {
                        var item = serviceModel.get(i).name.toLowerCase();
                        var input = editText.toLowerCase();

                        if (item.startsWith(input)) {
                            if (editText !== serviceModel.get(i).name) {
                                editText = serviceModel.get(i).name; // Auto-complete with first match
                                selectAll(); // Highlight the suggested part
                            }
                            break;
                        }
                    }*/
                }
            }

            // Amount field (auto-filled)
            TextField {
                id: amountField
                placeholderText: "Amount"
                Layout.preferredWidth: parent.width
                inputMethodHints: Qt.ImhDigitsOnly
                readOnly: true
            }

            // Date input
            TextField {
                id: dateField
                placeholderText: "YYYY-MM-DD"
                Layout.fillWidth: true
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                text: Utils.getCurrentDate()

                onTextChanged: {
                    const validDateRegex = /^\d{0,4}(-\d{0,2}(-\d{0,2})?)?$/;
                    if (!validDateRegex.test(text)) {
                        text = text.slice(0, -1);
                    }
                }

                onEditingFinished: {
                    const fullDateRegex = /^\d{4}-\d{2}-\d{2}$/;
                    if (!fullDateRegex.test(text)) {
                        console.log("Invalid date format! Use YYYY-MM-DD.");
                    }
                }
            }

            // Description input
            Text {
                id: characterCounter
                text: "50 characters remaining"
                font.pixelSize: 12
                color: "gray"
            }

            TextArea {
                id: descriptionField
                property int max_length: 50
                placeholderText: "Description (Max: 50 characters)"
                Layout.fillWidth: true
                Layout.preferredHeight: parent.height * 0.3
                wrapMode: TextArea.WordWrap
                font.pixelSize: 14

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

            // SKU Code (auto-filled)
            TextField {
                id: code
                placeholderText: "Sku"
                Layout.preferredWidth: parent.width
                inputMethodHints: Qt.ImhDigitsOnly
                readOnly: true
            }

            // Save button
            CustomButton {
                id: save
                Layout.fillWidth: true
                btnColor: "#4CAF50"
                btnRadius: 5
                btnText: "Save"
                onBtnClicked: {
                    console.log("Clicked")
                }
            }
        }
    }

    ListModel {
        id: serviceModel
        ListElement { name: "Printing"; sku: "p-0001" }
        ListElement { name: "Photocopying";  sku: "p-0002" }
        ListElement { name: "Laminating"; sku: "l-0001" }
        ListElement { name: "Graphics"; sku: "g-0001" }
        ListElement { name: "Binding"; sku: "b-0001" }
        ListElement { name: "Scanning"; sku: "s-0001" }
        ListElement { name: "Faxing"; sku: "f-0001" }
        ListElement { name: "Typing"; sku: "t-0001" }
        ListElement { name: "Photo Printing"; sku: "p-0003" }
        ListElement { name: "ID Photo Printing"; sku: "p-0004" }
        ListElement { name: "T-Shirt Printing"; sku: "p-0005" }
        ListElement { name: "Poster Printing"; sku: "p-0006" }
        ListElement { name: "Business Card Printing"; sku: "p-0007" }
    }
}
