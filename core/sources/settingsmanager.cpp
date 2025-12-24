#include "settingsmanager.h"
#include <QtMath>

SettingsManager::SettingsManager(QObject *parent)
    : QObject(parent),
    m_appSettings(),
    m_isUserSignedIn(false),
    m_currency("MWK"),
    m_isVatIncluded(true),
    m_vatRate(17.5),
    m_isAutoPrint(true)
{
    loadAppSettings();
}

/**
 * @brief SettingsManager::isUserSignedIn
 * @return true / false
 */
bool SettingsManager::isUserSignedIn() const
{
    return m_isUserSignedIn;
}

/**
 * @brief SettingsManager::setIsUserSignedIn
 * @param newIsUserSignedIn
 * toggle true is user is signed in false otherwise
 */
void SettingsManager::setIsUserSignedIn(bool newIsUserSignedIn)
{
    if (m_isUserSignedIn == newIsUserSignedIn)
        return;

    m_isUserSignedIn = newIsUserSignedIn;
    m_appSettings.setValue("auth/isSignedIn", m_isUserSignedIn);

    emit isUserSignedInChanged();
}

/**
 * @brief SettingsManager::currency
 * @return currency
 */
QString SettingsManager::currency() const
{
    return m_currency;
}

/**
 * @brief SettingsManager::setCurrency
 * @param newCurrency
 * set the system default currency
 */
void SettingsManager::setCurrency(const QString &newCurrency)
{
    if (m_currency == newCurrency)
        return;

    m_currency = newCurrency;
    m_appSettings.setValue("system/currency", m_currency);

    emit currencyChanged();
}

/**
 * @brief SettingsManager::isVatIncluded
 * @return true / false
 */
bool SettingsManager::isVatIncluded() const
{
    return m_isVatIncluded;
}

/**
 * @brief SettingsManager::setIsVatIncluded
 * @param newIsVatIncluded
 * toggle VAT included or not
 */
void SettingsManager::setIsVatIncluded(bool newIsVatIncluded)
{
    if (m_isVatIncluded == newIsVatIncluded)
        return;

    m_isVatIncluded = newIsVatIncluded;
    m_appSettings.setValue("tax/vatIncluded", m_isVatIncluded);

    emit isVatIncludedChanged();
}

/**
 * @brief SettingsManager::vatRate
 * @return the current VAT rate
 */
double SettingsManager::vatRate() const
{
    return m_vatRate;
}

/**
 * @brief SettingsManager::setVatRate
 * @param newVatRate
 * called the system to change the current VAT rate
 */
void SettingsManager::setVatRate(double newVatRate)
{
    if (qFuzzyCompare(m_vatRate, newVatRate))
        return;

    m_vatRate = newVatRate;
    m_appSettings.setValue("tax/vatRate", m_vatRate);

    emit vatRateChanged();
}

/**
 * @brief SettingsManager::isAutoPrint
 * @return true / false
 */
bool SettingsManager::isAutoPrint() const
{
    return m_isAutoPrint;
}

/**
 * @brief SettingsManager::setIsAutoPrint
 * @param newIsAutoPrint
 * Toggle auto print on or off
 */
void SettingsManager::setIsAutoPrint(bool newIsAutoPrint)
{
    if (m_isAutoPrint == newIsAutoPrint)
        return;

    m_isAutoPrint = newIsAutoPrint;
    m_appSettings.setValue("printing/autoPrint", m_isAutoPrint);

    emit isAutoPrintChanged();
}

/**
 * @brief SettingsManager::loadAppSettings
 * load the default settings
 */
void SettingsManager::loadAppSettings()
{
    m_isUserSignedIn = m_appSettings.value("auth/isSignedIn", false).toBool();
    m_currency       = m_appSettings.value("system/currency", "MWK").toString();
    m_isVatIncluded  = m_appSettings.value("tax/vatIncluded", true).toBool();
    m_vatRate        = m_appSettings.value("tax/vatRate", 17.5).toDouble();
    m_isAutoPrint    = m_appSettings.value("printing/autoPrint", true).toBool();

    emit isUserSignedInChanged();
    emit currencyChanged();
    emit isVatIncludedChanged();
    emit vatRateChanged();
    emit isAutoPrintChanged();
}
