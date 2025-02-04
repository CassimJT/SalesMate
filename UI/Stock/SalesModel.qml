pragma Singleton
import QtQuick 2.15
import QtQuick.Controls 2.15

ListModel {
    id: salesModal
    //add item to the model
    function addSale(name, price, quantity,sku) {
        // Prevent adding empty or invalid data
        if (!name || name.trim() === "" || price <= 0 || quantity <= 0) {
            console.log("Invalid data: Cannot add sale with empty or invalid fields.");
            return;
        }

        // Prevent duplicates
        for (var i = 0; i < count; i++) {
            if (get(i).sku === sku) {
                console.log("Duplicate data: Sale with the same name already exists.");
                return;
            }
        }

        // Add the new sale
        append({ name: name, price: price, quantity: quantity,sku:sku });
        console.log("Sale added: ", name, price, quantity,sku);
    }

    // Clear the model
    function clearModel() {
        clear(); // Call the built-in clear method
    }
    //grtting the modelSize
    function modelSize() {
        return count;
    }

    // Function to update an item in the model
    function updateItem(name, quantity, price,sku) {
        for (var i = 0; i < count; i++) {
            if (get(i).sku === sku) {
                // Calculate the new price
                var newPrice = quantity * price;
                set(i, { name: name, quantity: quantity, price: newPrice, sku:sku});
                return;
            }
        }
        console.log("Item with Sku: ", sku, "not found.");
    }

    // Function to decrement the quantity of an item
    function decrementQuantity(index) {
        var currentQuantity = get(index).quantity;
        var itemPrice = get(index).price / currentQuantity
        if (currentQuantity > 1) { // Prevent negative quantities
            var updatedQuantity = currentQuantity - 1;
            var updatedPrice = get(index).price - itemPrice;
            set(index, {
                    quantity: updatedQuantity,
                    price: updatedPrice
                });
        } else {
            //delete it from the model
            deleteSale(index)
        }
        return;
    }
    // Function to increment the quantity of an item
    function incrementQuantity(index) {
        var updatedQuantity = get(index).quantity + 1;
        var updatedPrice = updatedQuantity * get(index).price;
        set(index, {
                quantity: updatedQuantity,
                price: updatedPrice
            });
        return;
    }
    //function to return a return totla prices
    function totalSale() {
        var sum = 0;
        for (var i = 0; i < count; i++) {
            var rowItem = get(i);
            sum += rowItem.price;
        }
        return sum;
    }
    //Deleting an item
    function deleteSale(index) {
        console.log("Deleting item...")
        remove(index)
    }

    //a function to retun the model as array
    function onGoingSale() {
        var sales = [];
        for(var i = 0; i < count; i++) {
            var item = get(i);
            sales.push({sku:item.sku,quantity: item.quantity})
        }
        return sales
    }
}
