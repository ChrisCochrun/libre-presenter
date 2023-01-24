#include "slidemodel.h"
#include "serviceitem.h"
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
  // if () {
  //   addItem(new Slide("10,000 Reasons", "song",
  //                           "file:/home/chris/nextcloud/tfc/openlp/CMG - Nature King 21.jpg",
  //                           "image", QString("Yip Yip"),
  //                           "file:/home/chris/nextcloud/tfc/openlp/music/Eden-Phil Wickham [lyrics].mp3"));
  //   addItem(new Slide("Marvelous Light", "song",
  //                           "file:/home/chris/nextcloud/tfc/openlp/Fire Embers_Loop.mp4",
  //                           "video", QString("Hallelujah!")));
  //   addItem(new Slide("BP Text", "video",
  //                           "file:/home/chris/nextcloud/tfc/openlp/videos/test.mp4",
  //                           "video", QString()));
  // }
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
  case TextRole:
    return item->text();
  case TypeRole:
    return item->type();
  case ImageBackgroundRole:
    return item->imageBackground();
  case VideoBackgroundRole:
    return item->videoBackground();
  case AudioRole:
    return item->audio();
  case FontRole:
    return item->font();
  case FontSizeRole:
    return item->fontSize();
  case ServiceItemIdRole:
    return item->serviceItemId();
  case SlideIndexRole:
    return item->slideIndex();
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
  static QHash<int, QByteArray> mapping {
    {TextRole, "text"},
    {TypeRole, "type"},
    {ImageBackgroundRole, "imageBackground"},
    {VideoBackgroundRole, "videoBackground"},
    {AudioRole, "audio"},
    {FontRole, "font"},
    {FontSizeRole, "fontSize"},
    {ServiceItemIdRole, "serviceItemId"},
    {HorizontalTextAlignmentRole, "horizontalTextAlignment"},
    {VerticalTextAlignmentRole, "verticalTextAlignment"},
    {SlideIndexRole, "slideIndex"},
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
  case ImageBackgroundRole:
    if (item->imageBackground() != value.toString()) {
      item->setImageBackground(value.toString());
      somethingChanged = true;
    }
    break;
  case VideoBackgroundRole:
    if (item->videoBackground() != value.toString()) {
      item->setVideoBackground(value.toString());
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
  case SlideIndexRole:
    if (item->slideIndex() != value.toInt()) {
      item->setSlideIndex(value.toInt());
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

void SlideModel::addItem(const QString &text, const QString &type,
                         const QString &imageBackground, const QString &videoBackground,
                         const QString &audio,
                         const QString &font, const int &fontSize,
                         const QString &horizontalTextAlignment,
                         const QString &verticalTextAlignment,
                         const int &serviceItemId, const int &slideIndex,
                         const int &imageCount) {
  Slide *item = new Slide(text, audio, imageBackground, videoBackground,
                          horizontalTextAlignment,
                          verticalTextAlignment,
                          font, fontSize, imageCount, type, slideIndex );
  item->setSelected(false);
  item->setActive(false);
  item->setServiceItemId(serviceItemId);
  addItem(item);
  qDebug() << "#################################";
  qDebug() << type << font << fontSize << serviceItemId;
  qDebug() << "#################################";
}

void SlideModel::insertItem(const int &index,
                            const QString &type, const QString &imageBackground,
                            const QString &videoBackground, const QString &text,
                            const QString &audio, const QString &font,
                            const int &fontSize, const QString &horizontalTextAlignment,
                            const QString &verticalTextAlignment,
                            const int &serviceItemId, const int &slideIndex,
                            const int &imageCount) {
  Slide *item = new Slide(text, audio, imageBackground, videoBackground,
                          horizontalTextAlignment, verticalTextAlignment, font, fontSize,
                          imageCount, type, slideIndex);
  item->setSelected(false);
  item->setActive(false);
  item->setServiceItemId(serviceItemId);
  insertItem(index, item);
  qDebug() << "#################################";
  qDebug() << "ADDING A NEW SLIDE INTO MODEL!";
  qDebug() << type << font << fontSize << slideIndex;
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
                     parent, isMoveDown ? destIndex + 1 : destIndex)) {
    qDebug() << "Can't move rows";
    return false;
  }
    
  qDebug() << "starting move: " << "source: " << sourceIndex << "dest: " << destIndex;

  m_items.move(sourceIndex, destIndex);

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
    itm["serviceItemId"] = item->serviceItemId();
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
      qDebug() << "deselected" << item->slideIndex();
      qDebug() << "################";
      emit dataChanged(idx, idx, QVector<int>() << SelectedRole);
    }
  }
  QModelIndex idx = index(id);
  Slide *item = m_items[idx.row()];
  item->setSelected(true);
  qDebug() << "################";
  qDebug() << "selected" << item->slideIndex();
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
      qDebug() << "deactivated" << itm->slideIndex();
      qDebug() << "################";
      emit dataChanged(idx, idx, QVector<int>() << ActiveRole);
    }
  }

  item->setActive(true);
  qDebug() << "################";
  qDebug() << "slide activated" << item->slideIndex();
  qDebug() << "################";
  emit dataChanged(idx, idx, QVector<int>() << ActiveRole);
  return true;
}

