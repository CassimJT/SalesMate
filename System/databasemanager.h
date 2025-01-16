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

class DatabaseManager : public QAbstractListModel
{
    Q_OBJECT
    enum nameRoles{
        itemname = Qt::UserRole + 1,
        sku,
        quantity,
        price
    };
    //setting up database connection

public:
    explicit DatabaseManager(QObject *parent = nullptr);

    // Header:
    QVariant headerData(int section,
                        Qt::Orientation orientation,
                        int role = Qt::DisplayRole) const override;

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
public slots:
    //
    void queryDatabase(const QString &sku);
    float queryPriceFromDatabase(const QString &sku);
    void addProductToDatabase(const QString &name, const QString &sku, int quantity, float price);
signals:
    void newProductAdded();
    void productUpdated();
    void productRemoved();
    void productExists();

private:
    Product product;
    QVector<Product*> products;
    QHash<int,QByteArray> roleNames() const ;
    void setUpDatabase();
    void updateView();
};

#endif // DATABASEMANAGER_H
