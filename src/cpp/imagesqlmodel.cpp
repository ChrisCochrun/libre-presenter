#include "imagesqlmodel.h"

#include <QDateTime>
#include <QDebug>
#include <QSqlError>
#include <QSqlRecord>
#include <QSqlQuery>
#include <QSql>
#include <QSqlDatabase>
#include <QFileInfo>
#include <qabstractitemmodel.h>
#include <qdebug.h>
#include <qnamespace.h>
#include <qobject.h>
#include <qobjectdefs.h>
#include <qsqlrecord.h>
#include <qurl.h>
#include <qvariant.h>

static const char *imagesTableName = "images";

static void createImageTable()
{
  if(QSqlDatabase::database().tables().contains(imagesTableName)) {
    return;
  }

  QSqlQuery query;
  if (!query.exec("CREATE TABLE IF NOT EXISTS 'images' ("
                  "  'id' INTEGER NOT NULL,"
                  "  'title' TEXT NOT NULL,"
                  "  'filePath' TEXT NOT NULL,"
                  "  PRIMARY KEY(id))")) {
    qFatal("Failed to query database: %s",
           qPrintable(query.lastError().text()));
  }
  qDebug() << query.lastQuery();
  qDebug() << "inserting into images";

  query.exec("INSERT INTO images (title, filePath) VALUES ('Dec 180', 'file:///home/chris/nextcloud/tfc/openlp/180-dec.png')");
  qDebug() << query.lastQuery();
  query.exec("INSERT INTO images (title, filePath) VALUES ('No TFC', "
             "'file:///home/chris/nextcloud/tfc/openlp/No TFC.png')");

  query.exec("select * from images");
  qDebug() << query.lastQuery();
}

ImageSqlModel::ImageSqlModel(QObject *parent) : QSqlTableModel(parent) {
  qDebug() << "creating image table";
  createImageTable();
  setTable(imagesTableName);
  setEditStrategy(QSqlTableModel::OnManualSubmit);
  // make sure to call select else the model won't fill
  select();
}

QVariant ImageSqlModel::data(const QModelIndex &index, int role) const {
  if (role < Qt::UserRole) {
    return QSqlTableModel::data(index, role);
  }

  // qDebug() << role;
  const QSqlRecord sqlRecord = record(index.row());
  return sqlRecord.value(role - Qt::UserRole);
}

QHash<int, QByteArray> ImageSqlModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[Qt::UserRole] = "id";
    names[Qt::UserRole + 1] = "title";
    names[Qt::UserRole + 2] = "filePath";
    return names;
}

void ImageSqlModel::newImage(const QUrl &filePath) {
  qDebug() << "adding new image";
  int rows = rowCount();

  qDebug() << rows;
  QSqlRecord recordData = record();
  QFileInfo fileInfo = filePath.toString();
  QString title = fileInfo.baseName();
  recordData.setValue("title", title);
  recordData.setValue("filePath", filePath);

  if (insertRecord(rows, recordData)) {
    submitAll();
  } else {
    qDebug() << lastError();
  };
}

void ImageSqlModel::deleteImage(const int &row) {
  QSqlRecord recordData = record(row);
  if (recordData.isEmpty())
    return;

  removeRow(row);
  submitAll();
}

int ImageSqlModel::id() const {
  return m_id;
}

QString ImageSqlModel::title() const {
  return m_title;
}

void ImageSqlModel::setTitle(const QString &title) {
  if (title == m_title)
    return;
  
  m_title = title;

  select();
  emit titleChanged();
}

// This function is for updating the title from outside the delegate
void ImageSqlModel::updateTitle(const int &row, const QString &title) {
  qDebug() << "Row is " << row;
  QSqlQuery query("select id from images");
  QList<int> ids;
  while (query.next()) {
    ids.append(query.value(0).toInt());
    // qDebug() << ids;
  }
  int id = ids.indexOf(row,0);

  QSqlRecord rowdata = record(id);
  // qDebug() << rowdata.value(0);
  rowdata.setValue("title", title);
  bool suc = setRecord(id, rowdata);
  qDebug() << "#############";
  qDebug() << rowdata.value("title");
  qDebug() << "was it successful? " << suc;
  qDebug() << "#############";
  bool suca = submitAll();
  // qDebug() << suca;
  emit titleChanged();
}

QUrl ImageSqlModel::filePath() const {
  return m_filePath;
}

void ImageSqlModel::setFilePath(const QUrl &filePath) {
  if (filePath == m_filePath)
    return;
  
  m_filePath = filePath;

  select();
  emit filePathChanged();
}

// This function is for updating the filepath from outside the delegate
void ImageSqlModel::updateFilePath(const int &row, const QUrl &filePath) {
  qDebug() << "Row is " << row;
  QSqlQuery query("select id from images");
  QList<int> ids;
  while (query.next()) {
    ids.append(query.value(0).toInt());
    // qDebug() << ids;
  }
  int id = ids.indexOf(row,0);

  QSqlRecord rowdata = record(id);
  qDebug() << rowdata;
  rowdata.setValue("filePath", filePath);
  setRecord(id, rowdata);
  qDebug() << rowdata;
  submitAll();
  emit filePathChanged();
}

QVariantMap ImageSqlModel::getImage(const int &row) {
  // qDebug() << "Row we are getting is " << row;
  // QUrl image;
  // QSqlRecord rec = record(row);
  // qDebug() << rec.value("filePath").toUrl();
  // // image.append(rec.value("title"));
  // // image.append(rec.value("filePath"));
  // image = rec.value("filePath").toUrl();
  // return image;

  QVariantMap data;
  const QModelIndex idx = this->index(row,0);
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

// ImageProxyModel

ImageProxyModel::ImageProxyModel(QObject *parent)
  :QSortFilterProxyModel(parent)
{
  m_imageModel = new ImageSqlModel;
  setSourceModel(m_imageModel);
  setDynamicSortFilter(true);
  setFilterRole(Qt::UserRole + 1);
  setFilterCaseSensitivity(Qt::CaseInsensitive);
}

ImageSqlModel *ImageProxyModel::imageModel() {
  return m_imageModel;
}

QModelIndex ImageProxyModel::idx(int row) {
  QModelIndex idx = index(row, 0);
  // qDebug() << idx;
  return idx;
}

QVariantMap ImageProxyModel::getImage(const int &row) {
  return QVariantMap();
}

void ImageProxyModel::deleteImage(const int &row) {
  auto model = qobject_cast<ImageSqlModel *>(sourceModel());
  model->deleteImage(row);
}
