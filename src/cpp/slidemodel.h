#ifndef SLIDEMODEL_H
#define SLIDEMODEL_H

#include "slide.h"
#include <QAbstractListModel>
#include <qabstractitemmodel.h>
#include <qnamespace.h>
#include <qobjectdefs.h>
#include <qsize.h>

class SlideModel : public QAbstractListModel {
  Q_OBJECT

public:
  explicit SlideModel(QObject *parent = nullptr);

  enum Roles {
    TypeRole = Qt::UserRole,
    TextRole,
    AudioRole,
    ImageBackgroundRole,
    VideoBackgroundRole,
    HorizontalTextAlignmentRole,
    VerticalTextAlignmentRole,
    FontRole,
    FontSizeRole,
    ServiceItemIdRole,
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
  void addItem(Slide *item);
  void insertItem(const int &index, Slide *item);
  Q_INVOKABLE void addItem(const QString &name, const QString &type);
  Q_INVOKABLE void addItem(const QString &text, const QString &type,
                           const QString &imageBackground,
                           const QString &videoBackground);
  Q_INVOKABLE void addItem(const QString &text, const QString &type,
                           const QString &imageBackground,
                           const QString &videoBackground,
                           const QString &audio);
  Q_INVOKABLE void addItem(const QString &text, const QString &type,
                           const QString &imageBackground,
                           const QString &videoBackground,
                           const QString &audio,
                           const QString &font, const int &fontSize);
  Q_INVOKABLE void addItem(const QString &text, const QString &type,
                           const QString &imageBackground,
                           const QString &videoBackground,
                           const QString &audio,
                           const QString &font, const int &fontSize,
                           const QString &horizontalTextAlignment,
                           const QString &verticalTextAlignment);
  Q_INVOKABLE void addItem(const QString &text, const QString &type,
                           const QString &imageBackground,
                           const QString &videoBackground,
                           const QString &audio,
                           const QString &font, const int &fontSize,
                           const QString &horizontalTextAlignment,
                           const QString &verticalTextAlignment,
                           const int &serviceItemId);
  Q_INVOKABLE void insertItem(const int &index, const QString &text,
                              const QString &type);
  Q_INVOKABLE void insertItem(const int &index, const QString &text,
                              const QString &type, const QString &imageBackground,
                              const QString &videoBackground);
  Q_INVOKABLE void insertItem(const int &index, const QString &text,
                              const QString &type, const QString &imageBackground,
                              const QString &videoBackground,
                              const QString &audio);
  Q_INVOKABLE void insertItem(const int &index, const QString &text,
                              const QString &type, const QString &imageBackground,
                              const QString &videoBackground,
                              const QString &audio, const QString &font,
                              const int &fontSize);
  Q_INVOKABLE void insertItem(const int &index, const QString &text,
                              const QString &type, const QString &imageBackground,
                              const QString &videoBackground,
                              const QString &audio, const QString &font,
                              const int &fontSize,
                              const QString &horizontalTextAlignment,
                              const QString &verticalTextAlignment);
  Q_INVOKABLE void insertItem(const int &index, const QString &text,
                              const QString &type, const QString &imageBackground,
                              const QString &videoBackground,
                              const QString &audio, const QString &font,
                              const int &fontSize,
                              const QString &horizontalTextAlignment,
                              const QString &verticalTextAlignment,
                              const int &serviceItemId);
  Q_INVOKABLE void removeItem(int index);
  Q_INVOKABLE bool moveRows(int sourceIndex, int destIndex, int count);
  Q_INVOKABLE bool moveDown(int index);
  Q_INVOKABLE bool moveUp(int index);
  Q_INVOKABLE bool select(int id);
  Q_INVOKABLE bool activate(int id);
  Q_INVOKABLE bool deactivate(int id);
  Q_INVOKABLE QVariantMap getItem(int index) const;
  Q_INVOKABLE QVariantList getItems();
  Q_INVOKABLE void clearAll();

private:
  QList<Slide *> m_items;
};

#endif // SLIDEMODEL_H
