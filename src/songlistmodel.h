#ifndef SONGLISTMODEL_H
#define SONGLISTMODEL_H

#include <QAbstractListModel>

struct Data {
  Data () {}
  Data ( const QString& title, const QString& lyrics, const QString& author,
         const QString& ccli, const QString& audio)
    : title(title), lyrics(lyrics), author(author), ccli(ccli), audio(audio) {}
  QString title;
  QString lyrics;
  QString author;
  QString ccli;
  QString audio;
};

class SongListModel : public QAbstractListModel
{
  Q_OBJECT

public:
  enum Roles {
    TitleRole = Qt::UserRole,
    LyricsRole,
    AuthorRole,
    CCLINumRole,
    AudioRole,
  };
  explicit SongListModel(QObject *parent = nullptr);

  // Basic functionality:
  int rowCount(const QModelIndex &parent = QModelIndex()) const override;

  QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

  QHash<int, QByteArray> roleNames() const override;


private:
  QVector< Data > m_data;

public slots:
  void lyricsSlides(QString lyrics);
};

#endif // SONGLISTMODEL_H
