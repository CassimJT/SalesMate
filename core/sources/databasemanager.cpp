#include "databasemanager.h"
#include "core/sources/product.h"
#include <qcontainerfwd.h>
#include <qlogging.h>
#include <qpropertyprivate.h>
#include <qsqldatabase.h>
#include <qsqlerror.h>
#include <qsqlquery.h>
#include <qtmetamacros.h>
#include "incomemodel.h"
#include "servicemodel.h"

DatabaseManager *DatabaseManager::_instance = nullptr;

DatabaseManager::DatabaseManager(QObject *parent)
    : QAbstractListModel(parent),
    proxyModel(new ProductFilterProxyModel(this)),
    incomeModel(QSharedPointer<IncomeModel>::create(this)),
    serviceModel(QSharedPointer<ServiceModel>::create(this))

{
    /**Setting up the Database**/
    setUpDatabase();
    setUpExpenceTable();
    setUpIncomeTable();
    setUpServiceTable();
    //deleteTables();

    /**updating the View**/
    updateView();
    proxyModel->setSourceModel(this);
    proxyModel->setFilterRole(name);
    proxyModel->setDynamicSortFilter(true);
    proxyModel->invalidate();

}

DatabaseManager::~DatabaseManager()
{
    qDebug() << "Closing database connection...";

    // Get database connection name
    QString connectionName = QSqlDatabase::database().connectionName();

    // Close the database connection
    QSqlDatabase::database().close();

    // Remove the connection from the database pool
    QSqlDatabase::removeDatabase(connectionName);

    // Clear dynamically allocated resources
    products.clear();
    productMap.clear();
    qDebug() << "Database connection closed.";
}
/**
 * @brief DatabaseManager::instance
 * @return the single instace of the class where ever is called
 */
DatabaseManager *DatabaseManager::instance()
{
    if(_instance == nullptr) {
        _instance = new DatabaseManager();
    }
    return _instance;
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

    return products.count();
}

