#ifndef SERVICE_H
#define SERVICE_H

#include <QObject>
#include <QDate>

class Service : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString sku READ sku WRITE setSku NOTIFY skuChanged FINAL)
    Q_PROPERTY(QDate date READ date WRITE setDate NOTIFY dateChanged FINAL)
    Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged FINAL)
    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged FINAL)
    Q_PROPERTY(qreal servicePrice READ servicePrice WRITE setServicePrice NOTIFY servicePriceChanged FINAL)
    Q_PROPERTY(qreal itemprice READ itemprice WRITE setItemprice NOTIFY itempriceChanged FINAL)
public:
    explicit Service(QObject *parent = nullptr);
    ~Service();

    QString sku() const;
    void setSku(const QString &newSku);

    QDate date() const;
    void setDate(const QDate &newDate);

    QString description() const;
    void setDescription(const QString &newDescription);

    QString source() const;
    void setSource(const QString &newSource);

    qreal servicePrice() const;
    void setServicePrice(qreal newServicePrice);

    qreal itemprice() const;
    void setItemprice(qreal newItemprice);

signals:

    void skuChanged();

    void dateChanged();

    void descriptionChanged();

    void sourceChanged();

    void servicePriceChanged();

    void itempriceChanged();

private:
    QString m_sku;
    QDate m_date;
    QString m_description;
    QString m_source;
    qreal m_servicePrice;
    qreal m_itemprice;

};

#endif // SERVICE_H
