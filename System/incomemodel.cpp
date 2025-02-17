#include "incomemodel.h"
#include <qstringview.h>

IncomeModel::IncomeModel(QObject *parent)
    : QAbstractListModel(parent)
{
    //constractor
    databaseManager.setUpIncomeTable();
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
    case desciption:
        return income.description();
    case source:
        return income.source();
    default:
        return QVariant();
    }
}
/**
 * @brief IncomeModel::addIncome
 * @param sku
 * @param date
 * @param quantity
 * @param unitprice
 * @param totalprice
 * @param discription
 * @param source
 * this function add income generated to the table
 */
void IncomeModel::addIncome(const QString &sku, const QDate &date, int quantity, qreal unitprice, qreal totalprice, const QString &description, const QString &source)
{
    auto income = QSharedPointer<Income>::create(this);
    income->setSku(sku);
    income->setDate(date);
    income->setQuantity(quantity);
    income->setUnitprice(unitprice);
    income->setTotalprice(totalprice);
    income->setDescription(description);
    income->setSource(source);

    QSqlQuery query;
    query.prepare(R"(
        INSERT INTO netincome (sku, source, date, quantity, unitprice, totalprice, description)
        VALUES (:sku, :source, :date, :quantity, :unitprice, :totalprice, :description)
    )");

    query.bindValue(":sku", sku);
    query.bindValue(":source", source);
    query.bindValue(":date", date);
    query.bindValue(":quantity", quantity);
    query.bindValue(":unitprice", unitprice);
    query.bindValue(":totalprice", totalprice);
    query.bindValue(":description", description);

    if (!query.exec()) {
        QSqlError error = query.lastError();
        qDebug() << "Failed to add income:" << error.text();
        if (error.databaseText().contains("UNIQUE", Qt::CaseInsensitive)) {
            qDebug() << "Unique constraint violated";
            emit incomeExist();
        }

        return;
    }

    beginResetModel();
    netIncome.append(income);
    endResetModel();

    // Emit the signal after the model is updated
    emit incomeAdded();
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
        roles[desciption] = "Desciption",
        roles[source] = "Source";
    return roles;
}
