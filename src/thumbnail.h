#ifndef THUMBNAIL_H
#define THUMBNAIL_H

#include <QObject>
#include <qobject.h>

class Thumbnail : public QObject
{
  Q_OBJECT
  Q_PROPERTY(QString owner READ owner WRITE setOwner NOTIFY ownerChanged)
  Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeChanged)
  Q_PROPERTY(QString songVerse READ songVerse WRITE setSongVerse NOTIFY songVerseChanged)
  Q_PROPERTY(QString background READ background WRITE setBackground NOTIFY backgroundChanged)
  Q_PROPERTY(QString backgroundType READ backgroundType WRITE setBackgroundType NOTIFY backgroundTypeChanged)
  Q_PROPERTY(QStringList text READ text WRITE setText NOTIFY textChanged)
  Q_PROPERTY(QString font READ font WRITE setFont NOTIFY fontChanged)
  Q_PROPERTY(int fontSize READ fontSize WRITE setFontSize NOTIFY fontSizeChanged)

public:
  explicit Thumbnail(QObject *parent = nullptr);
  Thumbnail(const QString &owner, const QString &type, QObject * parent = nullptr);
  Thumbnail(const QString &owner, const QString &type, const QString &background,
            const QString &backgroundType, QObject * parent = nullptr);
  Thumbnail(const QString &owner, const QString &type, const QString &background,
            const QString &backgroundType, const QStringList &text,
            QObject * parent = nullptr);
  Thumbnail(const QString &owner, const QString &type, const QString &background,
            const QString &backgroundType, const QStringList &text,
            const QString &songVerse, QObject * parent = nullptr);
  Thumbnail(const QString &owner, const QString &type, const QString &background,
            const QString &backgroundType, const QStringList &text,
            const QString &songVerse, const QString &font,
            const int &fontSize, QObject * parent = nullptr);

  QString owner() const;
  QString type() const;
  QString songVerse() const;
  QString background() const;
  QString backgroundType() const;
  QStringList text() const;
  QString font() const;
  int fontSize() const;

  void setOwner(QString owner);
  void setType(QString type);
  void setSongVerse(QString songVerse);
  void setBackground(QString background);
  void setBackgroundType(QString backgroundType);
  void setText(QStringList text);
  void setFont(QString font);
  void setFontSize(int fontSize);

signals:
  void ownerChanged(QString owner);
  void typeChanged(QString type);
  void songVerseChanged(QString songVerse);
  void backgroundChanged(QString background);
  void backgroundTypeChanged(QString backgroundType);
  void textChanged(QStringList text);
  void fontChanged(QString font);
  void fontSizeChanged(int fontSize);

private:
  QString m_owner;
  QString m_type;
  QString m_songVerse;
  QString m_background;
  QString m_backgroundType;
  QStringList m_text;
  QString m_font;
  int m_fontSize;
};

#endif // THUMBNAIL_H
