#include "servicemodel.h"

ServiceModel::ServiceModel(QObject *parent)
    : QAbstractListModel(parent)
{
    //the consractor
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
    case dateRole:
        return service.date();
    case nameRole:
        return service.source();
    case servicePriceRole:
        return service.servicePrice();
    case itemePriceRole:
        return service.itemprice();
    case descriptionRole:
        return service.description();
    default:
        return QVariant();
    }

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
                              const qreal &itemeprice, const QString &description)
{
    //....

}

QHash<int, QByteArray> ServiceModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[skuRole] = "Sku";
    roles[dateRole] = "Date";
    roles[nameRole] = "Name";
    roles[servicePriceRole] = "ServecePrice";
    roles[itemePriceRole] = "ItemPriceRole";
    roles[descriptionRole] = "Description";
    return roles;
}
