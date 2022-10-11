#include "videosqlmodel.h"

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

static const char *videosTableName = "videos";

static void createVideoTable()
{
  if(QSqlDatabase::database().tables().contains(videosTableName)) {
    return;
  }

  QSqlQuery query;
  if (!query.exec("CREATE TABLE IF NOT EXISTS 'videos' ("
                  "  'id' INTEGER NOT NULL,"
                  "  'title' TEXT NOT NULL,"
                  "  'filePath' TEXT NOT NULL,"
                  "  'startTime' REAL,"
                  "  'endTime' REAL,"
                  "  'loop' BOOLEAN NOT NULL DEFAULT 0,"
                  "  PRIMARY KEY(id))")) {
    qFatal("Failed to query database: %s",
           qPrintable(query.lastError().text()));
  }
  qDebug() << query.lastQuery();
  qDebug() << "inserting into videos";

  query.exec("INSERT INTO videos (title, filePath) VALUES ('The Test', '/home/chris/nextcloud/tfc/openlp/videos/test.mp4')");
  qDebug() << query.lastQuery();
  query.exec("INSERT INTO videos (title, filePath) VALUES ('Sabbath', '/home/chris/nextcloud/tfc/openlp/videos/Sabbath.mp4')");

  query.exec("select * from videos");
  qDebug() << query.lastQuery();
}

VideoSqlModel::VideoSqlModel(QObject *parent) : QSqlTableModel(parent) {
  qDebug() << "creating video table";
  createVideoTable();
  setTable(videosTableName);
  setEditStrategy(QSqlTableModel::OnManualSubmit);
  // make sure to call select else the model won't fill
  select();
}

QVariant VideoSqlModel::data(const QModelIndex &index, int role) const {
  if (role < Qt::UserRole) {
    return QSqlTableModel::data(index, role);
  }

  // qDebug() << role;
  const QSqlRecord sqlRecord = record(index.row());
  return sqlRecord.value(role - Qt::UserRole);
}

QHash<int, QByteArray> VideoSqlModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[Qt::UserRole] = "id";
    names[Qt::UserRole + 1] = "title";
    names[Qt::UserRole + 2] = "filePath";
    names[Qt::UserRole + 3] = "startTime";
    names[Qt::UserRole + 4] = "endTime";
    names[Qt::UserRole + 5] = "loop";
    return names;
}

void VideoSqlModel::newVideo(const QUrl &filePath) {
  qDebug() << "adding new video";
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

void VideoSqlModel::deleteVideo(const int &row) {
  QSqlRecord recordData = record(row);
  if (recordData.isEmpty())
    return;

  removeRow(row);
  submitAll();
}

int VideoSqlModel::id() const {
  return m_id;
}

QString VideoSqlModel::title() const {
  return m_title;
}

void VideoSqlModel::setTitle(const QString &title) {
  if (title == m_title)
    return;
  
  m_title = title;

  select();
  emit titleChanged();
}

// This function is for updating the title from outside the delegate
void VideoSqlModel::updateTitle(const int &row, const QString &title) {
  qDebug() << "Row is " << row;
  QSqlQuery query("select id from videos");
  QList<int> ids;
  while (query.next()) {
    ids.append(query.value(0).toInt());
    // qDebug() << ids;
  }
  int id = ids.indexOf(row,0);

  QSqlRecord rowdata = record(id);
  qDebug() << rowdata;
  rowdata.setValue("title", title);
  setRecord(id, rowdata);
  qDebug() << rowdata;
  submitAll();
  emit titleChanged();
}

QUrl VideoSqlModel::filePath() const {
  return m_filePath;
}

void VideoSqlModel::setFilePath(const QUrl &filePath) {
  if (filePath == m_filePath)
    return;
  
  m_filePath = filePath;

  select();
  emit filePathChanged();
}

// This function is for updating the filepath from outside the delegate
void VideoSqlModel::updateFilePath(const int &row, const QUrl &filePath) {
  qDebug() << "Row is " << row;
  QSqlQuery query("select id from videos");
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


int VideoSqlModel::startTime() const {
  return m_startTime;
}

void VideoSqlModel::setStartTime(const int &startTime) {
  if (startTime == m_startTime)
    return;
  
  m_startTime = startTime;

  select();
  emit startTimeChanged();
}

// This function is for updating the title from outside the delegate
void VideoSqlModel::updateStartTime(const int &row, const int &startTime) {
  qDebug() << "Row is " << row;
  QSqlQuery query("select id from videos");
  QList<int> ids;
  while (query.next()) {
    ids.append(query.value(0).toInt());
    // qDebug() << ids;
  }
  int id = ids.indexOf(row,0);

  QSqlRecord rowdata = record(id);
  qDebug() << rowdata;
  rowdata.setValue("startTime", startTime);
  setRecord(id, rowdata);
  qDebug() << rowdata;
  submitAll();
  emit startTimeChanged();
}

int VideoSqlModel::endTime() const {
  return m_endTime;
}

void VideoSqlModel::setEndTime(const int &endTime) {
  if (endTime == m_endTime)
    return;
  
  m_endTime = endTime;

  select();
  emit endTimeChanged();
}

// This function is for updating the title from outside the delegate
void VideoSqlModel::updateEndTime(const int &row, const int &endTime) {
  qDebug() << "Row is " << row;
  QSqlQuery query("select id from videos");
  QList<int> ids;
  while (query.next()) {
    ids.append(query.value(0).toInt());
    // qDebug() << ids;
  }
  int id = ids.indexOf(row,0);

  QSqlRecord rowdata = record(id);
  qDebug() << rowdata;
  rowdata.setValue("endTime", endTime);
  setRecord(id, rowdata);
  qDebug() << rowdata;
  submitAll();
  emit endTimeChanged();
}

bool VideoSqlModel::loop() const {
  return m_loop;
}

void VideoSqlModel::setLoop(const bool &loop) {
  if (loop == m_loop)
    return;
  
  m_loop = loop;

  select();
  emit loopChanged();
}

// This function is for updating looping from outside the delegate
void VideoSqlModel::updateLoop(const int &row, const bool &loop) {
  qDebug() << "Row is " << row;
  QSqlQuery query("select id from videos");
  QList<int> ids;
  while (query.next()) {
    ids.append(query.value(0).toInt());
    // qDebug() << ids;
  }
  int id = ids.indexOf(row,0);

  QSqlRecord rowdata = record(id);
  qDebug() << rowdata;
  rowdata.setValue("loop", loop);
  setRecord(id, rowdata);
  qDebug() << rowdata;
  submitAll();
  emit loopChanged();
}

QVariantMap VideoSqlModel::getVideo(const int &row) {
  // qDebug() << "Row we are getting is " << row;
  // QVariantList video;
  // QSqlRecord rec = record(row);
  // qDebug() << rec.value("title");
  // video.append(rec.value("title"));
  // video.append(rec.value("filePath"));
  // return video;

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
