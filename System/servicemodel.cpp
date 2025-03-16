#include "servicemodel.h"
#include <qsqldatabase.h>
#include "databasemanager.h"

ServiceModel::ServiceModel(QObject *parent)
    : QAbstractListModel(parent),
    databaseManager(nullptr)
{

    updateView();
}
/**
 * @brief ServiceModel::~ServiceModel
 */
ServiceModel::~ServiceModel()
{
    //the distractor
   // delete sharedManager;
    services.clear();
}
int ServiceModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    return services.count();
}

QVariant ServiceModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= services.size()){

        return QVariant();
    }
    const Service &service = *services.at(index.row());
    switch (role) {
    case skuRole:
        return service.sku();
    case sourceRole:
        return service.source();
    case dateRole:
        return service.date();
    case servicePriceRole:
        return service.servicePrice();
    case descriptionRole:
        return service.description();

    default:
        return QVariant();
    }
}
/**
 * @brief ServiceModel::totalService
 * @return the total services
 */
qreal ServiceModel::totalService() const
{
    qreal total_service = 0.0;
    //qreal row_sum =  0.0;
    for(const auto &service :services) {
        total_service += service->servicePrice();
    }
    return total_service;

}
/**
 * @brief ServiceModel::getServiceTotal
 * @param servicePrice
 * @param itemeServicePrice
 * @param newTotal
 * @return the total service price from the total
 */
qreal ServiceModel::getServiceTotal(const qreal &servicePrice, const qreal &itemeServicePrice, const qreal &newTotal) const
{
    if (servicePrice < 0 || itemeServicePrice < 0 || newTotal < 0) {
        qWarning() << "Invalid input: Values cannot be negative.";
        return 0.0;
    }

    if (qFuzzyIsNull(servicePrice)) return 0.0;  // If servicePrice is zero, return 0
    if (qFuzzyIsNull(itemeServicePrice)) return servicePrice;  // If itemeServicePrice is zero, return servicePrice

    qreal totalRatio = servicePrice + itemeServicePrice;
    return (servicePrice / totalRatio) * newTotal;
}
/**
 * @brief ServiceModel::getItemServiceTotal
 * @param servicePrice
 * @param itemeServicePrice
 * @param newtotal
 * @return the total item service price from the total
 */
qreal ServiceModel::getItemServiceTotal(const qreal &servicePrice, const qreal &itemeServicePrice, const qreal &newtotal) const
{
    if (servicePrice < 0 || itemeServicePrice < 0 || newtotal < 0) {
        qWarning() << "Invalid input: Values cannot be negative.";
        return 0.0;
    }

    if (qFuzzyIsNull(servicePrice)) return 0.0;  // If servicePrice is zero, return 0
    if (qFuzzyIsNull(itemeServicePrice)) return servicePrice;  // If itemeServicePrice is zero, return servicePrice

    qreal totalRatio = servicePrice + itemeServicePrice;
    return (itemeServicePrice / totalRatio) * newtotal;
}

/**
 * @brief ServiceModel::getItemServiceQuanity
 * @param servicePrice
 * @param itemeServicePrice
 * @param newtotal
 * @return the quantity for the items sold
 */
int ServiceModel::getItemServiceQuanity(const qreal &servicePrice, const qreal &itemeServicePrice, const qreal &newtotal) const
{
    if (servicePrice < 0 || itemeServicePrice < 0 || newtotal < 0) {
        qWarning() << "Invalid input: Values cannot be negative.";
        return 0;
    }

    if (qFuzzyIsNull(servicePrice)) return 0;  // If servicePrice is zero, return 0
    if (qFuzzyIsNull(itemeServicePrice)) return qFloor(newtotal / servicePrice);

    qreal totalRatio = servicePrice + itemeServicePrice;
    return qFloor(newtotal / totalRatio);
}
/**
 * @brief ServiceModel::setDatabaseManager
 * @param db
 */
void ServiceModel::setDatabaseManager(const QSharedPointer<DatabaseManager> &db)
{
    databaseManager = db.toWeakRef();
}

/**
 * @brief ServiceModel::addService
 * @param sku
 * @param date
 * @param name
 * @param serviceprice
 * @param itemeprice
 * @param description
 */
