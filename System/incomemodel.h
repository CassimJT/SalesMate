#ifndef INCOMEMODEL_H
#define INCOMEMODEL_H

#include <QAbstractListModel>
#include <QHash>
#include <qstringview.h>
#include <QVector>
#include "income.h"
#include "databasemanager.h"
#include <QDate>
#include <QSqlError>

class IncomeModel : public QAbstractListModel
{
    Q_OBJECT
    enum nameRoles {
        sku  = Qt::UserRole + 1,
        date,
        quantity,
        unitprice,
        totalprice,
        desciption,
        source
    };

public:
    explicit IncomeModel(QObject *parent = nullptr);

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
public slots:
    void addIncome(const QString &sku, const QDate &date, int quantity, qreal unitprice,qreal totalprice, const QString & discription, const QString & source);
signals:
    void incomeExist();
    void incomeAdded();
private:
    QVector<QSharedPointer<Income>> netIncome;
    QHash<int,QByteArray> roleNames() const override;
    DatabaseManager databaseManager;
};

#endif // INCOMEMODEL_H
