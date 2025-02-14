#include "incomemodel.h"
#include <qstringview.h>

IncomeModel::IncomeModel(QObject *parent)
    : QAbstractListModel(parent)
{
    //constractor
}

int IncomeModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    return netIncome.count();
}

QVariant IncomeModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= netIncome.size())
        return QVariant();
    const Income &income = *netIncome.at(index.row());
    switch (role) {
    case sku:
        return income.sku();
    case date:
        return income.date();
    case quantity:
        return income.quantity();
    case unitprice:
        return income.unitprice();
    case totalprice:
        return income.totalprice();
    case disciption:
        return income.disciption();
    case source:
        return income.source();
    default:
        return QVariant();
    }
}
/**
 * @brief IncomeModel::roleNames
 * @return roleNames
 */
QHash<int, QByteArray> IncomeModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[sku] = "Sku",
        roles[date] = "Date",
        roles[quantity] = "Quantity",
        roles[unitprice] = "UnitPrice",
        roles[totalprice] = "TotalPrice",
        roles[disciption] = "Disciption",
        roles[source] = "Source";
    return roles;
}
