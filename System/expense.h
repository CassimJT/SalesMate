#ifndef EXPENSE_H
#define EXPENSE_H

#include <QObject>
#include <QDate>
#include <qobject.h>
#include <qtypes.h>

class Expense : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged FINAL)
    Q_PROPERTY(QDate date READ date WRITE setDate NOTIFY dateChanged FINAL)
    Q_PROPERTY(qreal cost READ getCost WRITE setCost NOTIFY costChanged FINAL)
    Q_PROPERTY(QString discription READ discription WRITE setDiscription NOTIFY discriptionChanged FINAL)
public:
    explicit Expense(QObject *parent = nullptr);
    QString source() const;
    void setSource(const QString &newSource);

    QDate date() const;
    void setDate(const QDate &newDate);

    qreal getCost() const;
    void setCost(qreal newCost);

    QString discription() const;
    void setDiscription(const QString &newDiscription);

public slots:
    //slots

signals:
    void sourceChanged();

    void dateChanged();

    void costChanged();

    void discriptionChanged();

private:
    QString m_source;
    QDate  m_date;
    qreal cost;
    QString m_discription;

};

#endif // EXPENSE_H
