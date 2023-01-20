#ifndef SLIDEOBJECT_H
#define SLIDEOBJECT_H

#include "serviceitemmodel.h"
#include "slide.h"
#include "slidemodel.h"
#include <qobjectdefs.h>
#include <qqml.h>
#include <QObject>
#include <qobject.h>

class SlideObject : public Slide
{
  Q_OBJECT
  Q_PROPERTY(bool isPlaying READ isPlaying NOTIFY isPlayingChanged)
  Q_PROPERTY(int slideIndex READ slideIndex NOTIFY slideIndexChanged)
  Q_PROPERTY(int slideSize READ slideSize NOTIFY slideSizeChanged)
  // QML_ELEMENT

public:
  explicit SlideObject(QObject *parent = nullptr);
  SlideObject(const QString &text, const QString &audio,
              const QString &imageBackground, const QString &videoBackground,
              const QString &horizontalTextAlignment, const QString &verticalTextAlignment,
              const QString &font, const int &fontSize, const int &imageCount,
              const bool &isPlaying, const QString &type,
              QObject * parent = nullptr);

  bool isPlaying() const;
  int slideIndex() const;
  int slideSize() const;

  Q_INVOKABLE void changeSlide(QVariantMap item);
  Q_INVOKABLE void play();
  Q_INVOKABLE void pause();
  Q_INVOKABLE void playPause();
  Q_INVOKABLE bool next(QVariantMap nextItem, SlideModel *slideModel);
  Q_INVOKABLE bool previous(QVariantMap prevItem, SlideModel *slideModel);
  Q_INVOKABLE bool changeSlideIndex(int index);

signals:
  Q_INVOKABLE void isPlayingChanged(bool isPlaying);
  Q_INVOKABLE void slideIndexChanged(int slideIndex);
  Q_INVOKABLE void slideSizeChanged(int slideSize);

private:
  bool m_isPlaying;
  int m_slideIndex;
  int m_slideSize;
};

#endif //SLIDEOBJECT_H
