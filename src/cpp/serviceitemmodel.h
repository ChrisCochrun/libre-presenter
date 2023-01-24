#ifndef SERVICEITEMMODEL_H
#define SERVICEITEMMODEL_H

#include "serviceitem.h"
#include "slidemodel.h"
#include <QAbstractListModel>
#include <qabstractitemmodel.h>
#include <qnamespace.h>
#include <qobjectdefs.h>
#include <qsize.h>

class ServiceItemModel : public QAbstractListModel {
  Q_OBJECT

public:
  explicit ServiceItemModel(QObject *parent = nullptr);

  enum Roles {
    NameRole = Qt::UserRole,
    TypeRole,
    BackgroundRole,
    BackgroundTypeRole,
    TextRole,
    AudioRole,
    FontRole,
    FontSizeRole,
    SlideNumberRole,
    ActiveRole,
    SelectedRole
  };

  // Basic functionality:
  int rowCount(const QModelIndex &parent = QModelIndex()) const override;
  // int columnCount(const QModelIndex &parent = QModelIndex()) const override;
  QVariant data(const QModelIndex &index,
                int role = Qt::DisplayRole) const override;
  QHash<int, QByteArray> roleNames() const override;

  // Q_INVOKABLE int index(int row, int column,
  //                       const QModelIndex &parent = QModelIndex()) const override;
  // Q_INVOKABLE QModelIndex parent(const QModelIndex &index) const override;

  // Editable:
  bool setData(const QModelIndex &index, const QVariant &value,
               int role = Qt::EditRole) override;
  Qt::ItemFlags flags(const QModelIndex &index) const override;

  // Helper methods
  void addItem(ServiceItem *item);
  void insertItem(const int &index, ServiceItem *item);
  // Q_INVOKABLE void addItem(const QString &name, const QString &type);
  // // Q_INVOKABLE void addItem(const QString &name, const QString &type,
  // //                          const QString &background);
  // Q_INVOKABLE void addItem(const QString &name, const QString &type,
  //                          const QString &background,
  //                          const QString &backgroundType);
  // Q_INVOKABLE void addItem(const QString &name, const QString &type,
  //                          const QString &background,
  //                          const QString &backgroundType,
  //                          const QStringList &text);
  // Q_INVOKABLE void addItem(const QString &name, const QString &type,
  //                          const QString &background,
  //                          const QString &backgroundType,
  //                          const QStringList &text, const QString &audio);
  // Q_INVOKABLE void addItem(const QString &name, const QString &type,
  //                          const QString &background,
  //                          const QString &backgroundType,
  //                          const QStringList &text, const QString &audio,
  //                          const QString &font, const int &fontSize);
  Q_INVOKABLE void addItem(const QString &name, const QString &type,
                           const QString &background,
                           const QString &backgroundType,
                           const QStringList &text, const QString &audio,
                           const QString &font, const int &fontSize,
                           const int &slideNumber);
  // Q_INVOKABLE void insertItem(const int &index, const QString &name,
  //                             const QString &type);
  // Q_INVOKABLE void insertItem(const int &index, const QString &name,
  //                             const QString &type, const QString &background,
  //                             const QString &backgroundType);
  // Q_INVOKABLE void insertItem(const int &index, const QString &name,
  //                             const QString &type, const QString &background,
  //                             const QString &backgroundType, const QStringList &text);
  // Q_INVOKABLE void insertItem(const int &index, const QString &name,
  //                             const QString &type, const QString &background,
  //                             const QString &backgroundType, const QStringList &text,
  //                             const QString &audio);
  // Q_INVOKABLE void insertItem(const int &index, const QString &name,
  //                             const QString &type, const QString &background,
  //                             const QString &backgroundType, const QStringList &text,
  //                             const QString &audio, const QString &font, const int &fontSize);
  Q_INVOKABLE void insertItem(const int &index, const QString &name,
                              const QString &type, const QString &background,
                              const QString &backgroundType, const QStringList &text,
                              const QString &audio, const QString &font,
                              const int &fontSize, const int &slideNumber);
  Q_INVOKABLE void removeItem(int index);
  Q_INVOKABLE bool moveRows(int sourceIndex, int destIndex, int count);
  Q_INVOKABLE bool moveDown(int index);
  Q_INVOKABLE bool moveUp(int index);
  Q_INVOKABLE bool select(int id);
  Q_INVOKABLE bool selectItems(QVariantList items);
  Q_INVOKABLE bool activate(int id);
  Q_INVOKABLE bool deactivate(int id);
  Q_INVOKABLE QVariantMap getItem(int index) const;
  Q_INVOKABLE QVariantList getItems();
  Q_INVOKABLE void clearAll();

  Q_INVOKABLE bool save(QUrl file);
  Q_INVOKABLE bool load(QUrl file);
  Q_INVOKABLE bool loadLastSaved();

signals:
  void itemAdded(const int &, const ServiceItem &);
  void itemInserted(const int &, const ServiceItem &);
  void rowMoved(const int &, const int &, const ServiceItem &);

private:

  QList<ServiceItem *> m_items;
};

#endif // SERVICEITEMMODEL_H
