#include "serviceitem.h"

ServiceItem::ServiceItem(QObject *parent)
  : QAbstractListModel(parent)
{
}

int ServiceItem::rowCount(const QModelIndex &parent) const
{
  // For list models only the root node (an invalid parent) should return the list's size. For all
  // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
  if (parent.isValid())
    return 0;

  // FIXME: Implement me!
}

QVariant ServiceItem::data(const QModelIndex &index, int role) const
{
  if (!index.isValid())
    return QVariant();

  // FIXME: Implement me!
  return QVariant();
}

bool ServiceItem::setData(const QModelIndex &index, const QVariant &value, int role)
{
  if (data(index, role) != value) {
      // FIXME: Implement me!
      emit dataChanged(index, index, QVector<int>() << role);
      return true;
    }
  return false;
}

Qt::ItemFlags ServiceItem::flags(const QModelIndex &index) const
{
  if (!index.isValid())
    return Qt::NoItemFlags;

  return Qt::ItemIsEditable; // FIXME: Implement me!
}

bool ServiceItem::insertRows(int row, int count, const QModelIndex &parent)
{
  beginInsertRows(parent, row, row + count - 1);
  // FIXME: Implement me!
  endInsertRows();
}

bool ServiceItem::removeRows(int row, int count, const QModelIndex &parent)
{
  beginRemoveRows(parent, row, row + count - 1);
  // FIXME: Implement me!
  endRemoveRows();
}
