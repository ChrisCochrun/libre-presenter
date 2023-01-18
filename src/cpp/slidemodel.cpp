#include "slidemodel.h"
#include "slide.h"
#include <qabstractitemmodel.h>
#include <qglobal.h>
#include <qnamespace.h>
#include <qvariant.h>
#include <QDebug>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QFile>
#include <QMap>
#include <QTemporaryFile>
#include <QDir>
#include <QUrl>
#include <QSettings>
#include <QStandardPaths>
#include <QImage>


SlideModel::SlideModel(QObject *parent)
    : QAbstractListModel(parent) {
  if (!loadLastSaved()) {
    addItem(new Slide("10,000 Reasons", "song",
                            "file:/home/chris/nextcloud/tfc/openlp/CMG - Nature King 21.jpg",
                            "image", QStringList("Yip Yip"),
                            "file:/home/chris/nextcloud/tfc/openlp/music/Eden-Phil Wickham [lyrics].mp3"));
    addItem(new Slide("Marvelous Light", "song",
                            "file:/home/chris/nextcloud/tfc/openlp/Fire Embers_Loop.mp4",
                            "video", QStringList("Hallelujah!")));
    addItem(new Slide("BP Text", "video",
                            "file:/home/chris/nextcloud/tfc/openlp/videos/test.mp4",
                            "video", QStringList()));
  }
}

int SlideModel::rowCount(const QModelIndex &parent) const {
  // For list models only the root node (an invalid parent) should return the
  // list's size. For all other (valid) parents, rowCount() should return 0 so
  // that it does not become a tree model.
  if (parent.isValid())
    return 0;

  // FIXME: Implement me!
  return m_items.size();
}

QVariant SlideModel::data(const QModelIndex &index, int role) const {
  if (!index.isValid())
    return QVariant();

  Slide *item = m_items[index.row()];
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
  case ServiceItemIdRole:
    return item->serviceItemId();
  case HorizontalTextAlignmentRole:
    return item->horizontalTextAlignment();
  case VerticalTextAlignmentRole:
    return item->verticalTextAlignment();
  case ActiveRole:
    return item->active();
  case SelectedRole:
    return item->selected();
  default:
    return QVariant();
  }
}

QHash<int, QByteArray> SlideModel::roleNames() const {
  static QHash<int, QByteArray> mapping{
    {NameRole, "name"},
    {TypeRole, "type"},
    {BackgroundRole, "background"},
    {BackgroundTypeRole, "backgroundType"},
    {TextRole, "text"},
    {AudioRole, "audio"},
    {FontRole, "font"},
    {FontSizeRole, "fontSize"},
    {ServiceItemIdRole, "serviceItemId"},
    {HorizontalTextAlignmentRole, "horizontalTextAlignment"},
    {VerticalTextAlignmentRole, "verticalTextAlignment"},
    {ActiveRole, "active"},
    {SelectedRole, "selected"}
  };

  return mapping;
}

