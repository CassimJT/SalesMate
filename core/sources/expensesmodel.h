#ifndef EXPENSESMODEL_H
#define EXPENSESMODEL_H

#include <QAbstractListModel>
#include <qnamespace.h>
#include <QHash>
#include <qstringview.h>
#include <QList>
#include <QVector>
#include "expense.h"
#include <QDate>
#include "databasemanager.h"
#include <QSqlError>

class ExpensesModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(qreal totalCost READ totalCost NOTIFY totalCostChanged)
    enum roleNames {
        source = Qt::UserRole + 1,
        date,
        cost,
        description
    };

public:
    explicit ExpensesModel(QObject *parent = nullptr);
    ~ExpensesModel();

    // Header:
    QVariant headerData(int section,
                        Qt::Orientation orientation,
                        int role = Qt::DisplayRole) const override;

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    qreal totalCost()const;
public slots:
    void addExpence( const QString &source, const QDate &date, qreal cost, const QString &discription);
    void updateView();

signals:
    void expenseAdded();
    void expenseExist();
    void totalCostChanged();

private:
    QVector<QSharedPointer<Expense>> expenses;
    QHash<int, QByteArray> roleNames() const override;
    DatabaseManager databaseManager;


};

#endif // EXPENSESMODEL_H
