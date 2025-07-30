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
#include <QFile>
#include <QThread>
class IncomeModel;
class ServiceModel;

class DatabaseManager : public QAbstractListModel
{
    Q_OBJECT
    enum nameRoles{
        name = Qt::UserRole + 1,
        sku,
        quantity,
        price,
        cp,
        date,
        quantitysold
    };
    Q_PROPERTY(ProductFilterProxyModel* productFilterModel READ getProxyModel CONSTANT)
    Q_PROPERTY(qreal totalInventory READ totalInventory NOTIFY totalInventoryChanged)

public:
    explicit DatabaseManager(QObject *parent = nullptr);
    ~DatabaseManager();
    static DatabaseManager *instance();

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
    qreal totalInventory() const;
    QSqlDatabase getDatabase()const;
    Q_INVOKABLE int totalQuantity();
    Q_INVOKABLE int totalQuantitySold();
    Q_INVOKABLE qreal totalSoldValue();
    Q_INVOKABLE qreal totalCostPrice();
    Q_INVOKABLE qreal expectedNetIncome();

public slots:
    //
    Product *queryDatabase(const QString &sku);
    float queryPriceFromDatabase(const QString &sku);
    void addProduct(const QString &name, const QString &sku, int quantity,int quantitysold, qreal price, qreal cp, const QDate &date);
    void updateProduct(const QString &name, const QString &sku, int quantity, qreal price, qreal cp);
    void removeProduct(const QString &sku);
    void processSales(const QVariantList &sales);
signals:
    void newProductAdded();
    void productUpdated();
    void productRemoved();
    void productExists();
    void productAlreadyExist();//for updating
    void totalInventoryChanged();
    void salesProcessed(const qreal &total);

private:
    QVector<QSharedPointer<Product>> products;
    QHash<int,QByteArray> roleNames() const override;
    QHash<QString, QSharedPointer<Product>> productMap;
    void setUpDatabase();
    void updateView();
    ProductFilterProxyModel *proxyModel;
    int quaryQuantity(const QString &sku);
    int quaryQuantitySold(const QString &sku);
    QSharedPointer<IncomeModel> incomeModel;
    QSharedPointer<ServiceModel> serviceModel;
    static DatabaseManager * _instance;
    QSqlDatabase db;
    qreal getTotal(const QVariantList &sales)const;
    const QString connection_name = "MAIN_DB_CONNECTION";
    void deleteTables();
    void deleteEntireDatabase();

};

#endif // DATABASEMANAGER_H
