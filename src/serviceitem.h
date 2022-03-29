#ifndef SERVICEITEM_H
#define SERVICEITEM_H

#include <QObject>
#include <qobject.h>

class ServiceItem : public QObject
{
  Q_OBJECT
  Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
  Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeChanged)
  Q_PROPERTY(QString background READ background WRITE setBackground NOTIFY backgroundChanged)
  Q_PROPERTY(QString backgroundType READ backgroundType WRITE setBackgroundType NOTIFY backgroundTypeChanged)
  Q_PROPERTY(QStringList text READ text WRITE setText NOTIFY textChanged)

public:
  explicit ServiceItem(QObject *parent = nullptr);
  ServiceItem(const QString &name, const QString &type, QObject * parent = nullptr);
  ServiceItem(const QString &name, const QString &type, const QString &background,
              const QString &backgroundType, QObject * parent = nullptr);
  ServiceItem(const QString &name, const QString &type, const QString &background,
              const QString &backgroundType, const QStringList &text, QObject * parent = nullptr);

  QString name() const;
  QString type() const;
  QString background() const;
  QString backgroundType() const;
  QStringList text() const;

  void setName(QString name);
  void setType(QString type);
  void setBackground(QString background);
  void setBackgroundType(QString backgroundType);
  void setText(QStringList text);

signals:
  void nameChanged(QString name);
  void typeChanged(QString type);
  void backgroundChanged(QString background);
  void backgroundTypeChanged(QString backgroundType);
  void textChanged(QStringList text);

private:
  QString m_name;
  QString m_type;
  QString m_background;
  QString m_backgroundType;
  QStringList m_text;
};

#endif // SERVICEITEM_H
