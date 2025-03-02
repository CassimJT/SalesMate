#include "product.h"

Product::Product(QObject *parent)
    : QObject{parent}
    ,m_price(0.0)
    ,m_name("")
    ,m_sku("")
    ,m_quantity(0)
{
    //the constractor
}

/**
 * @brief Product::name
 * @return the name of the item
 */
QString Product::name() const
{
    return m_name;
}
/**
 * @brief Product::setName
 * @param newName
 * set the name of the item
 */
void Product::setName(const QString &newName)
{
    if (m_name == newName)
        return;
    m_name = newName;
    emit nameChanged();
}
/**
 * @brief Product::price
 * @return the price of the item
 */
float Product::price() const
{
    return m_price;
}
/**
 * @brief Product::setPrice
 * @param newPrice
 * set the price of the item
 */
void Product::setPrice(float newPrice)
{
    if (qFuzzyCompare(m_price, newPrice))
        return;
    m_price = newPrice;
    emit priceChanged();
}
/**
 * @brief Product::quantity
 * @return the quantity, the amount of the items
 */
int Product::quantity() const
{
    return m_quantity;
}
/**
 * @brief Product::setQuantity
 * @param newQuantity
 * set the mount of the items
 */
void Product::setQuantity(int newQuantity)
{
    if (m_quantity == newQuantity)
        return;
    m_quantity = newQuantity;
    emit quantityChanged();
}
/**
 * @brief Product::sku
 * @return the Stock Keeping Unit for the item
 */
QString Product::sku() const
{
    return m_sku;
}
/**
 * @brief Product::setSku
 * @param newSku
 * set the Stock Keeping Unit of an item
 */
void Product::setSku(const QString &newSku)
{
    if (m_sku == newSku)
        return;
    m_sku = newSku;
    emit skuChanged();
}
/**
 * @brief Product::date
 * @return the date the product was added
 */
QDate Product::date() const
{
    return m_date;
}
/**
 * @brief Product::setDate
 * @param newDate
 * set the date the product was added
 */
void Product::setDate(const QDate &newDate)
{
    if (m_date == newDate)
        return;
    m_date = newDate;
    emit dateChanged();
}


