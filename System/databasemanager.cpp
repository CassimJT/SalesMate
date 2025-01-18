#include "databasemanager.h"
#include "System/product.h"
#include <qlogging.h>
#include <qsqldatabase.h>
#include <qsqlerror.h>
#include <qsqlquery.h>
#include <qtmetamacros.h>

DatabaseManager::DatabaseManager(QObject *parent)
    : QAbstractListModel(parent)
{
    //Setting up the Database
    setUpDatabase();
    //updating the View
    updateView();

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
    case itemname:
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
 * @brief DatabaseManager::queryDatabase
 * @param sku
 */
void DatabaseManager::queryDatabase(const QString &sku)
{
    //
}
/**
 * @brief DatabaseManager::queryPriceFromDatabase
 * @param sku
 * @return the price attached to the sku
 */
float DatabaseManager::queryPriceFromDatabase(const QString &sku)
{
    //
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

QHash<int, QByteArray> DatabaseManager::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[itemname] = "name";      // Matches model.name in QML
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
void DatabaseManager::updateView()
{
    QSqlQuery query;
    if (!query.exec("SELECT name, sku, quantity, price FROM products")) {
        qDebug() << "Failed to query products:" << query.lastError().text();
        return;
    }
    beginResetModel(); // Reset the model before updating the list
    qDeleteAll(products); // Clean up any existing items in the list
    products.clear();

    while (query.next()) {
        auto product = new Product(this);
        product->setName(query.value("name").toString());
        product->setSku(query.value("sku").toString());
        product->setQuantity(query.value("quantity").toInt());
        product->setPrice(query.value("price").toFloat());
        products.append(product);
    }
    endResetModel(); // Notify the model that data has been updated
    qDebug() << "View updated with products from database.";
}
