#ifndef SERVICEMODEL_H
#define SERVICEMODEL_H

#include <QAbstractListModel>
#include <QHash>
#include <QVector>
#include "service.h"


class ServiceModel : public QAbstractListModel
{
    Q_OBJECT
    enum nameRoles {
        skuRole = Qt::UserRole + 1,
        dateRole,
        nameRole,
        servicePriceRole,
        itemePriceRole,
        descriptionRole
    };

public:
    explicit ServiceModel(QObject *parent = nullptr);
    ~ServiceModel();

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
public slots:
    //
    void addService(const QString &sku, const QDate &date,
                    const QString &name, const qreal & serviceprice,
                    const qreal &itemeprice, const QString &description);

private:
    QVector<QSharedPointer<Service>> services;
    QHash<int,QByteArray> roleNames() const override;

};

#endif // SERVICEMODEL_H
