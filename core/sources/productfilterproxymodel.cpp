#include "productfilterproxymodel.h"

ProductFilterProxyModel::ProductFilterProxyModel(QObject *parent)
    : QSortFilterProxyModel(parent)
{
}

void ProductFilterProxyModel::setFilterName(const QString &name) {
    qDebug() << "Filtering by name:" << name;
    setFilterRegularExpression(QRegularExpression(name, QRegularExpression::CaseInsensitiveOption));
    emit filterNameChanged();
}

bool ProductFilterProxyModel::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const  {
    QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);
    QString rowData = sourceModel()->data(index, filterRole()).toString().trimmed();
    QString filterText = filterRegularExpression().pattern().trimmed();

    if (filterText.isEmpty()) {
        return true; // Include all rows when the filter is empty
    }

    return rowData.contains(filterRegularExpression());
}

QString ProductFilterProxyModel::filterName() const
{
    return m_filterName;
}




