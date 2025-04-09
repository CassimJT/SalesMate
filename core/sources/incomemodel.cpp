#include "incomemodel.h"
#include <qsqlquery.h>
#include <qstringview.h>
#include "databasemanager.h"

IncomeModel::IncomeModel(QObject *parent)
    : QAbstractListModel(parent),
    service(QSharedPointer<ServiceModel>::create())
{
    updateView();
}

IncomeModel::~IncomeModel()
{
    //clearing memory
    netIncome.clear();
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
    case cogs:
        return income.cogs();
    default:
        return QVariant();
    }
}
/**
 * @brief IncomeModel::totaNetIncome
 * @return the total net income
 */
qreal IncomeModel::totalNetIncome() const
{
    qreal _netincome = 0.0;

    for (const auto &_income : netIncome) {
        _netincome += _income->totalprice();
    }

    if (service) { // Ensure service is not null before using it
        _netincome += service->totalService();
    }

    return _netincome;
}

/**
 * @brief IncomeModel::totalCostOfGoodSold
 * @return the total cost of good sold
 */
qreal IncomeModel::totalCostOfGoodSold() const
{
    qreal total_cogs = 0.0;
    for(const auto &_income:netIncome) {
        total_cogs += (_income->quantity() * _income->unitprice());
    }
    return total_cogs;
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
void IncomeModel::addIncome(const QString &sku, const QDate &date, int quantity, qreal unitprice, qreal totalprice, const QString &description, const QString &source, const qreal &cogs)
{
    auto income = QSharedPointer<Income>::create(this);
    income->setSku(sku);
    income->setDate(date);
    income->setQuantity(quantity);
    income->setUnitprice(unitprice);
    income->setTotalprice(totalprice);
    income->setDescription(description);
    income->setSource(source);
    income->setCogs(cogs);
    QString formattedDate = date.toString(Qt::ISODate); //formating Date

    QSqlQuery query;
    query.prepare(R"(
        INSERT INTO netincome (sku, source, date, quantity, unitprice, totalprice, description,cogs)
        VALUES (:sku, :source, :date, :quantity, :unitprice, :totalprice, :description, :cogs)
    )");

    query.bindValue(":sku", sku);
    query.bindValue(":source", source);
    query.bindValue(":date", formattedDate);
    query.bindValue(":quantity", quantity);
    query.bindValue(":unitprice", unitprice);
    query.bindValue(":totalprice", totalprice);
    query.bindValue(":description", description);
    query.bindValue(":cogs",cogs);

    if (!query.exec()) {
        QSqlError error = query.lastError();
        qDebug() << "Failed to add income:" << error.text();
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
        roles[source] = "Source",
        roles[cogs] = "COGS";
    return roles;
}
/**
 * @brief IncomeModel::updateView
 * udating the view
 */
void IncomeModel::updateView()
{
    //
    beginResetModel();
    netIncome.clear();

    QSqlQuery query("SELECT id,sku, source, date, quantity, unitprice,totalprice, description,cogs FROM netincome");
    while (query.next()) {
        auto _incom = QSharedPointer<Income>::create(this);
        _incom->setSku(query.value(1).toString());
        _incom->setSource(query.value(2).toString());
        _incom->setDate(QDate::fromString(query.value(3).toString(), "yyyy-MM-dd"));
        _incom->setQuantity(query.value(4).toInt());
        _incom->setUnitprice(query.value(5).toReal());
        _incom->setTotalprice(query.value(6).toReal());
        _incom->setDescription(query.value(7).toString());
        _incom->setCogs(query.value(8).toReal());
        netIncome.append(_incom);
    }
    endResetModel();
    emit totalNetIncomeChanged();

}
