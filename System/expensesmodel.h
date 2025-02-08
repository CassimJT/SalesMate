#ifndef EXPENSESMODEL_H
#define EXPENSESMODEL_H

#include <QAbstractListModel>
#include <qnamespace.h>
#include <QHash>
#include <qstringview.h>
#include <QList>

class ExpensesModel : public QAbstractListModel
{
    Q_OBJECT
    enum roleNames {
        source = Qt::UserRole + 1,
        date,
        cost,
        discription
    };

public:
    explicit ExpensesModel(QObject *parent = nullptr);

    // Header:
    QVariant headerData(int section,
                        Qt::Orientation orientation,
                        int role = Qt::DisplayRole) const override;

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

private:

    QHash<int, QByteArray> roleNames() const override;
};

#endif // EXPENSESMODEL_H
