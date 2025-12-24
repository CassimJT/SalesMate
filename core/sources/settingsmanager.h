#ifndef SETTINGSMANAGER_H
#define SETTINGSMANAGER_H

#include <QObject>
#include <QSettings>

class SettingsManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool isUserSignedIn READ isUserSignedIn WRITE setIsUserSignedIn NOTIFY isUserSignedInChanged FINAL)
    Q_PROPERTY(QString currency READ currency WRITE setCurrency NOTIFY currencyChanged FINAL)
    Q_PROPERTY(bool isVatIncluded READ isVatIncluded WRITE setIsVatIncluded NOTIFY isVatIncludedChanged FINAL)
    Q_PROPERTY(double vatRate READ vatRate WRITE setVatRate NOTIFY vatRateChanged FINAL)
    Q_PROPERTY(bool isAutoPrint READ isAutoPrint WRITE setIsAutoPrint NOTIFY isAutoPrintChanged FINAL)
public:
    explicit SettingsManager(QObject *parent = nullptr);


    bool isUserSignedIn() const;
    void setIsUserSignedIn(bool newIsUserSignedIn);

    QString currency() const;
    void setCurrency(const QString &newCurrency);

    bool isVatIncluded() const;
    void setIsVatIncluded(bool newIsVatIncluded);



    bool isAutoPrint() const;
    void setIsAutoPrint(bool newIsAutoPrint);

public slots:
    void loadAppSettings();
private slots:
    double vatRate() const;
    void setVatRate(double newVatRate);
signals:


    void isUserSignedInChanged();

    void currencyChanged();

    void isVatIncludedChanged();

    void vatRateChanged();

    void isAutoPrintChanged();

private:
    QSettings m_appSettings;
    bool m_isUserSignedIn;
    QString m_currency;
    bool m_isVatIncluded;
    double m_vatRate;
    bool m_isAutoPrint;


};

#endif // SETTINGSMANAGER_H
