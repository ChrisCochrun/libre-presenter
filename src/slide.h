#ifndef SLIDE_H
#define SLIDE_H

#include <qobjectdefs.h>
#include <qqml.h>
#include <QObject>
#include <qobject.h>

class Slide : public QObject
{
  Q_OBJECT
  Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
  Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeChanged)
  Q_PROPERTY(QString audio READ audio WRITE setAudio NOTIFY audioChanged)
  Q_PROPERTY(QString imageBackground READ imageBackground WRITE setImageBackground NOTIFY imageBackgroundChanged)
  Q_PROPERTY(QString videoBackground READ videoBackground WRITE setVideoBackground NOTIFY videoBackgroundChanged)
  Q_PROPERTY(QString horizontalTextAlignment READ horizontalTextAlignment
             WRITE setHorizontalTextAlignment NOTIFY horizontalTextAlignmentChanged)
  Q_PROPERTY(QString verticalTextAlignment READ verticalTextAlignment
             WRITE setVerticalTextAlignment NOTIFY verticalTextAlignmentChanged)
  Q_PROPERTY(QString font READ font WRITE setFont NOTIFY fontChanged)
  Q_PROPERTY(int fontSize READ fontSize WRITE setFontSize NOTIFY fontSizeChanged)
  // QML_ELEMENT

public:
  explicit Slide(QObject *parent = nullptr);
  Slide(const QString &text, const QString &audio, const QString &imageBackground, const QString &videoBackground,
        const QString &horizontalTextAlignment, const QString &verticalTextAlignment,
        const QString &font, const int &fontSize, const QString &type, QObject * parent = nullptr);

  QString text() const;
  QString type() const;
  QString audio() const;
  QString imageBackground() const;
  QString videoBackground() const;
  QString horizontalTextAlignment() const;
  QString verticalTextAlignment() const;
  QString font() const;
  int fontSize() const;

  Q_INVOKABLE void setText(QString text);
  Q_INVOKABLE void setType(QString type);
  Q_INVOKABLE void setAudio(QString audio);
  Q_INVOKABLE void setImageBackground(QString imageBackground);
  Q_INVOKABLE void setVideoBackground(QString videoBackground);
  Q_INVOKABLE void setHorizontalTextAlignment(QString horizontalTextAlignment);
  Q_INVOKABLE void setVerticalTextAlignment(QString verticalTextAlignment);
  Q_INVOKABLE void setFont(QString font);
  Q_INVOKABLE void setFontSize(int fontSize);

  Q_INVOKABLE void changeSlide(QVariantMap item);
  Q_INVOKABLE void nextSlide();

signals:
    Q_INVOKABLE void textChanged(QString text);
    Q_INVOKABLE void typeChanged(QString type);
    Q_INVOKABLE void audioChanged(QString audio);
    Q_INVOKABLE void imageBackgroundChanged(QString imageBackground);
    Q_INVOKABLE void videoBackgroundChanged(QString videoBackground);
    Q_INVOKABLE void horizontalTextAlignmentChanged(QString horizontalTextAlignment);
    Q_INVOKABLE void verticalTextAlignmentChanged(QString verticalTextAlignment);
    Q_INVOKABLE void fontChanged(QString font);
    Q_INVOKABLE void fontSizeChanged(int fontSize);

private:
    int m_id;
    QString m_text;
    QString m_type;
    QString m_audio;
    QString m_imageBackground;
    QString m_videoBackground;
    QString m_horizontalTextAlignment;
    QString m_verticalTextAlignment;
    QString m_font;
    int m_fontSize;
};

#endif //SLIDE_H
