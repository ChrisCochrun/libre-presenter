#include "songtext.h"

SongText::SongText(QObject *parent) :
  QObject(parent)
{
}

QString SongText::songText()
{
  return m_songText;
}

void SongText::setSongText(const QString &songText)
{
  if (songText == m_songText)
    return;

  QTextStream stream(&songText);
  QString line = stream.readLine();
  qDebug() << line;

  m_songText = songText;
  emit songTextChanged();
}

