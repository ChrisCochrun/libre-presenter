#ifndef SERVICEITEM_H
#define SERVICEITEM_H

#include <QObject>
#include <qobject.h>
#include "thumbnail.h"

class ServiceItem : public QObject
{
  Q_OBJECT
  Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
  Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeChanged)
  Q_PROPERTY(QString background READ background WRITE setBackground NOTIFY backgroundChanged)
  Q_PROPERTY(QString backgroundType READ backgroundType WRITE setBackgroundType NOTIFY backgroundTypeChanged)
  Q_PROPERTY(QStringList text READ text WRITE setText NOTIFY textChanged)
  Q_PROPERTY(QString audio READ audio WRITE setAudio NOTIFY audioChanged)
  Q_PROPERTY(QString font READ font WRITE setFont NOTIFY fontChanged)
  Q_PROPERTY(int fontSize READ fontSize WRITE setFontSize NOTIFY fontSizeChanged)
  Q_PROPERTY(bool active READ active WRITE setActive NOTIFY activeChanged)
  Q_PROPERTY(bool selected READ selected WRITE setSelected NOTIFY selectedChanged)
  // Q_PROPERTY(Thumbnail thumbnail READ thumbnail WRITE setThumbnail NOTIFY thumbnailChanged)

public:
  explicit ServiceItem(QObject *parent = nullptr);
  ServiceItem(const QString &name, const QString &type, QObject * parent = nullptr);
  ServiceItem(const QString &name, const QString &type, const QString &background,
              const QString &backgroundType, QObject * parent = nullptr);
  ServiceItem(const QString &name, const QString &type, const QString &background,
              const QString &backgroundType, const QStringList &text,
              QObject * parent = nullptr);
  ServiceItem(const QString &name, const QString &type, const QString &background,
              const QString &backgroundType, const QStringList &text, const QString &audio,
              QObject * parent = nullptr);
  ServiceItem(const QString &name, const QString &type, const QString &background,
              const QString &backgroundType, const QStringList &text, const QString &audio,
              const QString &font, const int &fontSize, QObject * parent = nullptr);

  QString name() const;
  QString type() const;
  QString background() const;
  QString backgroundType() const;
  QStringList text() const;
  QString audio() const;
  QString font() const;
  int fontSize() const;
  bool active() const;
  bool selected() const;
  // Thumbnail thumbnail() const;

  void setName(QString name);
  void setType(QString type);
  void setBackground(QString background);
  void setBackgroundType(QString backgroundType);
  void setText(QStringList text);
  void setAudio(QString audio);
  void setFont(QString font);
  void setFontSize(int fontSize);
  void setActive(bool active);
  void setSelected(bool selected);

signals:
  void nameChanged(QString name);
  void typeChanged(QString type);
  void backgroundChanged(QString background);
  void backgroundTypeChanged(QString backgroundType);
  void textChanged(QStringList text);
  void audioChanged(QString audio);
  void fontChanged(QString font);
  void fontSizeChanged(int fontSize);
  void activeChanged(bool active);
  void selectedChanged(bool selected);

private:
  QString m_name;
  QString m_type;
  QString m_background;
  QString m_backgroundType;
  QStringList m_text;
  QString m_audio;
  QString m_font;
  int m_fontSize;
  bool m_active;
  bool m_selected;
};

#endif // SERVICEITEM_H
