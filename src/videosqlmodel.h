#ifndef VIDEOSQLMODEL_H
#define VIDEOSQLMODEL_H

#include <QSqlTableModel>
#include <qobject.h>
#include <qobjectdefs.h>
#include <qqml.h>
#include <qurl.h>
#include <qvariant.h>

class VideoSqlModel : public QSqlTableModel
{
  Q_OBJECT
  Q_PROPERTY(int id READ id)
  Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
  Q_PROPERTY(QUrl filePath READ filePath WRITE setFilePath NOTIFY filePathChanged)
  QML_ELEMENT

public:
  VideoSqlModel(QObject *parent = 0);

  int id() const;
  QString title() const;
  QUrl filePath() const;

  void setTitle(const QString &title);
  void setFilePath(const QUrl &filePath);

  Q_INVOKABLE void updateTitle(const int &row, const QString &title);
  Q_INVOKABLE void updateFilePath(const int &row, const QUrl &filePath);

  Q_INVOKABLE void newVideo(const QUrl &filePath);
  Q_INVOKABLE void deleteVideo(const int &row);
  Q_INVOKABLE QVariantList getVideo(const int &row);

  QVariant data(const QModelIndex &index, int role) const override;
  QHash<int, QByteArray> roleNames() const override;

signals:
    void titleChanged();
    void filePathChanged();

private:
    int m_id;
    QString m_title;
    QUrl m_filePath;
};

#endif //SONGSQLMODEL_H
