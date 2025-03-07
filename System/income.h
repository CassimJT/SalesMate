#ifndef INCOME_H
#define INCOME_H

#include <QObject>
#include <QDate>
#include <qdatetime.h>
#include <qobject.h>
#include <qtypes.h>

class Income : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QDate date READ date WRITE setDate NOTIFY dateChanged FINAL)
    Q_PROPERTY(int quantity READ quantity WRITE setQuantity NOTIFY quantityChanged FINAL)
    Q_PROPERTY(qreal unitprice READ unitprice WRITE setUnitprice NOTIFY unitpriceChanged FINAL)
    Q_PROPERTY(qreal totalprice READ totalprice WRITE setTotalprice NOTIFY totalpriceChanged FINAL)
    Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged FINAL)
    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged FINAL)
    Q_PROPERTY(QString sku READ sku WRITE setSku NOTIFY skuChanged FINAL)
public:
    explicit Income(QObject *parent = nullptr);

    QDate date() const;
    void setDate(const QDate &newDate);

    int quantity() const;
    void setQuantity(int newQuantity);

    qreal unitprice() const;
    void setUnitprice(qreal newUnitprice);

    qreal totalprice() const;
    void setTotalprice(qreal newTotalprice);

    QString description() const;
    void setDescription(const QString &newDisciption);

    QString source() const;
    void setSource(const QString &newSource);

    QString sku() const;
    void setSku(const QString &newSku);

    qreal cogs() const;
    void setCogs(qreal newCogs);

public slots:
              //slots


signals:
         //signals
    void dateChanged();

    void quantityChanged();

    void unitpriceChanged();

    void totalpriceChanged();

    void descriptionChanged();

    void sourceChanged();

    void skuChanged();

    void cogsChanged();

private:
    QDate m_date;
    int m_quantity;
    qreal m_unitprice;
    qreal m_totalprice;
    QString m_disciption;
    QString m_source;
    QString m_sku;
    qreal m_cogs;


    Q_PROPERTY(qreal cogs READ cogs WRITE setCogs NOTIFY cogsChanged FINAL)
};

#endif // INCOME_H
