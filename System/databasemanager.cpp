#include "databasemanager.h"
#include "System/product.h"
#include <qlogging.h>
#include <qpropertyprivate.h>
#include <qsqldatabase.h>
#include <qsqlerror.h>
#include <qsqlquery.h>
#include <qtmetamacros.h>

DatabaseManager::DatabaseManager(QObject *parent)
    : QAbstractListModel(parent),
    proxyModel(new ProductFilterProxyModel(this))

{
    //Setting up the Database
    setUpDatabase();
    //updating the View
    updateView();
    proxyModel->setSourceModel(this);
    proxyModel->setFilterRole(name);
    proxyModel->setDynamicSortFilter(true);
    proxyModel->invalidate();

}

QVariant DatabaseManager::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (orientation == Qt::Horizontal && role == Qt::DisplayRole) {
        switch (section) {
        case 0:
            return QStringLiteral("Name");
        case 1:
            return QStringLiteral("SKU");
        case 2:
            return QStringLiteral("Quantity");
        case 3:
            return QStringLiteral("Price");
        default:
            return QVariant();
        }
    }
    return QVariant();
}

int DatabaseManager::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return products.size();
}

QVariant DatabaseManager::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= products.size())
        return QVariant();

    const Product &product = *products.at(index.row());

    switch (role) {
    case name:
        return product.name();
    case sku:
        return product.sku();
    case quantity:
        return product.quantity();
    case price:
        return product.price();
    default:
        return QVariant();
    }
}

/**
 * @brief DatabaseManager::queryPriceFromDatabase
 * @param sku
 * @return the price attached to the sku
 */
float DatabaseManager::queryPriceFromDatabase(const QString &sku)
{
    //
    QSqlQuery query;
    query.prepare("SELECT price FROM products WHERE sku = :sku");
    query.bindValue(":sku", sku);

    if (!query.exec()) {
        qDebug() << "Failed to query price from database:" << query.lastError().text();
        return -1.0f; // Indicate failure with a negative value
    }

    if (query.next()) {
        return query.value(0).toFloat();
    }

    qDebug() << "No product found with SKU:" << sku;
    return -1.0f; // Indicate no matching product found
}
/**
 * @brief DatabaseManager::addStock
 * @param product
 */
void DatabaseManager::addProductToDatabase(const QString &name, const QString &sku, int quantity, float price)
{
    auto product = new Product(this);
    product->setName(name);
    product->setSku(sku);
    product->setQuantity(quantity);
    product->setPrice(price);

    QSqlQuery query;
    query.prepare(R"(
        INSERT INTO products (name, sku, quantity, price)
        VALUES (:name, :sku, :quantity, :price)
    )");
    query.bindValue(":name", name);
    query.bindValue(":sku", sku);
    query.bindValue(":quantity", quantity);
    query.bindValue(":price", price);

    if (!query.exec()) {
        QSqlError error = query.lastError();
        qDebug() << "Failed to add product to database:" << error.text();
        qDebug() << "Database error text:" << error.databaseText();
        if (error.databaseText().contains("UNIQUE", Qt::CaseInsensitive)) {
            qDebug() << "UNIQUE constraint violation detected.";
            emit productExists();
        }
        return;
    }
    emit newProductAdded();
    qDebug() << "Product added to database successfully:" << name;
    // Update the model
    beginInsertRows(QModelIndex(), products.size(), products.size());
    products.append(product);
    productMap.insert(sku, QSharedPointer<Product>::create(product));
    endInsertRows();
}
/**
 * @brief DatabaseManager::appdateUproduct
 * @param name
 * @param sku
 * @param quantity
 * @param price
* This function will update the existing data in the database
 */
