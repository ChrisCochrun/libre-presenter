#ifndef PRESENTATIONSQLMODEL_H
#define PRESENTATIONSQLMODEL_H

#include <QSqlTableModel>
#include <QSortFilterProxyModel>
#include <qobject.h>
#include <qobjectdefs.h>
#include <qqml.h>
#include <qurl.h>
#include <qvariant.h>

class PresentationSqlModel : public QSqlTableModel
{
  Q_OBJECT
  Q_PROPERTY(int id READ id)
  Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
  Q_PROPERTY(QUrl filePath READ filePath WRITE setFilePath NOTIFY filePathChanged)
  Q_PROPERTY(int pageCount READ pageCount WRITE setPageCount NOTIFY pageCountChanged)
  QML_ELEMENT

public:
  PresentationSqlModel(QObject *parent = 0);

  int id() const;
  QString title() const;
  QUrl filePath() const;
  int pageCount() const;

  void setTitle(const QString &title);
  void setFilePath(const QUrl &filePath);
  void setPageCount(const int &pageCount);

  Q_INVOKABLE void updateTitle(const int &row, const QString &title);
  Q_INVOKABLE void updateFilePath(const int &row, const QUrl &filePath);
  Q_INVOKABLE void updatePageCount(const int &row, const int &pageCount);

  Q_INVOKABLE void newPresentation(const QUrl &filePath, int pageCount);
  Q_INVOKABLE void deletePresentation(const int &row);
  Q_INVOKABLE QVariantMap getPresentation(const int &row);

  QVariant data(const QModelIndex &index, int role) const override;
  QHash<int, QByteArray> roleNames() const override;

signals:
    void titleChanged();
    void filePathChanged();
    void pageCountChanged();

private:
    int m_id;
    QString m_title;
    QUrl m_filePath;
    int m_pageCount;
};


class PresentationProxyModel : public QSortFilterProxyModel
{
  Q_OBJECT
  Q_PROPERTY(PresentationSqlModel *presentationModel READ presentationModel)

public:
  explicit PresentationProxyModel(QObject *parent = nullptr);
  ~PresentationProxyModel() = default;

  PresentationSqlModel *presentationModel();
  
public slots:
  Q_INVOKABLE QVariantMap getPresentation(const int &row);
  Q_INVOKABLE void deletePresentation(const int &row);

private:
  PresentationSqlModel *m_presentationModel;
};

#endif //PRESENTATIONSQLMODEL_H
