#ifndef SERVICEITEMMODEL_H
#define SERVICEITEMMODEL_H

#include "serviceitem.h"
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
    TextRole
  };

  // Basic functionality:
  int rowCount(const QModelIndex &parent = QModelIndex()) const override;
  QVariant data(const QModelIndex &index,
                int role = Qt::DisplayRole) const override;
  QHash<int, QByteArray> roleNames() const override;

  // Editable:
  bool setData(const QModelIndex &index, const QVariant &value,
               int role = Qt::EditRole) override;
  Qt::ItemFlags flags(const QModelIndex &index) const override;

  // Helper methods
  void addItem(ServiceItem *item);
  void insertItem(const int &index, ServiceItem *item);
  Q_INVOKABLE void addItem(const QString &name, const QString &type);
  // Q_INVOKABLE void addItem(const QString &name, const QString &type,
  //                          const QString &background);
  Q_INVOKABLE void addItem(const QString &name, const QString &type,
                           const QString &background,
                           const QString &backgroundType);
  Q_INVOKABLE void addItem(const QString &name, const QString &type,
                           const QString &background,
                           const QString &backgroundType,
                           const QStringList &text);
  Q_INVOKABLE void insertItem(const int &index, const QString &name,
                              const QString &type);
  Q_INVOKABLE void insertItem(const int &index, const QString &name,
                              const QString &type, const QString &background,
                              const QString &backgroundType);
  Q_INVOKABLE void insertItem(const int &index, const QString &name,
                              const QString &type, const QString &background,
                              const QString &backgroundType, const QStringList &text);
  Q_INVOKABLE void removeItem(int index);
  Q_INVOKABLE bool move(int sourceIndex, int destIndex);
  Q_INVOKABLE QVariantMap getItem(int index) const;

private:
  QList<ServiceItem *> m_items;
};

#endif // SERVICEITEMMODEL_H
