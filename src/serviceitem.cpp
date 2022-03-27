#include "serviceitem.h"
#include <qvariant.h>

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
  return m_data.count();
}

QVariant ServiceItem::data(const QModelIndex &index, int role) const
{
  if (!index.isValid())
    return QVariant();

  const Data &data = m_data.at(index.row());
  switch (role) {
  case NameRole:
    return data.name;
  case TypeRole:
    return data.type;
  case BackgroundRole:
    return data.background;
  case BackgroundTypeRole:
    return data.backgroundType;
  case TextRole:
    return data.text;
  default:
    return QVariant();
  }
}

QHash<int, QByteArray> ServiceItem::roleNames() const {
  static QHash<int, QByteArray> mapping {
    {NameRole, "name"},
    {TypeRole, "type"},
    {BackgroundRole, "background"},
    {BackgroundTypeRole, "backgroundType"},
    {TextRole, "text"}
  };

  return mapping;
}

bool ServiceItem::setData(const QModelIndex &index,
                          const QVariant &value,
                          int role) {
  const Data &oldData = m_data.at(index.row());
  const QVariant newData = data(index, role);
  if (newData != value) {
      // FIXME: Implement me!
    switch (role) {
    case NameRole:
      m_data.at(index.row()).name = newData.toString();
    case TypeRole:
      return data.type;
    case BackgroundRole:
      return data.background;
    case BackgroundTypeRole:
      return data.backgroundType;
    case TextRole:
      return data.text;
    default:
      return QVariant();
    }
    oldData = newData;
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
