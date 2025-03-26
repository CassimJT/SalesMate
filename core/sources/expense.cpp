#include "expense.h"

Expense::Expense(QObject *parent)
    : QObject{parent}
{
    //expensi class
}
/**
 * @brief Expense::source
 * @return the source os the expense
 */
QString Expense::source() const
{
    return m_source;
}
/**
 * @brief Expense::setSource
 * @param newSource
 * set the source of the expense(what the mone was used for)
 */
void Expense::setSource(const QString &newSource)
{
    if (m_source == newSource)
        return;
    m_source = newSource;
    emit sourceChanged();
}
/**
 * @brief Expense::date
 * @return the date the expense was made
 */
QDate Expense::date() const
{
    return m_date;
}
/**
 * @brief Expense::setDate
 * @param newDate
 * set the date an expense was made
 */
void Expense::setDate(const QDate &newDate)
{
    if (m_date == newDate)
        return;
    m_date = newDate;
    emit dateChanged();
}
/**
 * @brief Expense::getCost
 * @return the cost of the expence
 */
qreal Expense::getCost() const
{
    return cost;
}
/**
 * @brief Expense::setCost
 * @param newCost
 * set the amount the expense costed
 */
void Expense::setCost(qreal newCost)
{
    if (qFuzzyCompare(cost, newCost))
        return;
    cost = newCost;
    emit costChanged();
}
/**
 * @brief Expense::discription
 * @return the brief discription / resaon for the expense
 */
QString Expense::description() const
{
    return m_discription;
}
/**
 * @brief Expense::setDiscription
 * @param newDiscription
 * set the discription / reson for the expense made
 */
void Expense::setDescription(const QString &newDiscription)
{
    if (m_discription == newDiscription)
        return;
    m_discription = newDiscription;
    emit descriptionChanged();
}
