#include "expensesmodel.h"
#include <qstringview.h>

ExpensesModel::ExpensesModel(QObject *parent)
    : QAbstractListModel(parent)
{
    //constractor
}

QVariant ExpensesModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    // FIXME: Implement me!
    if(orientation == Qt::Horizontal && role == Qt::DisplayRole) {
        switch (section) {
        case 0:
            return QStringLiteral("Source");
        case 1:
            return QStringLiteral("Date");
        case 2:
            return QStringLiteral("Cost");
        case 3:
            return QStringLiteral("Discription");
        default:
            return QVariant();
        }

    }
    return QVariant();
}

int ExpensesModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    return expenses.count();
}

QVariant ExpensesModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= expenses.size())
        return QVariant();
    const Expense &expense = *expenses.at(index.row());
    switch (role) {
    case source:
        return expense.source();
    case cost:
        return expense.getCost();
    case discription:
        return expense.discription();
    case date:
        return expense.date();
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> ExpensesModel::roleNames() const
{
    QHash<int,QByteArray> roles;
    roles[source] = "Source",
        roles[date] = "Date",
        roles[cost] = "Cost",
        roles[discription] = "discription";
    return roles;
}
