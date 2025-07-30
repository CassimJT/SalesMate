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
    //deleteEntireDatabase();

    /**updating the View**/
    updateView();
    proxyModel->setSourceModel(this);
    proxyModel->setFilterRole(name);
    proxyModel->setDynamicSortFilter(true);
    proxyModel->invalidate();
    QString sku = "8901238910036";
    quaryQuantitySold(sku);

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
        case 4:
            return QStringLiteral("quantitySold");
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
    case quantitysold:
        return product.quantitySold();
    case cp:
        return product.cp(); //cp = item cost price
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
void DatabaseManager::addProduct(const QString &name, const QString &sku, int quantity, int quantitysold, qreal price, qreal cp, const QDate &date)
{
    auto product = QSharedPointer<Product>::create(this);
    product->setName(name);
    product->setSku(sku);
    product->setQuantity(quantity);
    product->setQuantitySold(quantitysold);
    product->setPrice(price);
    product->setCp(cp);
    product->setDate(date);
    QString formattedDate = date.toString(Qt::ISODate); //formating Date

    QSqlQuery query;
    query.prepare(R"(
        INSERT INTO products (name, sku, quantity, quantitysold, price,cp, date)
        VALUES (:name, :sku, :quantity, :quantitysold, :price, :cp, :date)
    )");
    query.bindValue(":name", name);
    query.bindValue(":sku", sku);
    query.bindValue(":quantity", quantity);
    query.bindValue(":quantitysold", quantitysold);
    query.bindValue(":price", price);
    query.bindValue(":date", formattedDate);
    query.bindValue(":cp",cp);
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
void DatabaseManager::updateProduct(const QString &name, const QString &sku, int quantity, qreal price, qreal cp)
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
        qAbs(product->price() - price) < 1e-6 &&
        qAbs(product->cp() - cp) < 1e-6) {
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
        SET name = :name, quantity = :quantity, price = :price, cp = :cp
        WHERE sku = :sku)");
    query.bindValue(":name", name);
    query.bindValue(":quantity", newQunatity);
    query.bindValue(":price", price);
    query.bindValue(":cp",cp);//cp = itemcostPrice
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
        QString source = map["name"].toString();

        qDebug() << "Processing SKU:" << sku << "Sold Quantity:" << soldQuantity;

        // Use existing query methods
        int currentQuantity = quaryQuantity(sku);
        int currentQuantitySold = quaryQuantitySold(sku);

        if (currentQuantity == -1 || currentQuantitySold == -1) {
            qDebug() << "SKU not found in database:" << sku;
            success = false;
            continue;
        }

        // Validate stock availability
        int newQuantity = currentQuantity - soldQuantity;
        if (newQuantity < 0) {
            qDebug() << "Insufficient stock for SKU:" << sku;
            success = false;
            continue;
        }

        // Calculate new quantity sold
        int newQuantitySold = currentQuantitySold + soldQuantity;

        // Update both quantity and quantitysold in one query
        QSqlQuery updateQuery;
        updateQuery.prepare("UPDATE products SET quantity = :quantity, quantitysold = :quantitysold WHERE sku = :sku");
        updateQuery.bindValue(":quantity", newQuantity);
        updateQuery.bindValue(":quantitysold", newQuantitySold);
        updateQuery.bindValue(":sku", sku);

        if (!updateQuery.exec()) {
            qDebug() << "Database update error:" << updateQuery.lastError().text();
            success = false;
            continue;
        }

        qDebug() << "Updated SKU:" << sku
                 << "New Quantity:" << newQuantity
                 << "New Quantity Sold:" << newQuantitySold;

        // Handle netincome updates
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
            // Update existing netincome entry
            QSqlQuery updateIncomeQuery;
            updateIncomeQuery.prepare("UPDATE netincome SET quantity = quantity + :quantity, "
                                      "totalprice = totalprice + :totalprice WHERE id = :id");
            updateIncomeQuery.bindValue(":quantity", soldQuantity);
            updateIncomeQuery.bindValue(":totalprice", totalPrice);
            updateIncomeQuery.bindValue(":id", checkQuery.value("id").toInt());

            if (!updateIncomeQuery.exec()) {
                qDebug() << "Failed to update netincome:" << updateIncomeQuery.lastError().text();
                success = false;
            }
        } else {
            // Insert new netincome entry
            QDate _date = QDate::fromString(date, "yyyy-MM-dd");
            incomeModel->addIncome(sku, _date, soldQuantity, unitPrice, totalPrice, description, source, cogs);
        }
    }

    // Finalize transaction
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
    roles[cp] = "cp";
    roles[date] = "date"  ;
    roles[quantitysold] = "quantitysold";
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

    QString createTable = R"(
        CREATE TABLE IF NOT EXISTS products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            sku TEXT UNIQUE NOT NULL,
            quantity INTEGER NOT NULL,
            quantitysold INTEGER NOT NULL,
            price REAL NOT NULL,
            cp REAL NOT NULL,
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

   QSqlQuery query("SELECT name, sku, quantity, quantitysold, price,cp, date FROM products");
    while (query.next()) {
        auto product = QSharedPointer<Product>::create(this);
        product->setName(query.value("name").toString());    // name
        product->setSku(query.value("sku").toString());      // sku
        product->setQuantity(query.value("quantity").toInt()); // quantity
        product->setQuantitySold(query.value("quantitysold").toInt()); // quantitysold
        product->setPrice(query.value("price").toFloat());   // price
        product->setCp(query.value("cp").toFloat()); //cp  = cost price
        product->setDate(query.value("date").toDate());      // date
        products.append(product);
        productMap.insert(product->sku(), product);
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
 * @brief DatabaseManager::quaryQuantitySold
 * @param sku
 * @return current quatitysold
 */
int DatabaseManager::quaryQuantitySold(const QString &sku) {
    int curentQuantitySold = -1;
    QSqlQuery query;
    query.prepare("SELECT quantitysold FROM products WHERE sku = :sku");
    query.bindValue(":sku", sku);

    if (query.exec()) {
        if (query.next()) {
            curentQuantitySold = query.value("quantitysold").toInt();
            qDebug() << "[DEBUG] QuantitySold for SKU" << sku << "=" << curentQuantitySold; // <-- NEW
        } else {
            qDebug() << "[DEBUG] SKU not found:" << sku; // <-- NEW
        }
    } else {
        qDebug() << "Database error:" << query.lastError().text();
    }
    return curentQuantitySold;
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
        qDebug() << "Products Table Droped ";
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
    if (db.isOpen()) {
        db.close();
    }

    // Get database file path
    QString dbFile = db.databaseName();

    QSqlDatabase::removeDatabase(db.connectionName());

    QFile file(dbFile);
    if (file.remove()) {
        qDebug() << "Database file deleted:" << dbFile;
    } else {
        qCritical() << "Failed to delete database:" << file.errorString();
    }

    // Reinitialize connection to empty database
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dbFile);
    if (!db.open()) {
        qCritical() << "Failed to recreate database";
    }
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
 * @brief Returns the sum of all product quantities in stock.
 * @return Total quantity (sum of 'quantity' column)
 */
int DatabaseManager::totalQuantity() {
    QSqlQuery query;
    if (query.exec("SELECT SUM(quantity) FROM products")) {
        if (query.next()) {
            return query.value(0).toInt(); // Returns 0 if table is empty
        }
    } else {
        qDebug() << "Failed to calculate total quantity:" << query.lastError().text();
    }
    return 0; // Fallback
}
/**
 * @brief Returns the sum of all products sold (quantitysold column).
 * @return Total quantity sold (sum of 'quantitysold' column)
 */
int DatabaseManager::totalQuantitySold() {
    QSqlQuery query;
    if (query.exec("SELECT SUM(quantitysold) FROM products")) {
        if (query.next()) {
            return query.value(0).toInt(); // Returns 0 if table is empty
        }
    } else {
        qDebug() << "Failed to calculate total quantity sold:" << query.lastError().text();
    }
    return 0; // Fallback
}

qreal DatabaseManager::totalSoldValue() {
    QSqlQuery query;
    if (query.exec("SELECT SUM(price * quantitysold) FROM products")) {
        if (query.next()) {
            return query.value(0).toDouble();
        }
    } else {
        qDebug() << "Failed to calculate total sold value:" << query.lastError().text();
    }
    return 0.0;
}
/**
 * @brief DatabaseManager::totalCostPrice
 * @return the total cost for all product
 */
qreal DatabaseManager::totalCostPrice()
{
    QSqlQuery query;
    if (query.exec("SELECT SUM( cp * (quantity +quantitysold )) FROM products")) {
        if (query.next()) {
            return query.value(0).toDouble();
        }
    } else {
        qDebug() << "Failed to calculate costPrice:" << query.lastError().text();
    }
    return 0.0;
}
/**
 * @brief Calculates the total expected net income (sum of unitprice * quantity for all products).
 * @return Sum of (price × quantity) across all products.
 */
qreal DatabaseManager::expectedNetIncome() {
    QSqlQuery query;
    if (query.exec("SELECT SUM(price * (quantity +quantitysold )) FROM products")) {
        if (query.next()) {
            return query.value(0).toDouble();
        }
    } else {
        qDebug() << "Failed to calculate total expected net income:" << query.lastError().text();
    }
    return 0.0; // Fallback
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