bool SlideModel::deactivate(int id) {
  QModelIndex idx = index(id);
  Slide *item = m_items[idx.row()];

  item->setActive(false);
  qDebug() << "################";
  qDebug() << "deactivated" << item->slideIndex();
  qDebug() << "################";
  emit dataChanged(idx, idx, QVector<int>() << ActiveRole);
  return true;
}

void SlideModel::clearAll() {
  for (int i = m_items.size(); i >= 0; i--) {
    removeItem(i);
  }
}

int SlideModel::findSlideIdFromServItm(int index) {
  for (int i = 0; i < m_items.size(); i++) {
    Slide *itm = m_items[i];
    if (itm->serviceItemId() == index) {
      return i;
    }
  }
  return -1;
}

void SlideModel::addItemFromService(const int &index, const ServiceItem &item) {
  qDebug() << "***INSERTING SLIDE FROM SERVICEITEM***";
  if (item.type() == "song") {
    for (int i = 0; i < item.text().size(); i++) {
      if (item.backgroundType() == "image") {
        addItem(item.text()[i], item.type(), item.background(), "",
                item.audio(), item.font(), item.fontSize(), "center", "center",
                index, i, item.text().size());
      } else {
        addItem(item.text()[i], item.type(), "", item.background(), 
                item.audio(), item.font(), item.fontSize(), "center", "center",
                index, i, item.text().size());
      }
    }
  } else if (item.type() == "presentation") {
    for (int i = 0; i < item.slideNumber(); i++) {
      addItem("", item.type(), item.background(), "",
              item.audio(), item.font(), item.fontSize(),
              "center", "center",
              index, i, item.slideNumber());
    }
  } else if (item.type() == "video") {
    addItem("", item.type(), "", item.background(), 
            item.audio(), item.font(), item.fontSize(),
            "center", "center",
            index, 0, 1);
  } else {
    addItem("", item.type(), item.background(), "", 
            item.audio(), item.font(), item.fontSize(),
            "center", "center",
            index, 0, 1);
  }

}

void SlideModel::insertItemFromService(const int &index, const ServiceItem &item) {
  qDebug() << "***INSERTING SLIDE FROM SERVICEITEM***";
  int slideId = findSlideIdFromServItm(index);
  if (item.type() == "song") {
    for (int i = 0; i < item.text().size(); i++) {
      if (item.backgroundType() == "image") {
        insertItem(slideId + i, item.type(), item.background(), "", item.text()[i],
                   item.audio(), item.font(), item.fontSize(), "center", "center",
                   index, i, item.text().size());
      } else {
        insertItem(slideId + i, item.type(), "", item.background(), item.text()[i],
                   item.audio(), item.font(), item.fontSize(), "center", "center",
                   index, i, item.text().size());
      }
    }
  } else if (item.type() == "presentation") {
    for (int i = 0; i < item.slideNumber(); i++) {
      insertItem(slideId + i, item.type(), item.background(), "",
                 "", item.audio(), item.font(), item.fontSize(),
                 "center", "center",
                 index, i, item.slideNumber());
    }
  } else if (item.type() == "video") {
    insertItem(slideId, item.type(), "", item.background(), "",
               item.audio(), item.font(), item.fontSize(),
               "center", "center",
               index, 0, 1);
  } else {
    insertItem(slideId, item.type(), item.background(), "", "",
               item.audio(), item.font(), item.fontSize(),
               "center", "center",
               index, 0, 1);
  }

}

void SlideModel::moveRowFromService(const int &fromIndex,
                                    const int &toIndex,
                                    const ServiceItem &item) {
  const bool isMoveDown = toIndex > fromIndex;
  qDebug() << "@@@Move SIs" << fromIndex << "to" << toIndex << "@@@";
  int slideId = findSlideIdFromServItm(fromIndex);
  int toSlideId = isMoveDown ? findSlideIdFromServItm(toIndex + 1) - 1 : findSlideIdFromServItm(toIndex);
  // Slide toSlide = m_items[toSlideId];
  int count;
  if (item.type() == "song")
    count = item.text().length();
  else if (item.type() == "presentation")
    count = item.slideNumber();
  else
    count = 1;
  // int toCount = toSlide.imageCount();
  int toId = count + slideId;
  qDebug() << "@@@Move Row" << slideId << "to" << toSlideId << "@@@";
  qDebug() << count;
  if (isMoveDown) {
    if (toSlideId - slideId > 1)
      moveRows(slideId, toSlideId - 1, count);
    else
      moveRows(slideId, toSlideId, count);
  } else {
    if (slideId - toSlideId > 1)
      moveRows(slideId - 1, toSlideId, count);
    else
      moveRows(slideId, toSlideId, count);
  }
  m_items[toSlideId]->setServiceItemId(toIndex);
  if (isMoveDown) {
    for (int i = slideId; i < toSlideId; i++) {
      m_items[i]->setServiceItemId(m_items[i]->serviceItemId() - 1);
    }
  } else {
    for (int i = slideId; i > toSlideId; i--) {
      m_items[i]->setServiceItemId(m_items[i]->serviceItemId() + 1);
    }
  }
}
