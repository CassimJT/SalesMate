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
    case disciption:
        return income.disciption();
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
void IncomeModel::addIncome(const QString &sku, const QDate &date, int quantity, qreal unitprice, qreal totalprice, const QString &discription, const QString &source)
{
    //....
    auto m_netIncome = new Income(this);
    m_netIncome->setSku(sku);
    m_netIncome->setDate(date);
    m_netIncome->setQuantity(quantity);
    m_netIncome->setUnitprice(unitprice);
    m_netIncome->setTotalprice(totalprice);
    m_netIncome->setDisciption(discription);
    m_netIncome->setSource(source);

    QSqlQuery query;
    query.prepare(R"(INSERT INTO netincome (sku,source,date,quantity,unitprice,totalprice,disciption)
                        VALUES(:sku,:source,:date,:quantity,:unitprice,:totalprice,:disciption)
                    )");

    if(!query.exec()) {
        QSqlError error = query.lastError();
        qDebug()<<"Faild to add income: "; error.text();
        if(error.databaseText().contains("UNIQUE",Qt::CaseInsensitive)) {
            //...
            qDebug() <<"Unique constain violated";
            emit incomeExist();
            return;
        }
    }
    //emit a signal if data is added suscessifuly
    emit incomeAdded();
    beginResetModel();
    netIncome.append(QSharedPointer<Income>::create(m_netIncome));
    endResetModel();
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
