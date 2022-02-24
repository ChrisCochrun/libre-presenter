#ifndef SONGSQLMODEL_H
#define SONGSQLMODEL_H

#include <QSqlTableModel>
#include <qabstractitemmodel.h>
#include <qqml.h>
#include <qvariant.h>

class SongSqlModel : public QSqlTableModel
{
  Q_OBJECT
  Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
  Q_PROPERTY(QString lyrics READ lyrics WRITE setLyrics NOTIFY lyricsChanged)
  Q_PROPERTY(QString author READ author WRITE setAuthor NOTIFY authorChanged)
  Q_PROPERTY(QString ccli READ ccli WRITE setCcli NOTIFY ccliChanged)
  Q_PROPERTY(QString audio READ audio WRITE setAudio NOTIFY audioChanged)
  QML_ELEMENT

public:
  SongSqlModel(QObject *parent = 0);

  QString title() const;
  QString lyrics() const;
  QString author() const;
  QString ccli() const;
  QString audio() const;

  void setTitle(const QString &title);
  void setLyrics(const QString &lyrics);
  void setLyrics(const int &row, const QString &lyrics);
  void setAuthor(const QString &author);
  void setCcli(const QString &ccli);
  void setAudio(const QString &audio);

  QVariant data(const QModelIndex &index, int role) const override;
  QHash<int, QByteArray> roleNames() const override;

signals:
    void titleChanged();
    void lyricsChanged();
    void authorChanged();
    void ccliChanged();
    void audioChanged();

private:
    QString m_title;
    QString m_lyrics;
    QString m_author;
    QString m_ccli;
    QString m_audio;
};

#endif //SONGSQLMODEL_H