bool SlideModel::setData(const QModelIndex &index, const QVariant &value,
                               int role) {

  Slide *item = m_items[index.row()];
  bool somethingChanged = false;

  switch (role) {
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
    if (item->text() != value.toString()) {
      item->setText(value.toString());
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
  case ServiceItemIdRole:
    if (item->serviceItemId() != value.toInt()) {
      item->setServiceItemId(value.toInt());
      somethingChanged = true;
    }
    break;
  case HorizontalTextAlignmentRole:
    if (item->horizontalTextAlignment() != value.toString()) {
      item->setHorizontalTextAlignment(value.toString());
      somethingChanged = true;
    }
    break;
  case VerticalTextAlignmentRole:
    if (item->verticalTextAlignment() != value.toString()) {
      item->setVerticalTextAlignment(value.toString());
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

Qt::ItemFlags SlideModel::flags(const QModelIndex &index) const {
  if (!index.isValid())
    return Qt::NoItemFlags;

  return Qt::ItemIsEditable; // FIXME: Implement me!
}

// int SlideModel::index(int row, int column, const QModelIndex &parent) {
//       if (!hasIndex(row, column, parent))
//         return QModelIndex();

//     Slide *parentItem;

//     if (!parent.isValid())
//         parentItem = rootItem;
//     else
//         parentItem = static_cast<Slide*>(parent.internalPointer());

//     Slide *childItem = parentItem->child(row);
//     if (childItem)
//         return createIndex(row, column, childItem);
//     return QModelIndex();
// }

void SlideModel::addItem(Slide *item) {
  const int index = m_items.size();
  qDebug() << index;
  // foreach (item, m_items) {
  //   qDebug() << item;
  // }
  beginInsertRows(QModelIndex(), index, index);
  m_items.append(item);
  endInsertRows();
}

void SlideModel::insertItem(const int &index, Slide *item) {
  beginInsertRows(this->index(index).parent(), index, index);
  m_items.insert(index, item);
  endInsertRows();
  qDebug() << "Success";
}

void SlideModel::addItem(const QString &text, const QString &type) {
  Slide *item = new Slide(name, type);
  item->setSelected(false);
  item->setActive(false);
  addItem(item);
}

void SlideModel::addItem(const QString &name, const QString &type,
                         const QString &imageBackground, const QString &videoBackground) {
  Slide *item = new Slide(name, type, imageBackground, videoBackground);
  item->setSelected(false);
  item->setActive(false);
  addItem(item);
}

void SlideModel::addItem(const QString &name, const QString &type,
                         const QString &imageBackground, const QString &videoBackground,
                         const QStringList &text) {
  Slide *item = new Slide(name, type, imageBackground, videoBackground, text);
  item->setSelected(false);
  item->setActive(false);
  addItem(item);
  qDebug() << name << type << imageBackground;
}

void SlideModel::addItem(const QString &name, const QString &type,
                         const QString &imageBackground, const QString &videoBackground,
                         const QStringList &text, const QString &audio) {
  Slide *item = new Slide(name, type, imageBackground, videoBackground,
                          text, audio);
  item->setSelected(false);
  item->setActive(false);
  addItem(item);
  qDebug() << name << type << imageBackground;
}

void SlideModel::addItem(const QString &name, const QString &type,
                         const QString &imageBackground, const QString &videoBackground,
                         const QStringList &text, const QString &audio,
                         const QString &font, const int &fontSize) {
  Slide *item = new Slide(name, type, imageBackground, videoBackground,
                          text, audio, font, fontSize);
  item->setSelected(false);
  item->setActive(false);
  addItem(item);
  qDebug() << "#################################";
  qDebug() << name << type << font << fontSize;
  qDebug() << "#################################";
}

void SlideModel::addItem(const QString &name, const QString &type,
                         const QString &imageBackground, const QString &videoBackground,
                         const QStringList &text, const QString &audio,
                         const QString &font, const int &fontSize,
                         const QString &horizontalTextAlignment,
                         const QString &verticalTextAlignment) {
  Slide *item = new Slide(name, type, imageBackground, videoBackground,
                          text, audio, font, fontSize, horizontalTextAlignment,
                          verticalTextAlignment);
  item->setSelected(false);
  item->setActive(false);
  addItem(item);
  qDebug() << "#################################";
  qDebug() << name << type << font << fontSize;
  qDebug() << "#################################";
}

void SlideModel::addItem(const QString &name, const QString &type,
                         const QString &imageBackground, const QString &videoBackground,
                         const QStringList &text, const QString &audio,
                         const QString &font, const int &fontSize,
                         const QString &horizontalTextAlignment,
                         const QString &verticalTextAlignment,
                         const int &serviceItemId) {
  Slide *item = new Slide(name, type, imageBackground, videoBackground,
                          text, audio, font, fontSize, horizontalTextAlignment,
                          verticalTextAlignment);
  item->setSelected(false);
  item->setActive(false);
  item->setServiceItemId(serviceItemId);
  addItem(item);
  qDebug() << "#################################";
  qDebug() << name << type << font << fontSize << serviceItemId;
  qDebug() << "#################################";
}

void SlideModel::insertItem(const int &index, const QString &name, const QString &type) {
  Slide *item = new Slide(name, type);
  item->setSelected(false);
  item->setActive(false);
  insertItem(index, item);
  qDebug() << name << type;
}

void SlideModel::insertItem(const int &index, const QString &name, const QString &type,
                            const QString &imageBackground, const QString &videoBackground) {
  Slide *item = new Slide(name, type, imageBackground, videoBackground);
  item->setSelected(false);
  item->setActive(false);
  insertItem(index, item);
  qDebug() << name << type << imageBackground;
}

void SlideModel::insertItem(const int &index, const QString &name, const QString &type,
                            const QString &imageBackground, const QString &videoBackground,
                            const QStringList &text) {
  Slide *item = new Slide(name, type, imageBackground, videoBackground, text);
  insertItem(index, item);
  qDebug() << name << type << imageBackground << text;
}

void SlideModel::insertItem(const int &index, const QString &name,
                            const QString &type,const QString &imageBackground,
                            const QString &videoBackground,const QStringList &text,
                            const QString &audio) {
  Slide *item = new Slide(name, type, imageBackground, videoBackground,
                          text, audio);
  item->setSelected(false);
  item->setActive(false);
  insertItem(index, item);
  qDebug() << name << type << imageBackground << text;
}

void SlideModel::insertItem(const int &index, const QString &name,
                            const QString &type,const QString &imageBackground,
                            const QString &videoBackground,const QStringList &text,
                            const QString &audio, const QString &font,
                            const int &fontSize) {
  Slide *item = new Slide(name, type, imageBackground, videoBackground,
                                      text, audio, font, fontSize);
  item->setSelected(false);
  item->setActive(false);
  insertItem(index, item);
  qDebug() << "#################################";
  qDebug() << name << type << font << fontSize;
  qDebug() << "#################################";
}

void SlideModel::insertItem(const int &index, const QString &name,
                            const QString &type,const QString &imageBackground,
                            const QString &videoBackground,const QStringList &text,
                            const QString &audio, const QString &font,
                            const int &fontSize, const int &slideNumber) {
  Slide *item = new Slide(name, type, imageBackground, videoBackground,
                                      text, audio, font, fontSize, slideNumber);
  item->setSelected(false);
  item->setActive(false);
  insertItem(index, item);
  qDebug() << "#################################";
  qDebug() << name << type << font << fontSize << slideNumber;
  qDebug() << "#################################";
}

void SlideModel::removeItem(int index) {
  beginRemoveRows(QModelIndex(), index, index);
  m_items.removeAt(index);
  endRemoveRows();
}

bool SlideModel::moveRows(int sourceIndex, int destIndex, int count) {
  qDebug() << index(sourceIndex).row();
  qDebug() << index(destIndex).row();

  const int lastIndex = rowCount() - 1;

  if (sourceIndex == destIndex
      || (sourceIndex < 0 || sourceIndex > lastIndex)
      || (destIndex < 0 || destIndex > lastIndex)) {
    return false;
  }

  const QModelIndex parent = index(sourceIndex).parent();
  const bool isMoveDown = destIndex > sourceIndex;

  if (!beginMoveRows(parent, sourceIndex, sourceIndex + count - 1,
                     parent, isMoveDown ? destIndex + 2 : destIndex)) {
    qDebug() << "Can't move rows";
    return false;
  }
    
  qDebug() << "starting move: " << "source: " << sourceIndex << "dest: " << destIndex;

  m_items.move(sourceIndex, isMoveDown ? destIndex + 1 : destIndex);

  endMoveRows();
  return true;
}

bool SlideModel::moveDown(int id) {
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

bool SlideModel::moveUp(int id) {
  qDebug() << index(id).row();
  qDebug() << index(id - 1).row();
  QModelIndex parent = index(id).parent();

  bool begsuc = beginMoveRows(parent, id,
                              id, parent, id - 1);
  if (begsuc) {
    int dest = id - 1;
    if (dest <= -1)
      {
        qDebug() << "dest too big, moving to beginning";
        m_items.move(id, 0);
      }
    else
      m_items.move(id, dest);
    endMoveRows();
    return true;
  }

  return false;
}

QVariantMap SlideModel::getItem(int index) const {
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

QVariantList SlideModel::getItems() {
  QVariantList data;
  Slide * item;
  foreach (item, m_items) {
    qDebug() << item->serviceItemId();
    QVariantMap itm;
    itm["type"] = item->type();
    itm["imageBackground"] = item->imageBackground();
    itm["videoBackground"] = item->videoBackground();
    itm["text"] = item->text();
    itm["audio"] = item->audio();
    itm["font"] = item->font();
    itm["fontSize"] = item->fontSize();
    itm["horizontalTextAlignment"] = item->horizontalTextAlignment();
    itm["verticalTextAlignment"] = item->verticalTextAlignment();
    itm["serviceItemId"] = item->seviceItemId();
    itm["selected"] = item->selected();
    itm["active"] = item->active();
    data.append(itm);
  }
  qDebug() << "$$$$$$$$$$$$$$$$$$$$$$$$$$$";
  qDebug() << data;
  qDebug() << "$$$$$$$$$$$$$$$$$$$$$$$$$$$";
  return data;
}

bool SlideModel::select(int id) {
  for (int i = 0; i < m_items.length(); i++) {
    QModelIndex idx = index(i);
    Slide *item = m_items[idx.row()];
    if (item->selected()) {
      item->setSelected(false);
      qDebug() << "################";
      qDebug() << "deselected" << item->name();
      qDebug() << "################";
      emit dataChanged(idx, idx, QVector<int>() << SelectedRole);
    }
  }
  QModelIndex idx = index(id);
  Slide *item = m_items[idx.row()];
  item->setSelected(true);
  qDebug() << "################";
  qDebug() << "selected" << item->name();
  qDebug() << "################";
  emit dataChanged(idx, idx, QVector<int>() << SelectedRole);
  return true;
}

bool SlideModel::activate(int id) {
  QModelIndex idx = index(id);
  Slide *item = m_items[idx.row()];

  for (int i = 0; i < m_items.length(); i++) {
    QModelIndex idx = index(i);
    Slide *itm = m_items[idx.row()];
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

bool SlideModel::deactivate(int id) {
  QModelIndex idx = index(id);
  Slide *item = m_items[idx.row()];

  item->setActive(false);
  qDebug() << "################";
  qDebug() << "deactivated" << item->name();
  qDebug() << "################";
  emit dataChanged(idx, idx, QVector<int>() << ActiveRole);
  return true;
}

void SlideModel::clearAll() {
  for (int i = m_items.size(); i >= 0; i--) {
    removeItem(i);
  }
}
