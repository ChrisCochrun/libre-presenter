#include "serviceitemmodel.h"
#include "serviceitem.h"
#include <qabstractitemmodel.h>
#include <qglobal.h>
#include <qnamespace.h>
#include <qvariant.h>
#include <qdebug.h>

ServiceItemModel::ServiceItemModel(QObject *parent)
    : QAbstractListModel(parent) {
  addItem(new ServiceItem("10,000 Reasons", "song",
                          "file:/home/chris/nextcloud/tfc/openlp/CMG - Nature King 21.jpg",
                          "image", QStringList("Yip Yip"),
                          "file:/home/chris/nextcloud/tfc/openlp/music/Eden-Phil Wickham [lyrics].mp3"));
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
  case AudioRole:
    return item->audio();
  case FontRole:
    return item->font();
  case FontSizeRole:
    return item->fontSize();
  case ActiveRole:
    return item->active();
  case SelectedRole:
    return item->selected();
  default:
    return QVariant();
  }
}

QHash<int, QByteArray> ServiceItemModel::roleNames() const {
  static QHash<int, QByteArray> mapping{{NameRole, "name"},
                                        {TypeRole, "type"},
                                        {BackgroundRole, "background"},
                                        {BackgroundTypeRole, "backgroundType"},
                                        {TextRole, "text"},
                                        {AudioRole, "audio"},
                                        {FontRole, "font"},
                                        {FontSizeRole, "fontSize"},
                                        {ActiveRole, "active"},
                                        {SelectedRole, "selected"}};

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
  case AudioRole:
    if (item->audio() != value.toString()) {
      item->setAudio(value.toString());
      somethingChanged = true;
    }
    break;
  case FontRole:
    if (item->font() != value.toString()) {
      item->setFont(value.toString());
      somethingChanged = true;
    }
    break;
  case FontSizeRole:
    if (item->fontSize() != value.toInt()) {
      item->setFontSize(value.toInt());
      somethingChanged = true;
    }
    break;
  case ActiveRole:
    if (item->active() != value.toBool()) {
      item->setActive(value.toBool());
      somethingChanged = true;
    }
    break;
  case SelectedRole:
    if (item->selected() != value.toBool()) {
      item->setSelected(value.toBool());
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

// int ServiceItemModel::index(int row, int column, const QModelIndex &parent) {
//       if (!hasIndex(row, column, parent))
//         return QModelIndex();

//     ServiceItem *parentItem;

//     if (!parent.isValid())
//         parentItem = rootItem;
//     else
//         parentItem = static_cast<ServiceItem*>(parent.internalPointer());

//     ServiceItem *childItem = parentItem->child(row);
//     if (childItem)
//         return createIndex(row, column, childItem);
//     return QModelIndex();
// }

void ServiceItemModel::addItem(ServiceItem *item) {
  const int index = m_items.size();
  qDebug() << index;
  // foreach (item, m_items) {
  //   qDebug() << item;
  // }
  beginInsertRows(QModelIndex(), index, index);
  m_items.append(item);
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

void ServiceItemModel::addItem(const QString &name, const QString &type,
                               const QString &background, const QString &backgroundType,
                               const QStringList &text, const QString &audio) {
  ServiceItem *item = new ServiceItem(name, type, background, backgroundType,
                                      text, audio);
  addItem(item);
  qDebug() << name << type << background;
}

void ServiceItemModel::addItem(const QString &name, const QString &type,
                               const QString &background, const QString &backgroundType,
                               const QStringList &text, const QString &audio,
                               const QString &font, const int &fontSize) {
  ServiceItem *item = new ServiceItem(name, type, background, backgroundType,
                                      text, audio, font, fontSize);
  addItem(item);
  qDebug() << "#################################";
  qDebug() << name << type << font << fontSize;
  qDebug() << "#################################";
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

void ServiceItemModel::insertItem(const int &index, const QString &name,
                                  const QString &type,const QString &background,
                                  const QString &backgroundType,const QStringList &text,
                                  const QString &audio) {
  ServiceItem *item = new ServiceItem(name, type, background, backgroundType,
                                      text, audio);
  insertItem(index, item);
  qDebug() << name << type << background << text;
}

void ServiceItemModel::insertItem(const int &index, const QString &name,
                                  const QString &type,const QString &background,
                                  const QString &backgroundType,const QStringList &text,
                                  const QString &audio, const QString &font, const int &fontSize) {
  ServiceItem *item = new ServiceItem(name, type, background, backgroundType,
                                      text, audio, font, fontSize);
  insertItem(index, item);
  qDebug() << "#################################";
  qDebug() << name << type << font << fontSize;
  qDebug() << "#################################";
}

void ServiceItemModel::removeItem(int index) {
  beginRemoveRows(QModelIndex(), index, index);
  m_items.removeAt(index);
  endRemoveRows();
}

bool ServiceItemModel::move(int sourceIndex, int destIndex) {
  qDebug() << index(sourceIndex).row();
  qDebug() << index(destIndex).row();
  QModelIndex parent = index(sourceIndex).parent();
  if (sourceIndex >= 0 && sourceIndex != destIndex &&
      destIndex >= -1 && destIndex <= rowCount() &&
      sourceIndex < rowCount()) {
    qDebug() << "starting move: " << "source: " << sourceIndex << "dest: " << destIndex;
    bool begsuc = beginMoveRows(parent, sourceIndex,
                                sourceIndex, parent, destIndex);
    if (begsuc) {
      if (destIndex == -1)
        {
          qDebug() << "dest was too small, moving to row 0";
          m_items.move(sourceIndex, 0);
        }
      else
        {
          qDebug() << "dest was not too small";
          if (destIndex >= m_items.size())
            {
              qDebug() << "destIndex too big, moving to end";
              m_items.move(sourceIndex, m_items.size() - 1);
            }
          else
            m_items.move(sourceIndex, destIndex);
        }
      endMoveRows();
      return true;
    }
    qDebug() << "Can't move row, not sure why, sourceIndex: "
             << sourceIndex << " destIndex: " << destIndex;
    return false;
  }
  qDebug() << "Can't move row, invalid options, sourceIndex: "
           << sourceIndex << " destIndex: " << destIndex;
  return false;
}

bool ServiceItemModel::moveDown(int id) {
  qDebug() << index(id).row();
  qDebug() << index(id + 1).row();
  QModelIndex parent = index(id).parent();

  bool begsuc = beginMoveRows(parent, id,
                              id, parent, id + 2);
  if (begsuc) {
    int dest = id + 1;
    if (dest >= m_items.size())
      {
        qDebug() << "dest too big, moving to end";
        m_items.move(id, m_items.size() - 1);
      }
    else
      m_items.move(id, dest);
    endMoveRows();
    return true;
  }
  return false;
}

bool ServiceItemModel::moveUp(int id) {
  qDebug() << index(id).row();
  qDebug() << index(id - 1).row();
  QModelIndex parent = index(id).parent();



  return false;
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

bool ServiceItemModel::select(int id) {
  QModelIndex idx = index(id);
  ServiceItem *item = m_items[idx.row()];
  item->setSelected(true);
  qDebug() << "################";
  qDebug() << "selected" << item->name();
  qDebug() << "################";
  return true;
}

bool ServiceItemModel::activate(int id) {
  QModelIndex idx = index(id);
  ServiceItem *item = m_items[idx.row()];

  for (int i = 0; i < m_items.length(); i++) {
    QModelIndex idx = index(i);
    ServiceItem *itm = m_items[idx.row()];
    if (itm->active()) {
      itm->setActive(false);
      qDebug() << "################";
      qDebug() << "deactivated" << itm->name();
      qDebug() << "################";
      emit dataChanged(idx, idx, QVector<int>() << ActiveRole);
    }
  }

  item->setActive(true);
  qDebug() << "################";
  qDebug() << "activated" << item->name();
  qDebug() << "################";
  emit dataChanged(idx, idx, QVector<int>() << ActiveRole);
  return true;
}