QVariant DatabaseManager::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= products.size()) {
        return QVariant();
    }

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
    case date:
        return product.date();
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
void DatabaseManager::addProduct(const QString &name, const QString &sku, int quantity, qreal price, const QDate &date)
{
    auto product = QSharedPointer<Product>::create(this);
    product->setName(name);
    product->setSku(sku);
    product->setQuantity(quantity);
    product->setPrice(price);
    product->setDate(date);
    QString formattedDate = date.toString(Qt::ISODate); //formating Date

    QSqlQuery query;
    query.prepare(R"(
        INSERT INTO products (name, sku, quantity, price, date)
        VALUES (:name, :sku, :quantity, :price, :date)
    )");
    query.bindValue(":name", name);
    query.bindValue(":sku", sku);
    query.bindValue(":quantity", quantity);
    query.bindValue(":price", price);
    query.bindValue(":date", formattedDate);
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
    productMap.insert(sku, product);
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
void DatabaseManager::updateProduct(const QString &name, const QString &sku, int quantity, qreal price)
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
    // checking if no update where made
    if (product->name().trimmed() == name.trimmed() &&
        product->quantity() == quantity &&
        qAbs(product->price() - price) < 1e-6) {
        qDebug() << "No update needed. The provided data is identical to the existing product data.";
        emit productAlreadyExist();
        return;
    }

    qDebug() << "Updating product in database for SKU:" << sku;
    int currentQuantity = quaryQuantity(sku); //gating the current qunatity
    int newQunatity  = 0;
    if(currentQuantity != -1) {
        //checking if the current quanity is valide
        newQunatity = currentQuantity + quantity; //calcualting new quantity
    }

    QSqlQuery query;
    query.prepare(R"(UPDATE products
        SET name = :name, quantity = :quantity, price = :price
        WHERE sku = :sku)");
    query.bindValue(":name", name);
    query.bindValue(":quantity", newQunatity);
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
/**
 * @brief DatabaseManager::processSales
 * @param sales
 *  process the sales made
 */
void DatabaseManager::processSales(const QVariantList &sales)
{
    QSqlDatabase db = QSqlDatabase::database();

    if (!db.transaction()) {
        qDebug() << "Failed to start transaction:" << db.lastError().text();
        return;
    }

    bool success = true;

    for (const QVariant &data : sales) {
        QVariantMap map = data.toMap();
        QString sku = map["sku"].toString();
        QString date = map["date"].toString();
        int soldQuantity = map["quantity"].toInt();
        double unitPrice = map["unitprice"].toDouble();
        double totalPrice = map["totalprice"].toDouble();
        QString description = map["description"].toString();
        double cogs = map["cogs"].toDouble();
        QString source = map["name"].toString(); // Assuming source is "Sales"

        qDebug() << "Processing SKU:" << sku << "Sold Quantity:" << soldQuantity;

        // Step 1: Fetch the current quantity
        int currentQuantity = quaryQuantity(sku);
        if (currentQuantity == -1) {
            qDebug() << "SKU not found in database:" << sku;
            success = false;
            continue;
        }

        // Step 2: Validate stock availability
        int newQuantity = currentQuantity - soldQuantity;
        if (newQuantity < 0) {
            qDebug() << "Insufficient stock for SKU:" << sku;
            success = false;
            continue;
        }

        // Step 3: Update the products table
        QSqlQuery updateQuery;
        updateQuery.prepare("UPDATE products SET quantity = :newQuantity WHERE sku = :sku");
        updateQuery.bindValue(":newQuantity", newQuantity);
        updateQuery.bindValue(":sku", sku);

        if (!updateQuery.exec()) {
            qDebug() << "Database update error:" << updateQuery.lastError().text();
            success = false;
            continue;
        }

        qDebug() << "Updated SKU:" << sku << "New Quantity:" << newQuantity;


        // Step 4: Check if an entry exists in netincome
        QSqlQuery checkQuery;
        checkQuery.prepare("SELECT id, quantity, totalprice FROM netincome WHERE sku = :sku AND date = :date");
        checkQuery.bindValue(":sku", sku);
        checkQuery.bindValue(":date", date);

        if (!checkQuery.exec()) {
            qDebug() << "Database query error (checking netincome):" << checkQuery.lastError().text();
            success = false;
            continue;
        }

        if (checkQuery.next()) {
            // Entry exists, update it
            int existingQuantity = checkQuery.value("quantity").toInt();
            double existingTotalPrice = checkQuery.value("totalprice").toDouble();
            int id = checkQuery.value("id").toInt();

            int updatedQuantity = existingQuantity + soldQuantity;
            double updatedTotalPrice = existingTotalPrice + totalPrice;

            QSqlQuery updateIncomeQuery;
            updateIncomeQuery.prepare("UPDATE netincome SET quantity = :quantity, totalprice = :totalprice WHERE id = :id");
            updateIncomeQuery.bindValue(":quantity", updatedQuantity);
            updateIncomeQuery.bindValue(":totalprice", updatedTotalPrice);
            updateIncomeQuery.bindValue(":id", id);

            if (!updateIncomeQuery.exec()) {
                qDebug() << "Failed to update netincome:" << updateIncomeQuery.lastError().text();
                success = false;
                continue;
            }

            qDebug() << "Updated netincome for SKU:" << sku << "on date:" << date;

        } else {
            // No entry exists, insert a new one
            QDate _date = QDate::fromString(date, "yyyy-MM-dd");
            incomeModel->addIncome(sku, _date, soldQuantity, unitPrice, totalPrice, description, source, cogs);
            qDebug() << "Inserted new netincome entry for SKU:" << sku << "on date:" << date;

        }
    }

    // Commit or rollback transaction
    if (success) {
        if (!db.commit()) {
            qDebug() << "Failed to commit transaction:" << db.lastError().text();
            db.rollback();
        } else {
            qDebug() << "All sales processed successfully!";
            updateView();
            serviceModel->updateView();
            incomeModel->updateView();
            qreal currentTotal = getTotal(sales);
            if(currentTotal != 0) {
                emit salesProcessed(currentTotal);
            }
        }
    } else {
        db.rollback();
        qDebug() << "Transaction rolled back due to errors.";
    }
}


QHash<int, QByteArray> DatabaseManager::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[name] = "name";
    roles[sku] = "sku";
    roles[quantity] = "quantity";
    roles[price] = "price";
    roles[date] = "date"  ;
    return roles;
}
/**
 * @brief DatabaseManager::setUpDatabase
 * setting up databas connection
 */
void DatabaseManager::setUpDatabase()
{
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("salesmate.db");

    if (!db.open()) {
        qDebug() << "Failed to open the database: " << db.lastError().text();
        return;
    }
    qDebug() << "Database Opened Successfully:";

    QSqlQuery query;

    /*if(! query.exec("DROP TABLE IF EXISTS products;")) {
        qDebug() << "Failed to drop table info: " << query.lastError().text();
        return;
    } else {
        qDebug() << "Table Droped ";
    }*/

    QString createTable = R"(
        CREATE TABLE IF NOT EXISTS products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            sku TEXT UNIQUE NOT NULL,
            quantity INTEGER NOT NULL,
            price REAL NOT NULL,
            date TEXT NOT NULL
        )
    )";

    if (!query.exec(createTable)) {
        qDebug() << "Failed to create table: " << db.lastError().text();
        return;
    }
    qDebug() << "Table Created Successfully:";
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

    QSqlQuery query("SELECT name, sku, quantity, price,date FROM products");
    while (query.next()) {
        auto product = QSharedPointer<Product>::create(this);
        product->setName(query.value(0).toString());
        product->setSku(query.value(1).toString());
        product->setQuantity(query.value(2).toInt());
        product->setPrice(query.value(3).toFloat());
        product->setDate(query.value(4).toDate());
        products.append(product);
        productMap.insert(product->sku(), QSharedPointer<Product>(product));
    }

    endResetModel();
    emit totalInventoryChanged(); //notifying qml

}
/**
 * @brief DatabaseManager::quaryQuantity
 * @param sku
 * @return the qunatity of a paticula item specified by the sku
 */
