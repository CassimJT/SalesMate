#ifndef PRODUCT_H
#define PRODUCT_H

#include <QObject>
#include <qobject.h>
#include <QDate>

class Product : public QObject
{
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged FINAL)
    Q_PROPERTY(qreal price READ price WRITE setPrice NOTIFY priceChanged FINAL)
    Q_PROPERTY(int quantity READ quantity WRITE setQuantity NOTIFY quantityChanged FINAL)
    Q_PROPERTY(QString sku READ sku WRITE setSku NOTIFY skuChanged FINAL)
    Q_PROPERTY(QDate date READ date WRITE setDate NOTIFY dateChanged FINAL)
    Q_OBJECT
public:
    explicit Product(QObject *parent = nullptr);
    // Product(const QString &newName,const QString &newSku,int newQuantity,float newPrice);
    //normal function

    int getSample() const;
    void setSample(int newSample);

    QString name() const;
    void setName(const QString &newName);

    qreal price() const;
    void setPrice(qreal newPrice);

    int quantity() const;
    void setQuantity(int newQuantity);

    QString sku() const;
    void setSku(const QString &newSku);

    QDate date() const;
    void setDate(const QDate &newDate);

public slots:
              //Slotes

signals:
    void nameChanged();

    void priceChanged();

    void quantityChanged();

    void skuChanged();

    void dateChanged();

private:
    QString m_name;
    qreal m_price;
    int m_quantity;
    QString m_sku;
    QDate m_date;


};

#endif // PRODUCT_H
