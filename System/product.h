#ifndef PRODUCT_H
#define PRODUCT_H

#include <QObject>
#include <qobject.h>

class Product : public QObject
{
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged FINAL)
    Q_PROPERTY(float price READ price WRITE setPrice NOTIFY priceChanged FINAL)
    Q_PROPERTY(int quantity READ quantity WRITE setQuantity NOTIFY quantityChanged FINAL)
    Q_PROPERTY(QString sku READ sku WRITE setSku NOTIFY skuChanged FINAL) 
    Q_OBJECT
public:
    explicit Product(QObject *parent = nullptr);
   // Product(const QString &newName,const QString &newSku,int newQuantity,float newPrice);
    //normal function

    int getSample() const;
    void setSample(int newSample);

public slots:
    //Slotes

    QString name() const;
    void setName(const QString &newName);

    float price() const;
    void setPrice(float newPrice);

    int quantity() const;
    void setQuantity(int newQuantity);

    QString sku() const;
    void setSku(const QString &newSku);

signals:
    void nameChanged();

    void priceChanged();

    void quantityChanged();

    void skuChanged();

private:
    QString m_name;
    float m_price;
    int m_quantity;
    QString m_sku;
    int sample;


};

#endif // PRODUCT_H