int DatabaseManager::quaryQuantity(const QString &sku)
{
    int curentQuantity = -1;
    QSqlQuery query;
    query.prepare("SELECT quantity FROM products WHERE sku = :sku");
    query.bindValue(":sku", sku);
    if(query.exec() && query.next()) {
        curentQuantity = query.value("quantity").toInt();
    } else {
        qDebug() << "Database error:" << query.lastError().text();
    }

    return curentQuantity;
}
/**
 * @brief DatabaseManager::getTotal
 * @return the total current ongoing sales
 */
qreal DatabaseManager::getTotal(const QVariantList &sales) const
{
    double totalSum = 0;

    for (const QVariant &item : sales) {
        QVariantMap sale = item.toMap();
        if (sale.contains("totalprice")) {
            totalSum += sale["totalprice"].toDouble();
        }
    }

    return totalSum;
}
/**
 * @brief DatabaseManager::deleteTables
 * delete all tables
 */
void DatabaseManager::deleteTables()
{
    QSqlQuery query;
    if(! query.exec("DROP TABLE IF EXISTS products;")) {
        qDebug() << "Failed to drop table info: " << query.lastError().text();
        return;
    } else {
        qDebug() << "Table Droped ";
    }

    if(! query.exec("DROP TABLE IF EXISTS expences;")) {
        qDebug() << "Failed to drop table info: " << query.lastError().text();
        return;
    } else {
        qDebug() << "Table Droped ";
    }

    if(! query.exec("DROP TABLE IF EXISTS netincome;")) {
        qDebug() << "Failed to drop table info: " << query.lastError().text();
        return;
    } else {
        qDebug() << "Table Droped ";
    }

    if(! query.exec("DROP TABLE IF EXISTS service;")) {
        qDebug() << "Failed to drop table info: " << query.lastError().text();
        return;
    } else {
        qDebug() << "service Droped ";
    }

}
/**
 * @brief DatabaseManager::deleteEntireDatabase
 * delete the database
 */
void DatabaseManager::deleteEntireDatabase()
{

}

ProductFilterProxyModel *DatabaseManager::getProxyModel() const
{
    return proxyModel;
}
/**
 * @brief DatabaseManager::setUpExpenceTable
 * this function implement the creation of expence table
 */
void DatabaseManager::setUpExpenceTable()
{
    QSqlDatabase db = QSqlDatabase::database();
    if(!db.open()) {
        qDebug() << "failed to open the database: " << db.lastError().text();
        return;
    }
    qDebug() << "Database Opened Succefully:";
    QSqlQuery query;

    QString createTable = R"(
    CREATE TABLE IF NOT EXISTS expences (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        source TEXT NOT NULL,
        date TEXT NOT NULL,
        cost REAL NOT NULL,
        description TEXT NOT NULL
    )
)";
    if(!query.exec(createTable)) {
        qDebug() << "Faild to create table: " << db.lastError().text();
        return;
    }
    qDebug() << " Expence Table Created Succefully:";

}
/**
 * @brief DatabaseManager::setUpIncomeTable
 * this function set up the netincome table
 */
void DatabaseManager::setUpIncomeTable()
{
    QSqlDatabase db = QSqlDatabase::database();
    if(!db.open()) {
        qDebug() << "failed to open the database: " << db.lastError().text();
        return;
    }
    qDebug() << "Database Opened Succefully:";

    QSqlQuery query;

    QString createTable = R"(
        CREATE TABLE IF NOT EXISTS netincome (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            sku TEXT NOT NULL,
            source TEXT NOT NULL,
            date TEXT  NOT NULL,
            quantity INTEGER NOT NULL,
            unitprice REAL NOT NULL,
            totalprice REAL NOT NULL,
            description TEXT ,
            cogs REAL NOT NULL
        )
    )";
    if(!query.exec(createTable)) {
        qDebug() << "Faild to create table: " << db.lastError().text();
        return;
    }
    qDebug() << " Netincome Table Created Succefully:";

}
/**
 * @brief DatabaseManager::setUpServiceTable
 * this function create the sevice table schema
 */
void DatabaseManager::setUpServiceTable()
{
    QSqlDatabase db = QSqlDatabase::database();
    if(!db.open()) {
        qDebug() << "failed to open the database: " << db.lastError().text();
        return;
    }
    qDebug() << "Database Opened Succefully:";
    QSqlQuery query;

    QString createTable = R"(
        CREATE TABLE IF NOT EXISTS service (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            sku TEXT NOT NULL,
            source TEXT NOT NULL,
            date TEXT  NOT NULL,
            serviceprice REAL NOT NULL,
            description TEXT
        )
    )";
    if(!query.exec(createTable)) {
        qDebug() << "Faild to create table: " << db.lastError().text();
        return;
    }
    qDebug() << " Service Table Created Succefully:";

}
/**
 * @brief DatabaseManager::totalInventory
 * @return the total inventory
 */
qreal DatabaseManager::totalInventory() const
{
    qreal totalInventory = 0.0;
    qreal total_itemprice = 0.0;
    for(const auto &product:products) {
        total_itemprice = (product->price() * product->quantity());
        totalInventory += total_itemprice;
    }
    return totalInventory;
}

QSqlDatabase DatabaseManager::getDatabase() const
{
    return db;
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

