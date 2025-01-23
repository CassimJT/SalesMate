#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QAbstractListModel>
#include <QHash>
#include <QVector>
#include <qcontainerfwd.h>
#include <qobject.h>
#include "product.h"
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include "productfilterproxymodel.h"

class DatabaseManager : public QAbstractListModel
{
    Q_OBJECT
    enum nameRoles{
        name = Qt::UserRole + 1,
        sku,
        quantity,
        price
    };
    Q_PROPERTY(ProductFilterProxyModel* productFilterModel READ getProxyModel CONSTANT)

public:
    explicit DatabaseManager(QObject *parent = nullptr);

    // Header:
    QVariant headerData(int section,
                        Qt::Orientation orientation,
                        int role = Qt::DisplayRole) const override;

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    ProductFilterProxyModel *getProxyModel() const;

public slots:
    //
    void queryDatabase(const QString &sku);
    float queryPriceFromDatabase(const QString &sku);
    void addProductToDatabase(const QString &name, const QString &sku, int quantity, float price);
    void appdateUproduct(const QString &name, const QString &sku, int quantity, float price);
    void removeProduct(const QString &sku);
signals:
    void newProductAdded();
    void productUpdated();
    void productRemoved();
    void productExists();

private:
    Product product;
    QVector<Product*> products;
    QHash<int,QByteArray> roleNames() const override;
    void setUpDatabase();
    void updateView();
    ProductFilterProxyModel *proxyModel;

};

#endif // DATABASEMANAGER_H