void DatabaseManager::updateUproduct(const QString &name, const QString &sku, int quantity, float price)
{
    if (!productMap.contains(sku)) {
        qDebug() << "Product with SKU" << sku << "not found.";
        return;
    }

    QSharedPointer<Product> product = productMap[sku];

    qDebug() << "Existing Data: Name =" << product->name()
             << ", Quantity =" << product->quantity()
             << ", Price =" << product->price();
    qDebug() << "New Data: Name =" << name
             << ", Quantity =" << quantity
             << ", Price =" << price;

    if (product->name().trimmed() == name.trimmed() &&
        product->quantity() == quantity &&
        qAbs(product->price() - price) < 1e-6) {
        qDebug() << "No update needed. The provided data is identical to the existing product data.";
        emit productAlreadyExist();
        return;
    }

    qDebug() << "Updating product in database for SKU:" << sku;

    QSqlQuery query;
    query.prepare(R"(UPDATE products
        SET name = :name, quantity = :quantity, price = :price
        WHERE sku = :sku)");
    query.bindValue(":name", name);
    query.bindValue(":quantity", quantity);
    query.bindValue(":price", price);
    query.bindValue(":sku", sku);

    if (!query.exec()) {
        qDebug() << "Failed to update product in the database:" << query.lastError().text();
        return;
    }else {
        //lettign the world for the new change
        emit productUpdated();
        //updating the view to reflect the change
        updateView();
    }

}



/**
 * @brief DatabaseManager::removeProduct
 * @param sku
 * this function delete the product by sku
 */
void DatabaseManager::removeProduct(const QString &sku)
{
    QSqlQuery query;
    query.prepare("DELETE FROM products WHERE sku = :sku");
    query.bindValue(":sku", sku);

    if (!query.exec()) {
        qDebug() << "Failed to remove product from database:" << query.lastError().text();
        return;
    } else {
        updateView();
        emit productRemoved();
    }
    // Remove product from the in-memory list
}

QHash<int, QByteArray> DatabaseManager::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[name] = "name";      // Matches model.name in QML
    roles[sku] = "sku";            // Matches model.sku in QML
    roles[quantity] = "quantity";  // Matches model.quantity in QML
    roles[price] = "price";        // Matches model.price in QML
    return roles;
}
/**
 * @brief DatabaseManager::setUpDatabase
 * setting up databas connection
 */
void DatabaseManager::setUpDatabase()
{
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("salesmate.db");

    if(!db.open()) {
        qDebug() << "failed to open the database: " << db.lastError().text();
        return;
    }
    qDebug() << "Database Opened Succefully:";
    QSqlQuery query;

    QString createTable = R"(
        CREATE TABLE IF NOT EXISTS products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            sku TEXT UNIQUE NOT NULL,
            quantity INTEGER NOT NULL,
            price REAL NOT NULL
        )
    )";
    if(!query.exec(createTable)) {
        qDebug() << "Faild to create table: " << db.lastError().text();
        return;
    }
    qDebug() << "Table Created Succefully:";
}
/**
 * @brief DatabaseManager::updateView
 * update the view on start up
 */
/**
 * @brief DatabaseManager::updateView
 * Populate the products list from the database and update the view
 */
void DatabaseManager::updateView() {
    beginResetModel();
    products.clear();

    QSqlQuery query("SELECT name, sku, quantity, price FROM products");
    while (query.next()) {
        auto product = new Product(this);
        product->setName(query.value(0).toString());
        product->setSku(query.value(1).toString());
        product->setQuantity(query.value(2).toInt());
        product->setPrice(query.value(3).toFloat());
        products.append(product);
        productMap.insert(product->sku(), QSharedPointer<Product>(product));
    }

    endResetModel();
}

ProductFilterProxyModel *DatabaseManager::getProxyModel() const
{
    return proxyModel;
}
/**
 * @brief DatabaseManager::queryDatabase
 * @param sku
 * @return produnt
 * this function retunr the produt that matches the sku
 */
Product* DatabaseManager::queryDatabase(const QString &sku)
{
    // Check the hash first
    if (productMap.contains(sku)) {
        qDebug() << "return from map";
        return productMap.value(sku).data(); // Return raw pointer
    }

    // If not in the hash, query the database
    QSqlQuery query;
    query.prepare("SELECT name, quantity, price FROM products WHERE sku = :sku");
    query.bindValue(":sku", sku);

    if (query.exec() && query.next()) {
        auto product = new Product(this); // Use raw pointer
        product->setName(query.value("name").toString());
        product->setSku(sku);
        product->setQuantity(query.value("quantity").toInt());
        product->setPrice(query.value("price").toDouble());
        productMap.insert(sku, QSharedPointer<Product>(product));
        qDebug() << "return from db";
        return product;
    } else {
        qDebug() << "Database error:" << query.lastError().text();
    }

    return nullptr;
}

