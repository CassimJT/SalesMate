#ifndef PRODUCTFILTERPROXYMODEL_H
#define PRODUCTFILTERPROXYMODEL_H

#include <QSortFilterProxyModel>
#include <qtmetamacros.h>

class ProductFilterProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY(QString filterName READ filterName WRITE setFilterName NOTIFY filterNameChanged FINAL)
public:
    explicit ProductFilterProxyModel(QObject *parent = nullptr);

public slots:

    QString filterName() const;
    void setFilterName(const QString &name);

signals:
    void filterNameChanged();

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;

private:
    QString m_filterName;

};

#endif // PRODUCTFILTERPROXYMODEL_H
