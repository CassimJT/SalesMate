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
void DatabaseManager::appdateUproduct(const QString &name, const QString &sku, int quantity, float price)
{
    QSqlQuery quary;
    quary.prepare(R"(UPDATE products
        SET name = :name, quantity = :quantity, price = :price
        WHERE sku = :sku)");
    quary.bindValue(":name",name);
    quary.bindValue(":quantity", quantity);
    quary.bindValue(":price",price);
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
    }

    // Remove product from the in-memory list
    for (int i = 0; i < products.size(); ++i) {
        if (products.at(i)->sku() == sku) {
            beginRemoveRows(QModelIndex(), i, i);
            delete products.takeAt(i); // Remove and delete the product
            endRemoveRows();
            qDebug() << "Product removed successfully:" << sku;
            return;
        }
    }

    qDebug() << "Product not found in memory for SKU:" << sku;

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
 * @return product
 * return the produnt the matches the sku from the database
 */
Product DatabaseManager::queryDatabase(const QString &sku)
{

}

