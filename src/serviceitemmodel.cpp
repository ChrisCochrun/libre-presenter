#include "serviceitemmodel.h"
#include "serviceitem.h"
#include <qabstractitemmodel.h>
#include <qglobal.h>
#include <qnamespace.h>
#include <qvariant.h>
#include <qdebug.h>

ServiceItemModel::ServiceItemModel(QObject *parent)
    : QAbstractListModel(parent) {
  addItem(new ServiceItem("10,000 Resons", "song",
                          "file:/home/chris/nextcloud/tfc/openlp/CMG - Nature King 21.jpg",
                          "image", QStringList("Yip Yip")));
  addItem(new ServiceItem("Marvelous Light", "song",
                          "file:/home/chris/nextcloud/tfc/openlp/Fire Embers_Loop.mp4",
                          "video", QStringList("Hallelujah!")));
  addItem(new ServiceItem("BP Text", "video",
                          "file:/home/chris/nextcloud/tfc/openlp/videos/test.mp4",
                          "video", QStringList()));
}

int ServiceItemModel::rowCount(const QModelIndex &parent) const {
  // For list models only the root node (an invalid parent) should return the
  // list's size. For all other (valid) parents, rowCount() should return 0 so
  // that it does not become a tree model.
  if (parent.isValid())
    return 0;

  // FIXME: Implement me!
  return m_items.size();
}

QVariant ServiceItemModel::data(const QModelIndex &index, int role) const {
  if (!index.isValid())
    return QVariant();

  ServiceItem *item = m_items[index.row()];
  switch (role) {
  case NameRole:
    return item->name();
  case TypeRole:
    return item->type();
  case BackgroundRole:
    return item->background();
  case BackgroundTypeRole:
    return item->backgroundType();
  case TextRole:
    return item->text();
  default:
    return QVariant();
  }
}

QHash<int, QByteArray> ServiceItemModel::roleNames() const {
  static QHash<int, QByteArray> mapping{{NameRole, "name"},
                                        {TypeRole, "type"},
                                        {BackgroundRole, "background"},
                                        {BackgroundTypeRole, "backgroundType"},
                                        {TextRole, "text"}};

  return mapping;
}

bool ServiceItemModel::setData(const QModelIndex &index, const QVariant &value,
                               int role) {

  ServiceItem *item = m_items[index.row()];
  bool somethingChanged = false;

  switch (role) {
  case NameRole:
    if (item->name() != value.toString()) {
      item->setName(value.toString());
      somethingChanged = true;
    }
    break;
  case TypeRole:
    if (item->type() != value.toString()) {
      item->setType(value.toString());
      somethingChanged = true;
    }
    break;
  case BackgroundRole:
    if (item->background() != value.toString()) {
      item->setBackground(value.toString());
      somethingChanged = true;
    }
    break;
  case BackgroundTypeRole:
    if (item->backgroundType() != value.toString()) {
      item->setBackgroundType(value.toString());
      somethingChanged = true;
    }
    break;
  case TextRole:
    if (item->text() != value.toStringList()) {
      item->setText(value.toStringList());
      somethingChanged = true;
    }
    break;
    if (somethingChanged) {
      emit dataChanged(index, index, QVector<int>() << role);
      return true;
    }
  }

  return false;
}

Qt::ItemFlags ServiceItemModel::flags(const QModelIndex &index) const {
  if (!index.isValid())
    return Qt::NoItemFlags;

  return Qt::ItemIsEditable; // FIXME: Implement me!
}

void ServiceItemModel::addItem(ServiceItem *item) {
  const int index = m_items.size();
  qDebug() << index;
  // foreach (item, m_items) {
  //   qDebug() << item;
  // }
  beginInsertRows(QModelIndex(), index, index);
  m_items.append(item);
  foreach (item, m_items) {
    qDebug() << item;
  }
  endInsertRows();
}

void ServiceItemModel::insertItem(const int &index, ServiceItem *item) {
  beginInsertRows(this->index(index).parent(), index, index);
  m_items.insert(index, item);
  endInsertRows();
  qDebug() << "Success";
}

void ServiceItemModel::addItem(const QString &name, const QString &type) {
  ServiceItem *item = new ServiceItem(name, type);
  addItem(item);
}

void ServiceItemModel::addItem(const QString &name, const QString &type,
                               const QString &background, const QString &backgroundType) {
  ServiceItem *item = new ServiceItem(name, type, background, backgroundType);
  addItem(item);
}

void ServiceItemModel::addItem(const QString &name, const QString &type,
                               const QString &background, const QString &backgroundType,
                               const QStringList &text) {
  ServiceItem *item = new ServiceItem(name, type, background, backgroundType, text);
  addItem(item);
  qDebug() << name << type << background;
}

void ServiceItemModel::insertItem(const int &index, const QString &name, const QString &type) {
  ServiceItem *item = new ServiceItem(name, type);
  insertItem(index, item);
  qDebug() << name << type;
}

void ServiceItemModel::insertItem(const int &index, const QString &name, const QString &type,
                               const QString &background, const QString &backgroundType) {
  ServiceItem *item = new ServiceItem(name, type, background, backgroundType);
  insertItem(index, item);
  qDebug() << name << type << background;
}

void ServiceItemModel::insertItem(const int &index, const QString &name, const QString &type,
                               const QString &background, const QString &backgroundType,
                               const QStringList &text) {
  ServiceItem *item = new ServiceItem(name, type, background, backgroundType, text);
  insertItem(index, item);
  qDebug() << name << type << background << text;
}

void ServiceItemModel::removeItem(int index) {
  beginRemoveRows(QModelIndex(), index, index);
  m_items.removeAt(index);
  endRemoveRows();
}

bool ServiceItemModel::move(int sourceIndex, int destIndex) {
  qDebug() << "starting move of: " << "source: " << sourceIndex << "dest: " << destIndex;
  qDebug() << index(sourceIndex).row();
  qDebug() << index(destIndex).row();
  // QModelIndex parent = index(sourceIndex).parent();
  // bool begsuc = beginMoveRows(parent, sourceIndex, sourceIndex, parent, destIndex);
  beginResetModel();
  m_items.move(sourceIndex, destIndex);
  // endMoveRows();
  endResetModel();
  // qDebug() << success;
  return true;
}

QVariantMap ServiceItemModel::getItem(int index) const {
  QVariantMap data;
  const QModelIndex idx = this->index(index,0);
  // qDebug() << idx;
  if( !idx.isValid() )
    return data;
  const QHash<int,QByteArray> rn = roleNames();
  // qDebug() << rn;
  QHashIterator<int,QByteArray> it(rn);
  while (it.hasNext()) {
    it.next();
    qDebug() << it.key() << ":" << it.value();
    data[it.value()] = idx.data(it.key());
  }
  return data;
}
