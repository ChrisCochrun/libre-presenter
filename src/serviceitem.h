#ifndef SERVICEITEM_H
#define SERVICEITEM_H

#include <QAbstractListModel>
#include <qnamespace.h>

struct Data {
  Data() {}
  Data( const QString& name,
        const QString& type,
        const QString& background,
        const QString& backgroundType,
        const QStringList& text)
    : name(name), type(type), background(background),
      backgroundType(backgroundType), text(text) {}
  QString name;
  QString type;
  QString background;
  QString backgroundType;
  QStringList text;
};

class ServiceItem : public QAbstractListModel
{
  Q_OBJECT

public:
  explicit ServiceItem(QObject *parent = nullptr);

  enum Roles {
    NameRole = Qt::UserRole,
    TypeRole,
    BackgroundRole,
    BackgroundTypeRole,
    TextRole,
    SlidesRole
  };

  // Basic functionality:
  int rowCount(const QModelIndex &parent = QModelIndex()) const override;
  QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
  QHash<int, QByteArray> roleNames() const override;

  // Editable:
  bool setData(const QModelIndex &index, const QVariant &value,
               int role = Qt::EditRole) override;

  Qt::ItemFlags flags(const QModelIndex& index) const override;

private:
  QVector<Data> m_data;
};

#endif // SERVICEITEM_H