void ServiceModel::addService(const QString &sku, const QDate &date,
                              const QString &name, const qreal &serviceprice,
                              const qreal &itemeprice, const QString &description,
                              const qreal &total)
{
    QString formattedDate = date.toString(Qt::ISODate);

    // **Keep conversion logic from processSale**
    qreal service_total = getServiceTotal(serviceprice, itemeprice, total);
    qreal item_total = getItemServiceTotal(serviceprice, itemeprice, total);
    int item_quantity = getItemServiceQuanity(serviceprice, itemeprice, total);
    qreal cogs = item_total;

    QSqlDatabase db = QSqlDatabase::database();
    if (!db.transaction()) {
        qDebug() << "Failed to start transaction:" << db.lastError().text();
        return;
    }

    // **Check if service exists**
    QSqlQuery checkQuery;
    checkQuery.prepare("SELECT id, serviceprice FROM service WHERE sku = :sku AND date = :date");
    checkQuery.bindValue(":sku", sku);
    checkQuery.bindValue(":date", formattedDate);

    if (!checkQuery.exec()) {
        qDebug() << "Error checking existing entry:" << checkQuery.lastError().text();
        db.rollback();
        return;
    }

    bool entryExists = checkQuery.next();
    int existingId = entryExists ? checkQuery.value("id").toInt() : -1;
    qreal existingServicePrice = entryExists ? checkQuery.value("serviceprice").toDouble() : 0.0;

    // **Instead of replacing, add the new service price**
    qreal newServicePrice = existingServicePrice + service_total;

    if (entryExists) {
        // **Update existing service**
        QSqlQuery updateQuery;
        updateQuery.prepare(R"(
            UPDATE service
            SET serviceprice = :newServicePrice, description = :description
            WHERE id = :id
        )");
        updateQuery.bindValue(":newServicePrice", newServicePrice);
        updateQuery.bindValue(":description", description);
        updateQuery.bindValue(":id", existingId);

        if (!updateQuery.exec()) {
            qDebug() << "Update Failed: " << updateQuery.lastError().text();
            db.rollback();
            return;
        }
    } else {
        // **Insert new service**
        QSqlQuery insertQuery;
        insertQuery.prepare(R"(
            INSERT INTO service (sku, source, date, serviceprice, description)
            VALUES (:sku, :source, :date, :serviceprice, :description)
        )");
        insertQuery.bindValue(":sku", sku);
        insertQuery.bindValue(":source", name);
        insertQuery.bindValue(":date", formattedDate);
        insertQuery.bindValue(":serviceprice", service_total);
        insertQuery.bindValue(":description", description);

        if (!insertQuery.exec()) {
            qDebug() << "Insertion Failed:" << insertQuery.lastError().text();
            db.rollback();
            return;
        }
    }

    // **Commit database changes**
    if (!db.commit()) {
        qDebug() << "Failed to commit transaction:" << db.lastError().text();
        db.rollback();
        return;
    }

    // **Convert data to JSON**
    QJsonObject jsonObject;
    jsonObject["sku"] = sku;
    jsonObject["name"] = name;
    jsonObject["date"] = formattedDate;
    jsonObject["quantity"] = item_quantity;
    jsonObject["unitprice"] = itemeprice;
    jsonObject["totalprice"] = item_total;
    jsonObject["description"] = description;
    jsonObject["cogs"] = cogs;

    QVariantList sales;
    sales.append(jsonObject.toVariantMap());
    /*auto dbManager = DatabaseManager::instance();
    if(dbManager) {
       // dbManager->processSales(sales);
    } else {
        qDebug() <<"dbManagers not exist";
    }
    qDebug() << "Service Sale JSON Data:" << QJsonDocument(jsonObject).toJson(QJsonDocument::Compact);
    //reloading the model
    updateView();*/
    emit totalServiceChanged();
}
/**
 * @brief ServiceModel::roleNames
 * @return
 */
QHash<int, QByteArray> ServiceModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[skuRole] = "Sku";
    roles[sourceRole] = "Date";
    roles[dateRole] = "Name";
    roles[servicePriceRole] = "ServecePrice";
    roles[descriptionRole] = "Description";
    return roles;
}
/**
 * @brief ServiceModel::updateView
 */
void ServiceModel::updateView()
{
    beginResetModel();
    services.clear();

    QSqlQuery query("SELECT id, sku, source, date, serviceprice, description FROM service");
    while (query.next()) {
        auto _services = QSharedPointer<Service>::create();
        _services->setSku(query.value(1).toString());
        _services->setSource(query.value(2).toString());
        _services->setDate(QDate::fromString(query.value(3).toString(), Qt::ISODate));  // ISO format
        _services->setServicePrice(query.value(4).toDouble());
        _services->setDescription(query.value(5).toString());

        services.append(_services);
    }

    endResetModel();

}

