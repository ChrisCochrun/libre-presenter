#include "songsqlmodel.h"

#include <QDateTime>
#include <QDebug>
#include <QSqlError>
#include <QSqlRecord>
#include <QSqlQuery>
#include <QSql>
#include <QSqlDatabase>
#include <qabstractitemmodel.h>
#include <qdebug.h>
#include <qobjectdefs.h>
#include <qsqlrecord.h>

static const char *songsTableName = "songs";

static void createTable()
{
  if(QSqlDatabase::database().tables().contains(songsTableName)) {
    return;
  }

  QSqlQuery query;
  if (!query.exec("CREATE TABLE IF NOT EXISTS 'songs' ("
                  "  'title' TEXT NOT NULL,"
                  "  'lyrics' TEXT,"
                  "  'author' TEXT,"
                  "  'ccli' TEXT,"
                  "  'audio' TEXT,"
                  "  PRIMARY KEY(title))")) {
    qFatal("Failed to query database: %s",
           qPrintable(query.lastError().text()));
  }

  query.exec("INSERT INTO songs VALUES ('10,000 Reasons', '10,000 reasons for my heart to sing', 'Matt Redman', '13470183', '')");
  query.exec("INSERT INTO songs VALUES ('River', 'Im going down to the river', 'Jordan Feliz', '13470183', '')");
  query.exec("INSERT INTO songs VALUES ('Marvelous Light', 'Into marvelous light Im running', 'Chris Tomlin', '13470183', '')");

  // query.exec("select * from songs");
  // qDebug() << query.lastQuery();
}

SongSqlModel::SongSqlModel(QObject *parent)
    : QSqlTableModel(parent)
{
  createTable();
  setTable(songsTableName);
  setEditStrategy(QSqlTableModel::OnFieldChange);
  // make sure to call select else the model won't fill
  select();
}

QVariant SongSqlModel::data(const QModelIndex &index, int role) const {
  if (role < Qt::UserRole) {
    // qDebug() << role;
    return QSqlTableModel::data(index, role);
  }

  // qDebug() << role;
  const QSqlRecord sqlRecord = record(index.row());
  return sqlRecord.value(role - Qt::UserRole);
}

QHash<int, QByteArray> SongSqlModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[Qt::UserRole] = "title";
    names[Qt::UserRole + 1] = "lyrics";
    names[Qt::UserRole + 2] = "author";
    names[Qt::UserRole + 3] = "ccli";
    names[Qt::UserRole + 4] = "audio";
    return names;
}

QString SongSqlModel::title() const {
  return m_title;
}

void SongSqlModel::setTitle(const QString &title) {
  if (title == m_title)
    return;
  
  m_title = title;

  select();
  emit titleChanged();
}

QString SongSqlModel::author() const {
  return m_author;
}

void SongSqlModel::setAuthor(const QString &author) {
  if (author == m_author)
    return;
  
  m_author = author;

  select();
  emit authorChanged();
}

QString SongSqlModel::lyrics() const {
  return m_lyrics;
}

void SongSqlModel::setLyrics(const QString &lyrics) {
  if (lyrics == m_lyrics)
    return;
  
  m_lyrics = lyrics;

  select();
  emit lyricsChanged();
}

void SongSqlModel::setLyrics(const int &row, const QString &lyrics) {
  qDebug() << "Row is " << row;
  QSqlRecord rowdata = record(row);
  rowdata.setValue("lyrics", lyrics);
  setRecord(row, rowdata);
  submitAll();

  select();
  emit lyricsChanged();

}

QString SongSqlModel::ccli() const {
  return m_ccli;
}

void SongSqlModel::setCcli(const QString &ccli) {
  if (ccli == m_ccli)
    return;
  
  m_ccli = ccli;

  select();
  emit ccliChanged();
}

QString SongSqlModel::audio() const {
  return m_audio;
}

void SongSqlModel::setAudio(const QString &audio) {
  if (audio == m_audio)
    return;
  
  m_audio = audio;

  select();
  emit audioChanged();
}
