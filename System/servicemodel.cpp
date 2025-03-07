#include "servicemodel.h"
#include <qsqlquery.h>

ServiceModel::ServiceModel(QObject *parent)
    : QAbstractListModel(parent)
{
    //the consractor
    updateView();
}
/**
 * @brief ServiceModel::~ServiceModel
 */
ServiceModel::~ServiceModel()
{
    //the distractor
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
 * @param newTatal
 * @return the total service price from the total price
 */
qreal ServiceModel::getServiceTotal(const qreal &servicePrice, const qreal &itemeServicePrice, const qreal &newTatal) const
{
    //..
}
/**
 * @brief ServiceModel::getItemServiceTotal
 * @param servicePrice
 * @param itemeServicePrice
 * @param newtotal
 * @return the total itemeservice price from the total
 */
qreal ServiceModel::getItemServiceTotal(const qreal &servicePrice, const qreal &itemeServicePrice, const qreal &newtotal) const
{
    //...

}
/**
 * @brief ServiceModel::getItemServiceQuanity
 * @param itePrice
 * @param itemServiceQuantity
 * @return the the quatity for the items sold
 */
int ServiceModel::getItemServiceQuanity(const qreal &itePrice, const qreal &itemServiceQuantity) const
{
    //...

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
    //....

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

    QSqlQuery query("SELECT sku, source, date, serviceprice, description, FROM service");
    while (query.next()) {
        auto _services = QSharedPointer<Service>::create(this);
        _services->setSku(query.value(1).toString());
        _services->setSource(query.value(2).toString());
        _services->setDate(QDate::fromString(query.value(3).toString(), "yyyy-MM-dd"));
        _services->setServicePrice(query.value(4).toReal());
        _services->setDescription(query.value(5).toString());
        services.append(_services);
    }
    endResetModel();
    emit totalServiceChanged();

}
