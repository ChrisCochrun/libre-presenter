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
                  "  'id' INT NOT NULL,"
                  "  'title' TEXT NOT NULL,"
                  "  'lyrics' TEXT,"
                  "  'author' TEXT,"
                  "  'ccli' TEXT,"
                  "  'audio' TEXT,"
                  "  'vorder' TEXT,"
                  "  PRIMARY KEY(id))")) {
    qFatal("Failed to query database: %s",
           qPrintable(query.lastError().text()));
  }
  qDebug() << query.lastQuery();
  qDebug() << "inserting into songs";

  query.exec("INSERT INTO songs VALUES (1, '10,000 Reasons', '10,000 reasons for my heart to sing', 'Matt Redman', '13470183', '', '')");
  qDebug() << query.lastQuery();
  query.exec("INSERT INTO songs VALUES (2, 'River', 'Im going down to the river', 'Jordan Feliz', '13470183', '', '')");
  query.exec("INSERT INTO songs VALUES (3, 'Marvelous Light', 'Into marvelous "
             "light Im running', 'Chris Tomlin', '13470183', '', '')");

  query.exec("select * from songs");
  qDebug() << query.lastQuery();
}

SongSqlModel::SongSqlModel(QObject *parent)
    : QSqlTableModel(parent)
{
  qDebug() << "creating table";
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
    names[Qt::UserRole] = "id";
    names[Qt::UserRole + 1] = "title";
    names[Qt::UserRole + 2] = "lyrics";
    names[Qt::UserRole + 3] = "author";
    names[Qt::UserRole + 4] = "ccli";
    names[Qt::UserRole + 5] = "audio";
    names[Qt::UserRole + 6] = "vorder";
    return names;
}

void SongSqlModel::newSong() {
  qDebug() << "starting to add new song";
  int rows = rowCount();
  
  qDebug() << rows;
  QSqlRecord recorddata = record(rows);
  recorddata.setValue("id", rows + 1);
  recorddata.setValue("title", "new song");
  qDebug() << recorddata;

  if (insertRecord(rows, recorddata)) {
    submitAll();
    select();
  }else {
    qDebug() << lastError();
  }
}

int SongSqlModel::id() const {
  return m_id;
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

// This function is for updating the lyrics from outside the delegate
void SongSqlModel::updateTitle(const int &row, const QString &title) {
  qDebug() << "Row is " << row;
  QSqlRecord rowdata = record(row);
  rowdata.setValue("title", title);
  setRecord(row, rowdata);
  submitAll();

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

// This function is for updating the lyrics from outside the delegate
void SongSqlModel::updateAuthor(const int &row, const QString &author) {
  qDebug() << "Row is " << row;
  QSqlRecord rowdata = record(row);
  rowdata.setValue("author", author);
  setRecord(row, rowdata);
  submitAll();

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

// This function is for updating the lyrics from outside the delegate
void SongSqlModel::updateLyrics(const int &row, const QString &lyrics) {
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

// This function is for updating the lyrics from outside the delegate
void SongSqlModel::updateCcli(const int &row, const QString &ccli) {
  qDebug() << "Row is " << row;
  QSqlRecord rowdata = record(row);
  rowdata.setValue("ccli", ccli);
  setRecord(row, rowdata);
  submitAll();

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

// This function is for updating the lyrics from outside the delegate
void SongSqlModel::updateAudio(const int &row, const QString &audio) {
  qDebug() << "Row is " << row;
  QSqlRecord rowdata = record(row);
  rowdata.setValue("audio", audio);
  setRecord(row, rowdata);
  submitAll();

  select();
  emit audioChanged();
}

QString SongSqlModel::vorder() const { return m_vorder; }

void SongSqlModel::setVerseOrder(const QString &vorder) {
  if (vorder == m_vorder)
    return;

  m_vorder = vorder;

  select();
  emit vorderChanged();
}

// This function is for updating the lyrics from outside the delegate
void SongSqlModel::updateVerseOrder(const int &row, const QString &vorder) {
  qDebug() << "Row is " << row;
  QSqlRecord rowdata = record(row);
  rowdata.setValue("vorder", vorder);
  setRecord(row, rowdata);
  submitAll();

  select();
  emit vorderChanged();
}
