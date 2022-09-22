#include "pressqlmodel.h"

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

static const char *presTableName = "presentation";

static void createPresTable()
{
  if(QSqlDatabase::database().tables().contains(presTableName)) {
    return;
  }

  QSqlQuery query;
  if (!query.exec("CREATE TABLE IF NOT EXISTS 'presentations' ("
                  "  'id' INTEGER NOT NULL,"
                  "  'title' TEXT NOT NULL,"
                  "  'filePath' TEXT NOT NULL,"
                  "  PRIMARY KEY(id))")) {
    qFatal("Failed to query database: %s",
           qPrintable(query.lastError().text()));
  }
  qDebug() << query.lastQuery();
  qDebug() << "inserting into presentations";

  query.exec("INSERT INTO presentations (title, filePath) VALUES ('Dec 180', 'file:///home/chris/nextcloud/tfc/openlp/5 slides-2.pdf')");
  qDebug() << query.lastQuery();
  query.exec("INSERT INTO presentations (title, filePath) VALUES ('No TFC', "
             "'file:///home/chris/nextcloud/tfc/openlp/5 slides-1.pdf')");

  query.exec("select * from presentations");
  qDebug() << query.lastQuery();
}

PresSqlModel::PresSqlModel(QObject *parent) : QSqlTableModel(parent) {
  qDebug() << "creating pres table";
  createPresTable();
  setTable(pressTableName);
  setEditStrategy(QSqlTableModel::OnManualSubmit);
  // make sure to call select else the model won't fill
  select();
}

QVariant PresSqlModel::data(const QModelIndex &index, int role) const {
  if (role < Qt::UserRole) {
    return QSqlTableModel::data(index, role);
  }

  // qDebug() << role;
  const QSqlRecord sqlRecord = record(index.row());
  return sqlRecord.value(role - Qt::UserRole);
}

QHash<int, QByteArray> PresSqlModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[Qt::UserRole] = "id";
    names[Qt::UserRole + 1] = "title";
    names[Qt::UserRole + 2] = "filePath";
    return names;
}

void PresSqlModel::newPres(const QUrl &filePath) {
  qDebug() << "adding new pres";
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

void PresSqlModel::deletePres(const int &row) {
  QSqlRecord recordData = record(row);
  if (recordData.isEmpty())
    return;

  removeRow(row);
  submitAll();
}

int PresSqlModel::id() const {
  return m_id;
}

QString PresSqlModel::title() const {
  return m_title;
}

void PresSqlModel::setTitle(const QString &title) {
  if (title == m_title)
    return;
  
  m_title = title;

  select();
  emit titleChanged();
}

// This function is for updating the title from outside the delegate
void PresSqlModel::updateTitle(const int &row, const QString &title) {
  qDebug() << "Row is " << row;
  QSqlRecord rowdata = record(row);
  qDebug() << rowdata;
  rowdata.setValue("title", title);
  setRecord(row, rowdata);
  qDebug() << rowdata;
  submitAll();
  emit titleChanged();
}

QUrl PresSqlModel::filePath() const {
  return m_filePath;
}

void PresSqlModel::setFilePath(const QUrl &filePath) {
  if (filePath == m_filePath)
    return;
  
  m_filePath = filePath;

  select();
  emit filePathChanged();
}

// This function is for updating the filepath from outside the delegate
void PresSqlModel::updateFilePath(const int &row, const QUrl &filePath) {
  qDebug() << "Row is " << row;
  QSqlRecord rowdata = record(row);
  qDebug() << rowdata;
  rowdata.setValue("filePath", filePath);
  setRecord(row, rowdata);
  qDebug() << rowdata;
  submitAll();
  emit filePathChanged();
}

// Here we grab the presentation from it's row id
QVariantMap PresSqlModel::getPres(const int &row) {
  // qDebug() << "Row we are getting is " << row;
  // QUrl pres;
  // QSqlRecord rec = record(row);
  // qDebug() << rec.value("filePath").toUrl();
  // // pres.append(rec.value("title"));
  // // pres.append(rec.value("filePath"));
  // pres = rec.value("filePath").toUrl();
  // return pres;

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
