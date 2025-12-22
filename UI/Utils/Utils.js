function getCurrentDate() {
    const currentDate = new Date();
    const year = currentDate.getFullYear();
    const month = String(currentDate.getMonth() + 1).padStart(2, "0"); // Months are 0-based
    const day = String(currentDate.getDate()).padStart(2, "0");
    return `${year}-${month}-${day}`; // Return the formatted date
}
//conveting a string to Date
function convertToDate(dateString) {
    let parts = dateString.split("-");
    let year = parseInt(parts[0], 10);
    let month = parseInt(parts[1], 10) - 1; // Adjust for zero-based months
    let day = parseInt(parts[2], 10);
    let jsDate = new Date(year, month, day);
    // Formating manually to prevent UTC shift
    let formattedDate = `${jsDate.getFullYear()}-${String(jsDate.getMonth() + 1).padStart(2, "0")}-${String(jsDate.getDate()).padStart(2, "0")}`;
    return formattedDate;
}

//get icon source

function getIconSource() {
    if ( root.mainStakView && root.mainStakView.depth > 1) {
        return "qrc:/Asserts/icons/styled-back.png";
    } else if (mainStakViewLoader.item && mainStakViewLoader.item.objectName === "Stocks") {
        return "qrc:/Asserts/icons/styled-back.png";
    } else if(mainStakViewLoader.item && mainStakViewLoader.item.objectName === "Notification") {
        return "qrc:/Asserts/icons/styled-back.png";
    }
    else {
        return "qrc:/Asserts/icons/icons8-menu-100(1).png";
    }
}

//reseting the feild
function resetField() {
    home.itemPrice = 0.0
    home.quantity = 0
    home.paymentField.text = ""
}
//a function to append data to a model
function appendToModel(model, name, price, quantity) {
    console.log("Appending to model:", { name, price, quantity });
    if (model && typeof model.append === "function") {
        model.append({ name: name, price: price, quantity: quantity });
    } else {
        console.error("Invalid model or append method missing.");
    }
}

