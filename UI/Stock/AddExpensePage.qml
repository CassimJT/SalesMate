import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import "../Utils"
import "../Utils/Utils.js" as Utils

Page {
    id: addExpensesPage
    objectName:"Add Expenses"
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
                id: sourceLable
                text: qsTr("Expence Source")
                font.pixelSize: 16
            }
            //source
            DirectionalText{
                id: sourceDirection
                visible: source.currentIndex === -1
                directionalText: "Source cannot be empty"
            }

            ComboBox {
                id: source
                Layout.fillWidth: true
                currentIndex: -1
                popup.width: parent.width / 2
                model: ["Transport", "Electricity", "Rent", "City", "Groceries", "Internet", "Phone", "Insurance", "Other"]
            }
            //Other Sources
            DirectionalText{
                id: otherDirection
                visible: other.text === "" &&  source.currentText === "Other"
                directionalText: "Other sources cannot be empty"
            }
            TextField {
                id: other
                placeholderText: "Other(Please Spesify)"
                visible: source.currentText === "Other"
                Layout.fillWidth: true
            }

            //Amount
            DirectionalText{
                id: amountDirection
                visible: amountField.text === ""
                directionalText : "Amount cannot be empty"
            }
            TextField {
                id: amountField
                placeholderText: "Amount"
                Layout.fillWidth: true
                inputMethodHints: Qt.ImhDigitsOnly
            }

            DirectionalText{
                id: dateDirection
                visible: dateField.text === ""
                directionalText: "Date cannot be empty"
            }
            TextField {
                id: dateField
                placeholderText: "YYYY-MM-DD"
                Layout.fillWidth: true
                text: Utils.getCurrentDate();
                // Limit input to numbers and dashes
                inputMethodHints: Qt.ImhFormattedNumbersOnly

                // Validate and enforce date format
                onTextChanged: {
                    const validDateRegex = /^\d{0,4}(-\d{0,2}(-\d{0,2})?)?$/;
                    if (!validDateRegex.test(text)) {
                        text = text.slice(0, -1); // Remove invalid character
                    }
                }

                // Optional: Provide feedback for valid/invalid dates
                onEditingFinished: {
                    const fullDateRegex = /^\d{4}-\d{2}-\d{2}$/;
                    if (!fullDateRegex.test(text)) {
                        console.log("Invalid date format! Use YYYY-MM-DD.");
                    } else {
                        console.log("Valid date entered:", text);
                    }
                }
            }
            Text {
                id: characterCounter
                text: "50 characters remaining"
                font.pixelSize: 12
                color: "gray"
            }
            DirectionalText{
                id: descriptionDirection
                visible: false
            }
            TextArea {
                id: descriptionField
                placeholderText: "Description"
                property int max_length: 50
                Layout.fillWidth: true
                Layout.preferredHeight: parent.height * 0.25
                Layout.preferredWidth: parent.width
                wrapMode: TextArea.Wrap
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
            CustomButton {
                id: save
                Layout.fillWidth: true
                btnColor: "#4CAF50"
                btnRadius: 5
                // btnIconSrc: "qrc:/Asserts/icons/cart.png"
                btnText: "Save"
                onBtnClicked: {
                    const e_source = source.currentText;
                    const other_source = other.text;
                    const cost = amountField.text
                    let date = Utils.convertToDate(dateField.text)
                    const description = descriptionField.text

                    if ( source.currentText === "Other") {
                        if(source.currentIndex !== -1
                                && other.text !== ""
                                && amountField.text !== ""
                                && dateField.text !== ""){
                            console.log("Oky with other")
                            //...
                        }
                    }else {
                        if(source.currentIndex !== -1
                                && amountField.text !== ""
                                && dateField.text !== ""){
                            console.log("Oky with no other")
                            //...
                        }
                    }
                }
            }
        }
    }
    //information: success
    InfoPopup {
        id: successPopup
        iconSource: "qrc:/Asserts/icons/success.gif"
        message: qsTr("Stock added successfully")
        buttonText: qsTr("Okay")
        onClicked: {
            reset();
            successPopup.close();
        }
    }
    //information: error
    InfoPopup {
        id:error
        iconSource: "qrc:/Asserts/icons/icons8-error.gif"
        message: qsTr("Product Already Exist")
        buttonText: qsTr("Okay")
        onClicked: {
            reset();
            error.close();
        }
    }

    function reset(){
        source.currentIndex = -1
        other.text = ""
        amountField.text = ""
        descriptionField.text = ""
    }

    Connections {
        target: expenseModel
        onExpenseAdded: {
            //...
        }
        onExpenseExist: {
            //...
        }
    }
}
