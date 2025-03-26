#include "service.h"

Service::Service(QObject *parent)
    : QObject{parent},
    m_sku(""),
    m_description(""),
    m_source(""),
    m_servicePrice(0.0),
    m_itemprice(0.0)

{
    //the constractor
}

Service::~Service()
{
    //the distractor
}
/**
 * @brief Service::sku
 * @return the service sku
 */
QString Service::sku() const
{
    return m_sku;
}
/**
 * @brief Service::setSku
 * @param newSku
 * set the service sku
 */
void Service::setSku(const QString &newSku)
{
    if (m_sku == newSku)
        return;
    m_sku = newSku;
    emit skuChanged();
}
/**
 * @brief Service::date
 * @return the date the service was made
 */
QDate Service::date() const
{
    return m_date;
}
/**
 * @brief Service::setDate
 * @param newDate
 * set the date the service was made
 */
void Service::setDate(const QDate &newDate)
{
    if (m_date == newDate)
        return;
    m_date = newDate;
    emit dateChanged();
}
/**
 * @brief Service::description
 * @return the service description
 */
QString Service::description() const
{
    return m_description;
}
/**
 * @brief Service::setDescription
 * @param newDescription
 * set the service description
 */
void Service::setDescription(const QString &newDescription)
{
    if (m_description == newDescription)
        return;
    m_description = newDescription;
    emit descriptionChanged();
}
/**
 * @brief Service::source
 * @return the source / service name
 */
QString Service::source() const
{
    return m_source;
}
/**
 * @brief Service::setSource
 * @param newSource
 * set the name / service source
 */
void Service::setSource(const QString &newSource)
{
    if (m_source == newSource)
        return;
    m_source = newSource;
    emit sourceChanged();
}
/**
 * @brief Service::servicePrice
 * @return the cost of the service
 */
qreal Service::servicePrice() const
{
    return m_servicePrice;
}
/**
 * @brief Service::setServicePrice
 * @param newServicePrice
 * set the cost of the service
 */
void Service::setServicePrice(qreal newServicePrice)
{
    if (qFuzzyCompare(m_servicePrice, newServicePrice))
        return;
    m_servicePrice = newServicePrice;
    emit servicePriceChanged();
}
/**
 * @brief Service::itemprice
 * @return the item price used on the service.
 * the item and service price makes the ovaral price of the service name
 */
qreal Service::itemprice() const
{
    return m_itemprice;
}
/**
 * @brief Service::setItemprice
 * @param newItemprice
 * set the cost of the ite associated / used on the service
 */
void Service::setItemprice(qreal newItemprice)
{
    if (qFuzzyCompare(m_itemprice, newItemprice))
        return;
    m_itemprice = newItemprice;
    emit itempriceChanged();
}
