#ifndef IMAGESQLMODEL_H
#define IMAGESQLMODEL_H

#include <QSqlTableModel>
#include <QSortFilterProxyModel>
#include <qobject.h>
#include <qobjectdefs.h>
#include <qqml.h>
#include <qurl.h>
#include <qvariant.h>

class ImageSqlModel : public QSqlTableModel
{
  Q_OBJECT
  Q_PROPERTY(int id READ id)
  Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
  Q_PROPERTY(QUrl filePath READ filePath WRITE setFilePath NOTIFY filePathChanged)
  QML_ELEMENT

public:
  ImageSqlModel(QObject *parent = 0);

  int id() const;
  QString title() const;
  QUrl filePath() const;

  void setTitle(const QString &title);
  void setFilePath(const QUrl &filePath);

  Q_INVOKABLE void updateTitle(const int &row, const QString &title);
  Q_INVOKABLE void updateFilePath(const int &row, const QUrl &filePath);

  Q_INVOKABLE void newImage(const QUrl &filePath);
  Q_INVOKABLE void deleteImage(const int &row);
  Q_INVOKABLE QVariantMap getImage(const int &row);

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

class ImageProxyModel : public QSortFilterProxyModel
{
  Q_OBJECT
  Q_PROPERTY(ImageSqlModel *imageModel READ imageModel)

public:
  explicit ImageProxyModel(QObject *parent = nullptr);
  ~ImageProxyModel() = default;

  ImageSqlModel *imageModel();
  Q_INVOKABLE QModelIndex idx(int row);
  
public slots:
  Q_INVOKABLE QVariantMap getImage(const int &row);
  Q_INVOKABLE void deleteImage(const int &row);
  Q_INVOKABLE void deleteImages(const QVector<int> &rows);

private:
  ImageSqlModel *m_imageModel;
};


#endif //IMAGESQLMODEL_H
