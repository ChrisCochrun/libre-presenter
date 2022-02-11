#include "songlistmodel.h"

SongListModel::SongListModel(QObject *parent)
  : QAbstractListModel(parent)
{
  m_data
    << Data("10,000 Reasons", "10,000 reasons for my heart to sing", "Matt Redman", "13470183", "")
    << Data("Marvelous Light", "Into marvelous light I'm running", "Chris Tomlin", "13470183", "");
}

int SongListModel::rowCount(const QModelIndex &parent) const
{
  if (parent.isValid())
    return 0;
  return m_data.count();
}

QVariant SongListModel::data(const QModelIndex &index, int role) const
{
  if (!index.isValid())
    return QVariant();

  // this is the returning of song data
  const Data &data = m_data.at(index.row());
  if ( role == TitleRole )
    return data.title;
  else if (role == LyricsRole)
    return data.lyrics;
  else if (role == AuthorRole)
    return data.author;
  else if (role == CCLINumRole)
    return data.ccli;
  else if (role == AudioRole)
    return data.audio;
  else
    return QVariant();
}

QHash<int, QByteArray> SongListModel::roleNames() const
{
  static QHash<int, QByteArray> mapping {
    {TitleRole, "title"},
    {LyricsRole, "lyrics"},
    {AuthorRole, "author"},
    {CCLINumRole, "ccli"},
    {AudioRole, "audio"}
  };

  return mapping;
}
