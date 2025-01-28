function getCurrentDate() {
    const currentDate = new Date();
    const year = currentDate.getFullYear();
    const month = String(currentDate.getMonth() + 1).padStart(2, "0"); // Months are 0-based
    const day = String(currentDate.getDate()).padStart(2, "0");
    return `${year}-${month}-${day}`; // Return the formatted date
}

//get icon source

function getIconSource() {
    if (root.mainStakView.depth > 1) {
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
    homePage.itemPrice = 0.0
    homePage.quantity = 0
    paymentField.text = ""
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

