#include "expensesmodel.h"
#include <qstringview.h>

ExpensesModel::ExpensesModel(QObject *parent)
    : QAbstractListModel(parent)
{
    //constractor
    databaseManager.setUpExpenceTable();
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
    case description:
        return expense.description();
    case date:
        return expense.date();
    default:
        return QVariant();
    }
}
/**
 * @brief ExpensesModel::addExpence
 * @param source
 * @param date
 * @param cost
 * @param discription
 * this function adds entries(expenses) in the database
 */
void ExpensesModel::addExpence(const QString &source, const QDate &date, qreal cost, const QString &description)
{
    // Create a new Expense object
    auto expense = QSharedPointer<Expense>::create(this);
    expense->setSource(source);
    expense->setDate(date);
    expense->setCost(cost);
    expense->setDescription(description);

    QSqlQuery query;
    query.prepare(R"(
        INSERT INTO expences (source, date, cost, description)
        VALUES (:source, :date, :cost, :description)
    )");

    query.bindValue(":source", source);
    query.bindValue(":date", date);
    query.bindValue(":cost", cost);
    query.bindValue(":description", description);

    if (!query.exec()) {
        QSqlError error = query.lastError();
        qDebug() << "Failed to add Expense:" << error.text();

        if (error.databaseText().contains("UNIQUE", Qt::CaseInsensitive)) {
            qDebug() << "Unique constraint violated";
            emit expenseExist();
        }

        return;
    }

    beginResetModel();
    expenses.append(expense);
    endResetModel();

    emit expenseAdded();
}

QHash<int, QByteArray> ExpensesModel::roleNames() const
{
    QHash<int,QByteArray> roles;
    roles[source] = "Source",
        roles[date] = "Date",
        roles[cost] = "Cost",
        roles[description] = "description";
    return roles;
}
