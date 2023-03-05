#ifndef SONGSQLMODEL_H
#define SONGSQLMODEL_H

#include <QSqlTableModel>
#include <QSortFilterProxyModel>
#include <QItemSelectionModel>
#include <qobjectdefs.h>
#include <qqml.h>
#include <qvariant.h>

class SongSqlModel : public QSqlTableModel
{
  Q_OBJECT
  Q_PROPERTY(int id READ id)
  Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
  Q_PROPERTY(QString lyrics READ lyrics WRITE setLyrics NOTIFY lyricsChanged)
  Q_PROPERTY(QString author READ author WRITE setAuthor NOTIFY authorChanged)
  Q_PROPERTY(QString ccli READ ccli WRITE setCcli NOTIFY ccliChanged)
  Q_PROPERTY(QString audio READ audio WRITE setAudio NOTIFY audioChanged)
  Q_PROPERTY(QString vorder READ vorder WRITE setVerseOrder NOTIFY vorderChanged)
  Q_PROPERTY(QString background READ background WRITE setBackground NOTIFY backgroundChanged)
  Q_PROPERTY(QString backgroundType READ backgroundType WRITE setBackgroundType NOTIFY backgroundTypeChanged)
  Q_PROPERTY(QString horizontalTextAlignment READ horizontalTextAlignment WRITE setHorizontalTextAlignment NOTIFY horizontalTextAlignmentChanged)
  Q_PROPERTY(QString verticalTextAlignment READ verticalTextAlignment WRITE setVerticalTextAlignment NOTIFY verticalTextAlignmentChanged)
  Q_PROPERTY(QString font READ font WRITE setFont NOTIFY fontChanged)
  Q_PROPERTY(int fontSize READ fontSize WRITE setFontSize NOTIFY fontSizeChanged)
  QML_ELEMENT

public:
  SongSqlModel(QObject *parent = 0);

  int id() const;
  QString title() const;
  QString lyrics() const;
  QString author() const;
  QString ccli() const;
  QString audio() const;
  QString vorder() const;
  QString background() const;
  QString backgroundType() const;
  QString horizontalTextAlignment() const;
  QString verticalTextAlignment() const;
  QString font() const;
  int fontSize() const;

  void setTitle(const QString &title);
  void setLyrics(const QString &lyrics);
  void setAuthor(const QString &author);
  void setCcli(const QString &ccli);
  void setAudio(const QString &audio);
  void setVerseOrder(const QString &vorder);
  void setBackground(const QString &background);
  void setBackgroundType(const QString &backgroundType);
  void setHorizontalTextAlignment(const QString &horizontalTextAlignment);
  void setVerticalTextAlignment(const QString &verticalTextAlignment);
  void setFont(const QString &font);
  void setFontSize(const int &fontSize);

  Q_INVOKABLE void updateTitle(const int &row, const QString &title);
  Q_INVOKABLE void updateLyrics(const int &row, const QString &lyrics);
  Q_INVOKABLE void updateAuthor(const int &row, const QString &author);
  Q_INVOKABLE void updateCcli(const int &row, const QString &ccli);
  Q_INVOKABLE void updateAudio(const int &row, const QString &audio);
  Q_INVOKABLE void updateVerseOrder(const int &row, const QString &vorder);
  Q_INVOKABLE void updateBackground(const int &row, const QString &background);
  Q_INVOKABLE void updateBackgroundType(const int &row, const QString &backgroundType);
  Q_INVOKABLE void updateHorizontalTextAlignment(const int &row,
                                                 const QString &horizontalTextAlignment);
  Q_INVOKABLE void updateVerticalTextAlignment(const int &row,
                                               const QString &horizontalTextAlignment);
  Q_INVOKABLE void updateFont(const int &row, const QString &font);
  Q_INVOKABLE void updateFontSize(const int &row, const int &fontSize);
  Q_INVOKABLE QModelIndex idx(int row);

  Q_INVOKABLE void newSong();
  Q_INVOKABLE void deleteSong(const int &row);
  Q_INVOKABLE QVariantMap getSong(const int &row);
  Q_INVOKABLE QStringList getLyricList(const int &row);

  QVariant data(const QModelIndex &index, int role) const override;
  QHash<int, QByteArray> roleNames() const override;

signals:
    void titleChanged();
    void lyricsChanged();
    void authorChanged();
    void ccliChanged();
    void audioChanged();
    void vorderChanged();
    void backgroundChanged();
    void backgroundTypeChanged();
    void horizontalTextAlignmentChanged();
    void verticalTextAlignmentChanged();
    void fontChanged();
    void fontSizeChanged();

private:
    int m_id;
    QString m_title;
    QString m_lyrics;
    QString m_author;
    QString m_ccli;
    QString m_audio;
    QString m_vorder;
    QString m_background;
    QString m_backgroundType;
    QString m_horizontalTextAlignment;
    QString m_verticalTextAlignment;
    QString m_font;
    int m_fontSize;
};

class SongProxyModel : public QSortFilterProxyModel
{
  Q_OBJECT
  Q_PROPERTY(SongSqlModel *songModel READ songModel)
  // Q_PROPERTY(bool hasSelection READ hasSelection NOTIFY selectedChanged)

public:
  explicit SongProxyModel(QObject *parent = nullptr);
  ~SongProxyModel() = default;

  SongSqlModel *songModel();
  Q_INVOKABLE QModelIndex idx(int row);
  Q_INVOKABLE QModelIndex modelIndex(int row);
  // Q_INVOKABLE bool selected(const int &row);
  
  // QVariant data(const QModelIndex &index, int role) const override;
  // QHash<int, QByteArray> roleNames() const override;

public slots:
  Q_INVOKABLE QVariantMap getSong(const int &row);
  Q_INVOKABLE void deleteSong(const int &row);
  Q_INVOKABLE void deleteSongs(const QVector<int> &rows);
  Q_INVOKABLE QStringList getLyricList(const int &row);
  // Q_INVOKABLE void select(int row);
  // Q_INVOKABLE void selectSongs(int row);
  // Q_INVOKABLE bool setSelected(const int &row, const bool &select);
  // Q_INVOKABLE bool hasSelection();

signals:
  // Q_INVOKABLE void selectedChanged(bool selected);

private:
  SongSqlModel *m_songModel;
  // QItemSelectionModel *m_selectionModel;
  // bool m_selected;
};

#endif //SONGSQLMODEL_H
