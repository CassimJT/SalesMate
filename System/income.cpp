#include "income.h"

Income::Income(QObject *parent)
    : QObject{parent}
{
    //constractor
}
/**
 * @brief Income::date
 * @return the date i income was made
 *
 */
QDate Income::date() const
{
    return m_date;
}
/**
 * @brief Income::setDate
 * @param newDate
 * set the date the income was made
 */
void Income::setDate(const QDate &newDate)
{
    if (m_date == newDate)
        return;
    m_date = newDate;
    emit dateChanged();
}
/**
 * @brief Income::quantity
 * @return the quantity of the income sold
 */
int Income::quantity() const
{
    return m_quantity;
}
/**
 * @brief Income::setQuantity
 * @param newQuantity
 *  set the quantity of items sold
 */
void Income::setQuantity(int newQuantity)
{
    if (m_quantity == newQuantity)
        return;
    m_quantity = newQuantity;
    emit quantityChanged();
}
/**
 * @brief Income::unitprice
 * @return the unit price of the item/service
 */
qreal Income::unitprice() const
{
    return m_unitprice;
}
/**
 * @brief Income::setUnitprice
 * @param newUnitprice
 * set the unit price of an item/service
 */
void Income::setUnitprice(qreal newUnitprice)
{
    if (qFuzzyCompare(m_unitprice, newUnitprice))
        return;
    m_unitprice = newUnitprice;
    emit unitpriceChanged();
}
/**
 * @brief Income::totalprice
 * @return the unit price x the quantity
 */
qreal Income::totalprice() const
{
    return m_totalprice;
}
/**
 * @brief Income::setTotalprice
 * @param newTotalprice
 * the toal price after calcaulating
 */
void Income::setTotalprice(qreal newTotalprice)
{
    if (qFuzzyCompare(m_totalprice, newTotalprice))
        return;
    m_totalprice = newTotalprice;
    emit totalpriceChanged();
}
/**
 * @brief Income::disciption
 * @return the description of the item sold
 */
QString Income::description() const
{
    return m_disciption;
}
/**
 * @brief Income::setDisciption
 * @param newDisciption
 * set a simple item discription of what was sold e.g discounts
 */
void Income::setDescription(const QString &newDisciption)
{
    if (m_disciption == newDisciption)
        return;
    m_disciption = newDisciption;
    emit descriptionChanged();
}
/**
 * @brief Income::source
 * @return return the source of the icome
 */
QString Income::source() const
{
    return m_source;
}
/**
 * @brief Income::setSource
 * @param newSource
 * set the source of the incom of the item/service,,
 */
void Income::setSource(const QString &newSource)
{
    if (m_source == newSource)
        return;
    m_source = newSource;
    emit sourceChanged();
}
/**
 * @brief Income::sku
 * @return the item stock barcode
 */
QString Income::sku() const
{
    return m_sku;
}
/**
 * @brief Income::setSku
 * @param newSku
 * set the item stock code
 */
void Income::setSku(const QString &newSku)
{
    if (m_sku == newSku)
        return;
    m_sku = newSku;
    emit skuChanged();
}
