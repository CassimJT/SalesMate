#ifndef SERVICEMODEL_H
#define SERVICEMODEL_H

#include <QAbstractListModel>
#include <QHash>
#include <QVector>
#include "service.h"


class ServiceModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(qreal totalService READ totalService  NOTIFY totalServiceChanged FINAL)
    enum nameRoles {
        skuRole = Qt::UserRole + 1,
        sourceRole,
        dateRole,
        servicePriceRole,
        descriptionRole
    };

public:
    explicit ServiceModel(QObject *parent = nullptr);
    ~ServiceModel();

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    qreal totalService() const;
    qreal getServiceTotal(const qreal& servicePrice, const qreal& itemeServicePrice, const qreal& newTatal) const;
    qreal getItemServiceTotal(const qreal& servicePrice, const qreal& itemeServicePrice,const qreal& newtotal) const;
    int getItemServiceQuanity(const qreal& itePrice, const qreal& itemServiceQuantity) const;
public slots:
    //
    void addService(const QString &sku, const QDate &date,
                    const QString &name, const qreal & serviceprice,
                    const qreal &itemeprice, const QString &description,
                    const qreal &total
                    );
signals:
    void totalServiceChanged();
private:
    QVector<QSharedPointer<Service>> services;
    QHash<int,QByteArray> roleNames() const override;
    void updateView();

};

#endif // SERVICEMODEL_H
