#ifndef VIDEOSQLMODEL_H
#define VIDEOSQLMODEL_H

#include <QSqlTableModel>
#include <QSortFilterProxyModel>
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
  Q_PROPERTY(int startTime READ startTime WRITE setStartTime NOTIFY startTimeChanged)
  Q_PROPERTY(int endTime READ endTime WRITE setEndTime NOTIFY endTimeChanged)
  Q_PROPERTY(bool loop READ loop WRITE setLoop NOTIFY loopChanged)
  QML_ELEMENT

public:
  VideoSqlModel(QObject *parent = 0);

  int id() const;
  QString title() const;
  QUrl filePath() const;
  int startTime() const;
  int endTime() const;
  bool loop() const;

  void setTitle(const QString &title);
  void setFilePath(const QUrl &filePath);
  void setStartTime(const int &startTime);
  void setEndTime(const int &endTime);
  void setLoop(const bool &loop);

  Q_INVOKABLE void updateTitle(const int &row, const QString &title);
  Q_INVOKABLE void updateFilePath(const int &row, const QUrl &filePath);
  Q_INVOKABLE void updateStartTime(const int &row, const int &startTime);
  Q_INVOKABLE void updateEndTime(const int &row, const int &endTime);
  Q_INVOKABLE void updateLoop(const int &row, const bool &loop);

  Q_INVOKABLE void newVideo(const QUrl &filePath);
  Q_INVOKABLE void deleteVideo(const int &row);
  Q_INVOKABLE QVariantMap getVideo(const int &row);

  QVariant data(const QModelIndex &index, int role) const override;
  QHash<int, QByteArray> roleNames() const override;

signals:
    void titleChanged();
    void filePathChanged();
    void loopChanged();
    void startTimeChanged();
    void endTimeChanged();

private:
    int m_id;
    QString m_title;
    QUrl m_filePath;
    int m_startTime;
    int m_endTime;
    bool m_loop;
};

class VideoProxyModel : public QSortFilterProxyModel
{
  Q_OBJECT
  Q_PROPERTY(VideoSqlModel *videoModel READ videoModel)

public:
  explicit VideoProxyModel(QObject *parent = nullptr);
  ~VideoProxyModel() = default;

  VideoSqlModel *videoModel();
  
public slots:
  Q_INVOKABLE QVariantMap getVideo(const int &row);
  Q_INVOKABLE void deleteVideo(const int &row);

private:
  VideoSqlModel *m_videoModel;
};

#endif //VIDEOSQLMODEL_H
