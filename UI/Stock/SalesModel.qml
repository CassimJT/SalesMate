pragma Singleton
import QtQuick 2.15
import QtQuick.Controls 2.15

ListModel {
    id: salesModal
    //add item to the model
<<<<<<< HEAD
    function addSale(name, price, quantity) {
=======
    function addSale(name, price, quantity,sku) {
>>>>>>> origin/main
        // Prevent adding empty or invalid data
        if (!name || name.trim() === "" || price <= 0 || quantity <= 0) {
            console.log("Invalid data: Cannot add sale with empty or invalid fields.");
            return;
        }

        // Prevent duplicates
        for (var i = 0; i < count; i++) {
<<<<<<< HEAD
            if (get(i).name === name) {
=======
            if (get(i).sku === sku) {
>>>>>>> origin/main
                console.log("Duplicate data: Sale with the same name already exists.");
                return;
            }
        }

        // Add the new sale
<<<<<<< HEAD
        append({ name: name, price: price, quantity: quantity });
        console.log("Sale added: ", name, price, quantity);
=======
        append({ name: name, price: price, quantity: quantity,sku:sku });
        console.log("Sale added: ", name, price, quantity,sku);
>>>>>>> origin/main
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
<<<<<<< HEAD
    function updateItem(name, quantity, price) {
        for (var i = 0; i < count; i++) {
            if (get(i).name === name) {
                // Calculate the new price
                var newPrice = quantity * price;
                // Update the item
                set(i, { name: name, quantity: quantity, price: newPrice,});
                return; // Exit after updating the matching item
            }
        }
        console.log("Item with name", name, "not found.");
    }

    // Function to delete an item from the model
    function deleteItem(name) {
        for (var i = 0; i < count; i++) {
            if (get(i).name === name) {
                remove(i); // Remove the item at index `i`
                return; // Exit after deletion
            }
        }
        console.log("Item with name", name, "not found.");
    }

    // Function to decrement the quantity of an item
    function decrementQuantity(name) {
        for (var i = 0; i < count; i++) {
            if (get(i).name === name) {
                var currentQuantity = get(i).quantity;
                if (currentQuantity > 1) { // Prevent negative quantities
                    var updatedQuantity = currentQuantity - 1;
                    var updatedPrice = updatedQuantity * get(i).price;
                    set(i, {
                            sku: sku,
                            quantity: updatedQuantity,
                            price: get(i).price,
                            totalPrice: updatedPrice
                        });
                } else {
                    console.log("Cannot decrement quantity below 1.");
                }
                return;
            }
        }
        console.log("Item with name", name, "not found.");
    }

    // Function to increment the quantity of an item
    function incrementQuantity(name) {
        for (var i = 0; i < count; i++) {
            if (get(i).name === name) {
                var updatedQuantity = get(i).quantity + 1;
                var updatedPrice = updatedQuantity * get(i).price;
                set(i, {
                        name: name,
                        quantity: updatedQuantity,
                        price: get(i).price,
                        totalPrice: updatedPrice
                    });
                return;
            }
        }
        console.log("Item with name", name, "not found.");
    }
    //function to return a return totle prices
=======
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
>>>>>>> origin/main
    function totalSale() {
        var sum = 0;
        for (var i = 0; i < count; i++) {
            var rowItem = get(i);
            sum += rowItem.price;
        }
        return sum;
    }
<<<<<<< HEAD

    //this function return the arry of current mode
    function currentSales() {
        let sales = []
        for(var i = 0; i < count; i++) {
            var item = get(i);
            sales.push({"sku": item.sku, "quantity": item.quantity})
        }
        return sales;
    }

=======
    //Deleting an item
    function deleteSale(index) {
        console.log("Deleting item...")
        remove(index)
    }

    //a function to retun the model as array
>>>>>>> origin/main
}
