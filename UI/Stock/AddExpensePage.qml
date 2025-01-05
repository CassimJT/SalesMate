import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import "../Utils"

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
            ComboBox {
                id: source
                Layout.fillWidth: true
                model: ["Transport","Electricity","Rent","City","Other"]
            }

            //Other Sources
            TextField {
                id: other
                placeholderText: "Other(Please Spesify)"
                visible: source.currentText === "Other"
                Layout.fillWidth: true
            }

            //Amount
            TextField {
                id: amountField
                placeholderText: "Amount"
                Layout.fillWidth: true
                inputMethodHints: Qt.ImhDigitsOnly
            }


            TextField {
                id: dateField
                placeholderText: "YYYY-MM-DD"
                Layout.fillWidth: true

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
            //textline for discription
            TextArea {
                id: descriptionField
                placeholderText: "Description (Max: 150 characters)"
                Layout.fillWidth: true
                Layout.preferredHeight: parent.height * 0.4
                wrapMode: TextArea.WordWrap
                font.pixelSize: 14
            }
            CustomButton {
                id: save
                Layout.fillWidth: true
                btnColor: "#4CAF50"
                btnRadius: 5
                // btnIconSrc: "qrc:/Asserts/icons/cart.png"
                btnText: "Save"
                onBtnClicked: {
                    console.log("Clicked")
                }
            }

        }

    }
}
