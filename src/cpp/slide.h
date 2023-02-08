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
  Q_PROPERTY(int serviceItemId READ serviceItemId WRITE setServiceItemId
             NOTIFY serviceItemIdChanged)
  Q_PROPERTY(QString audio READ audio WRITE setAudio NOTIFY audioChanged)
  Q_PROPERTY(QString imageBackground READ imageBackground WRITE setImageBackground
             NOTIFY imageBackgroundChanged)
  Q_PROPERTY(QString videoBackground READ videoBackground WRITE setVideoBackground
             NOTIFY videoBackgroundChanged)
  Q_PROPERTY(QString horizontalTextAlignment READ horizontalTextAlignment
             WRITE setHorizontalTextAlignment NOTIFY horizontalTextAlignmentChanged)
  Q_PROPERTY(QString verticalTextAlignment READ verticalTextAlignment
             WRITE setVerticalTextAlignment NOTIFY verticalTextAlignmentChanged)
  Q_PROPERTY(QString font READ font WRITE setFont NOTIFY fontChanged)
  Q_PROPERTY(int fontSize READ fontSize WRITE setFontSize NOTIFY fontSizeChanged)
  Q_PROPERTY(int imageCount READ imageCount WRITE setImageCount NOTIFY imageCountChanged)
  Q_PROPERTY(int slideIndex READ slideIndex WRITE setSlideIndex NOTIFY slideIndexChanged)
  Q_PROPERTY(bool active READ active WRITE setActive NOTIFY activeChanged)
  Q_PROPERTY(bool selected READ selected WRITE setSelected NOTIFY selectedChanged)
  Q_PROPERTY(QString vidThumbnail READ vidThumbnail WRITE setVidThumbnail
             NOTIFY vidThumbnailChanged)
  // QML_ELEMENT

public:
  explicit Slide(QObject *parent = nullptr);
  Slide(const QString &text, const QString &audio,
        const QString &imageBackground, const QString &videoBackground,
        const QString &horizontalTextAlignment, const QString &verticalTextAlignment,
        const QString &font, const int &fontSize, const int &imageCount,
        const QString &type, const int &slideIndex,
        QObject * parent = nullptr);

  QString text() const;
  QString type() const;
  QString audio() const;
  QString imageBackground() const;
  QString videoBackground() const;
  QString horizontalTextAlignment() const;
  QString verticalTextAlignment() const;
  QString font() const;
  int fontSize() const;
  int imageCount() const;
  int slideIndex() const;
  int serviceItemId() const;
  bool active() const;
  bool selected() const;
  QString vidThumbnail() const;

  Q_INVOKABLE void setText(QString text);
  Q_INVOKABLE void setType(QString type);
  Q_INVOKABLE void setServiceItemId(int serviceItemId);
  Q_INVOKABLE void setAudio(QString audio);
  Q_INVOKABLE void setImageBackground(QString imageBackground);
  Q_INVOKABLE void setVideoBackground(QString videoBackground);
  Q_INVOKABLE void setHorizontalTextAlignment(QString horizontalTextAlignment);
  Q_INVOKABLE void setVerticalTextAlignment(QString verticalTextAlignment);
  Q_INVOKABLE void setFont(QString font);
  Q_INVOKABLE void setFontSize(int fontSize);
  Q_INVOKABLE void setImageCount(int imageCount);
  Q_INVOKABLE void setSlideIndex(int slideIndex);
  Q_INVOKABLE void setActive(bool active);
  Q_INVOKABLE void setSelected(bool selected);
  Q_INVOKABLE void setVidThumbnail(QString vidThumbnail);

signals:
  Q_INVOKABLE void textChanged(QString text);
  Q_INVOKABLE void typeChanged(QString type);
  Q_INVOKABLE void serviceItemIdChanged(int serviceItemId);
  Q_INVOKABLE void audioChanged(QString audio);
  Q_INVOKABLE void imageBackgroundChanged(QString imageBackground);
  Q_INVOKABLE void videoBackgroundChanged(QString videoBackground);
  Q_INVOKABLE void horizontalTextAlignmentChanged(QString horizontalTextAlignment);
  Q_INVOKABLE void verticalTextAlignmentChanged(QString verticalTextAlignment);
  Q_INVOKABLE void fontChanged(QString font);
  Q_INVOKABLE void fontSizeChanged(int fontSize);
  Q_INVOKABLE void imageCountChanged(int imageCount);
  Q_INVOKABLE void slideIndexChanged(int slideIndex);
  Q_INVOKABLE void activeChanged(bool active);
  Q_INVOKABLE void selectedChanged(bool selected);
  Q_INVOKABLE void vidThumbnailChanged(QString vidThumbnail);

private:
  int m_id;
  QString m_text;
  QString m_type;
  int m_serviceItemId;
  QString m_audio;
  QString m_imageBackground;
  QString m_videoBackground;
  QString m_horizontalTextAlignment;
  QString m_verticalTextAlignment;
  QString m_font;
  int m_fontSize;
  int m_imageCount;
  int m_slideIndex;
  bool m_active;
  bool m_selected;
  QString m_vidThumbnail;
};

#endif //SLIDE_H
