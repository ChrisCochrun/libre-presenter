#include "serviceitemmodel.h"
#include "serviceitem.h"
#include "filemanager.h"
#include <qabstractitemmodel.h>
#include <qglobal.h>
#include <qnamespace.h>
#include <qvariant.h>
#include <ktar.h>
#include <KCompressionDevice>
#include <KArchiveDirectory>
#include <KArchiveFile>
#include <KArchiveEntry>
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


ServiceItemModel::ServiceItemModel(QObject *parent)
    : QAbstractListModel(parent) {
  if (!loadLastSaved()) {
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
      destIndex > -1 && destIndex <= rowCount() &&
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

QVariantList ServiceItemModel::getItems() {
  QVariantList data;
  ServiceItem * item;
  foreach (item, m_items) {
    qDebug() << item->name();
    QVariantMap itm;
    itm["name"] = item->name();
    itm["type"] = item->type();
    itm["background"] = item->background();
    itm["backgroundType"] = item->backgroundType();
    itm["text"] = item->text();
    itm["audio"] = item->audio();
    itm["font"] = item->font();
    itm["fontSize"] = item->fontSize();
    data.append(itm);
  }
  qDebug() << "$$$$$$$$$$$$$$$$$$$$$$$$$$$";
  qDebug() << data;
  qDebug() << "$$$$$$$$$$$$$$$$$$$$$$$$$$$";
  return data;
}

bool ServiceItemModel::select(int id) {
  for (int i = 0; i < m_items.length(); i++) {
    QModelIndex idx = index(i);
    ServiceItem *item = m_items[idx.row()];
    if (item->selected()) {
      item->setSelected(false);
      qDebug() << "################";
      qDebug() << "deselected" << item->name();
      qDebug() << "################";
      emit dataChanged(idx, idx, QVector<int>() << SelectedRole);
    }
  }
  QModelIndex idx = index(id);
  ServiceItem *item = m_items[idx.row()];
  item->setSelected(true);
  qDebug() << "################";
  qDebug() << "selected" << item->name();
  qDebug() << "################";
  emit dataChanged(idx, idx, QVector<int>() << SelectedRole);
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
    return true;
  }

  item->setActive(true);
  qDebug() << "################";
  qDebug() << "activated" << item->name();
  qDebug() << "################";
  emit dataChanged(idx, idx, QVector<int>() << ActiveRole);
  return true;
}

bool ServiceItemModel::save(QUrl file) {
  qDebug() << "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@";
  qDebug() << "Saving...";
  qDebug() << "File path is: " << file.toString();
  qDebug() << "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@";

  //first we'll get a json representation of our serviceList
  //save that to a temp file in case we need it but also convert
  //it to a byte array just before putting it into the archive

  QJsonArray jsonData;

  // save all the data and files in jsonData as just the base name
  // so that they are properly mapped in the resulting archive
  for (int i = 0; i < m_items.length(); i++) {
    // qDebug() << serviceList[i];
    QMap<QString, QVariant> item;
    qDebug() << m_items[i]->name();

    item.insert("name", m_items[i]->name());
    item.insert("background", m_items[i]->background());
    item.insert("backgroundType", m_items[i]->backgroundType());
    item.insert("audio", m_items[i]->audio());
    item.insert("font", m_items[i]->font());
    item.insert("fontSize", m_items[i]->fontSize());
    item.insert("text", m_items[i]->text());
    item.insert("type", m_items[i]->type());

    qDebug() << "AUDIO IS: " << item.value("audio").toString();
    QFileInfo audioFile = item.value("audio").toString();
    qDebug() << audioFile.fileName();
    item["flatAudio"] = audioFile.fileName();
    qDebug() << "AUDIO IS NOW: " << item.value("audio").toString();

    QFileInfo backgroundFile = item.value("background").toString();
    item["flatBackground"] = backgroundFile.fileName();
    qDebug() << "BACKGRUOND IS: " << item.value("background").toString();
    // qDebug() << serviceList[i].value();
    QJsonObject obj = QJsonObject::fromVariantMap(item);
    qDebug() << obj;
    jsonData.insert(i, obj);
  }

  qDebug() << jsonData;
  QJsonDocument jsonText(jsonData);
  QTemporaryFile jsonFile;

  if (!jsonFile.exists())
    qDebug() << "NOT EXISTS!";

  if (!jsonFile.open())
    return false;

  //finalize the temp json file, in case something goes wrong in the
  //archive, we'll have this to jump back to
  jsonFile.write(jsonText.toJson());
  qDebug() << jsonFile.fileName();
  jsonFile.close();

  //now we create our archive file and set it's parameters
  QString filename = file.toString().right(file.toString().size() - 7);
  qDebug() << filename;

  KTar tar(filename, "application/zstd");

  if (tar.open(QIODevice::WriteOnly)) {
    qDebug() << tar.isOpen();

    //write our json data to the archive
    tar.writeFile("servicelist.json",
                  jsonText.toJson());

    //let's add the backgrounds and audios to the archive
    for (int i = 0; i < m_items.size(); i++) {
      qDebug() << m_items[i]->name();
      QString background = m_items[i]->background();
      QString backgroundFile = background.right(background.size() - 5);
      qDebug() << backgroundFile;
      QString audio = m_items[i]->audio();
      QString audioFile = audio.right(audio.size() - 5);
      qDebug() << audioFile;

      //here we need to cut off all the directories before
      //adding into the archive
      tar.addLocalFile(backgroundFile,
                       backgroundFile.right(backgroundFile.size() -
                                            backgroundFile.lastIndexOf("/") - 1));
      tar.addLocalFile(audioFile,
                       audioFile.right(audioFile.size() -
                                       audioFile.lastIndexOf("/") - 1));
    }

    //close the archive so that everything is done
    tar.close();

    QSettings settings;
    settings.setValue("lastSaveFile", file);

    settings.sync();

    qDebug() << settings.value("lastSaveFile");
    return true;
  }

  
  return false;
}

bool ServiceItemModel::load(QUrl file) {
  qDebug() << "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@";
  qDebug() << "Loading...";
  qDebug() << "File path is: " << file.toString();
  qDebug() << "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@";


  QString fileUrl = file.toString().right(file.toString().size() - 7);
  KTar tar(fileUrl);

  if (tar.open(QIODevice::ReadOnly)){
    qDebug() << tar.isOpen();
    const KArchiveDirectory *dir = tar.directory();

    const KArchiveEntry *e = dir->entry("servicelist.json");
    if (!e) {
      qDebug() << "File not found!";
    }
    const KArchiveFile *f = static_cast<const KArchiveFile *>(e);
    QByteArray arr(f->data());
    QJsonDocument jsonText = QJsonDocument::fromJson(arr);
    qDebug() << jsonText; // the file contents

    QJsonArray array = jsonText.array();

    QVariantList serviceList = array.toVariantList();
    qDebug() << serviceList;

    // now lets remove all items from current list and add loaded ones
    clearAll();

    for (int i = 0; i < serviceList.length(); i++) {
      // int id = serviceList
      qDebug() << "*********************************";
      qDebug() << serviceList[i].toMap();
      qDebug() << "*********************************";

      QMap item = serviceList[i].toMap();

      QString backgroundString = item.value("background").toString();
      QFileInfo backgroundFile = backgroundString.right(backgroundString.size() - 7);

      QString audioString = item.value("audio").toString();
      QFileInfo audioFile = audioString.right(audioString.size() - 7);

      qDebug() << "POOPPOPOPOPOPOPOPOPOPOPOPOPO";
      qDebug() << backgroundFile;
      qDebug() << backgroundFile.exists();
      qDebug() << audioFile;
      qDebug() << audioFile.exists();
      qDebug() << "POOPPOPOPOPOPOPOPOPOPOPOPOPO";

      QString realBackground;
      QString realAudio;

      QFileInfo serviceFile = file.toString().right(file.toString().size() - 7);
      QString serviceName = serviceFile.baseName();
      QDir localDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
      localDir.mkdir(serviceName);
      QDir serviceDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation)
        + "/" + serviceName;
      qDebug() << serviceDir.path();

      realBackground = backgroundString;
      realAudio = audioString;
      // If the background file is on disk use that, else use the one in archive
      if (!backgroundFile.exists() && backgroundString.length() > 0) {
        const KArchiveEntry *e = dir->entry(backgroundFile.fileName());
        if (!e) {
          qDebug() << "Background File not found!";
          continue;
        }
        const KArchiveFile *f = static_cast<const KArchiveFile *>(e);
        if (!f->copyTo(serviceDir.path()))
          qDebug() << "FILE COULDN'T BE CREATED!";

        QFileInfo bgFile = serviceDir.path() + "/" + backgroundFile.fileName();

        qDebug() << bgFile.filePath();

        realBackground = bgFile.filePath();
      }

      // If the audio file is on disk use that, else use the one in archive
      if (!audioFile.exists() && audioString.length() > 0) {
        const KArchiveEntry *e = dir->entry(audioFile.fileName());
        if (!e) {
          qDebug() << "Audio File not found!";
          continue;
        }
        const KArchiveFile *f = static_cast<const KArchiveFile *>(e);
        if (!f->copyTo(serviceDir.path()))
          qDebug() << "FILE COULDN'T BE CREATED!";

        QFileInfo audFile = serviceDir.path() + "/" + audioFile.fileName();

        qDebug() << audFile.filePath();

        realAudio = audFile.filePath();
      }

      insertItem(i, item.value("name").toString(), item.value("type").toString(),
                 realBackground,
                 item.value("backgroundType").toString(),
                 item.value("text").toStringList(), realAudio,
                 item.value("font").toString(), item.value("fontSize").toInt());
    }

    return true;

  }

  return false;
}

void ServiceItemModel::clearAll() {
  for (int i = m_items.size(); i >= 0; i--) {
    removeItem(i);
  }
}

bool ServiceItemModel::loadLastSaved() {
  QSettings settings;
  return load(settings.value("lastSaveFile").toUrl());
}
