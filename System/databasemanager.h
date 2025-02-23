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
#include <QSharedPointer>
#include <QVariant>
#include <QMap>

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
    ~DatabaseManager();

    // Header:
    QVariant headerData(int section,
                        Qt::Orientation orientation,
                        int role = Qt::DisplayRole) const override;

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    ProductFilterProxyModel *getProxyModel() const;

    void setUpExpenceTable();
    void setUpIncomeTable();
    void setUpServiceTable();

public slots:
    //
    Product *queryDatabase(const QString &sku);
    float queryPriceFromDatabase(const QString &sku);
    void addProductToDatabase(const QString &name, const QString &sku, int quantity, float price);
    void updateProduct(const QString &name, const QString &sku, int quantity, float price);
    void removeProduct(const QString &sku);
    void processSales(const QVariantList &sales);
signals:
    void newProductAdded();
    void productUpdated();
    void productRemoved();
    void productExists();
    void productAlreadyExist();//for updating

private:
    QVector<QSharedPointer<Product>> products;
    QHash<int,QByteArray> roleNames() const override;
    QHash<QString, QSharedPointer<Product>> productMap;
    void setUpDatabase();
    void updateView();
    ProductFilterProxyModel *proxyModel;
    int quaryQuantity(const QString &sku);

};

#endif // DATABASEMANAGER_H
