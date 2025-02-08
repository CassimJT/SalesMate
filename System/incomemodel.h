#ifndef INCOMEMODEL_H
#define INCOMEMODEL_H

#include <QAbstractListModel>
#include <QHash>
#include <qstringview.h>

class IncomeModel : public QAbstractListModel
{
    Q_OBJECT
    enum nameRoles {
        sku  = Qt::UserRole + 1,
        date,
        quantity,
        unitprice,
        totalprice,
        disciption,
        source
    };

public:
    explicit IncomeModel(QObject *parent = nullptr);

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

private:
    QHash<int,QByteArray> roleNames() const override;
};

#endif // INCOMEMODEL_H
