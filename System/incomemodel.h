#ifndef INCOMEMODEL_H
#define INCOMEMODEL_H

#include <QAbstractListModel>
#include <QHash>
#include <qstringview.h>
#include <QVector>
#include "income.h"
#include <QDate>
#include <QSqlError>
#include "servicemodel.h"

class DatabaseManager;

class IncomeModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(qreal totalNetIncome READ totalNetIncome NOTIFY totalNetIncomeChanged FINAL);
    Q_PROPERTY(qreal totalCostOfGoodSold READ totalCostOfGoodSold  NOTIFY totalCostOfGoodSoldChanged FINAL)
    enum nameRoles {
        sku  = Qt::UserRole + 1,
        date,
        quantity,
        unitprice,
        totalprice,
        desciption,
        source,
        cogs
    };

public:
    explicit IncomeModel(QObject *parent = nullptr);
    ~IncomeModel();


    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    qreal totalNetIncome()const;
    qreal totalCostOfGoodSold()const;
public slots:
    void addIncome(const QString &sku, const
                   QDate &date,
                   int quantity,
                   qreal unitprice,
                   qreal totalprice,const
                   QString & discription, const
                   QString & source, const
                   qreal &cogs);
    void updateView();
signals:
    void incomeExist();
    void incomeAdded();
    void totalNetIncomeChanged();
    void totalCostOfGoodSoldChanged();
private:
    QVector<QSharedPointer<Income>> netIncome;
    QHash<int,QByteArray> roleNames() const override;
    QWeakPointer<DatabaseManager> databaseManager;
    QSharedPointer<ServiceModel> service;

};

#endif // INCOMEMODEL_H
