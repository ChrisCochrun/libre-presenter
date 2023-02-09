#include "slideobject.h"
#include "serviceitemmodel.h"
#include "slidemodel.h"

#include <podofo/podofo.h>
#include <QDebug>

using namespace PoDoFo;
SlideObject::SlideObject(QObject *parent)
  : Slide{parent}
{
  qDebug() << "Initializing slide";
}

SlideObject::SlideObject(const QString &text, const QString &audio,
                         const QString &imageBackground,
                         const QString &videoBackground,
                         const QString &horizontalTextAlignment,
                         const QString &verticalTextAlignment,
                         const QString &font,
                         const int &fontSize,
                         const int &imageCount,
                         const bool &isPlaying,
                         const QString &type,
                         QObject *parent)
: Slide(parent),
  m_isPlaying(isPlaying),
  m_slideIndex(0)
{
  setText(text);
  setAudio(audio),
  setImageBackground(imageBackground),
  setVideoBackground(videoBackground),
  setVerticalTextAlignment(verticalTextAlignment),
  setHorizontalTextAlignment(horizontalTextAlignment),
  setFont(font),
  setFontSize(fontSize),
  setImageCount(imageCount),
  setType(type),
  qDebug() << "Initializing slide with defaults";
}

bool SlideObject::isPlaying() const
{
  return m_isPlaying;
}

int SlideObject::slideIndex() const
{
  return m_slideIndex;
}

int SlideObject::slideSize() const
{
  return m_slideSize;
}

bool SlideObject::loop() const
{
  return m_loop;
}

void SlideObject::changeSlide(QVariantMap item, int index)
{
  // setServiceItem(item);
  // setType(serviceItemId().value("type").toString());
  // qDebug() << "#$% SLIDE TYPE: " << type() << " %$#";

  // // First let's clear the text and then set
  // // the size and index of a basic slide
  // // then we'll build the rest
  // setText("");
  // m_slideSize = 1;
  // m_slideIndex = 1;

  // qDebug() << serviceItemId().value("backgroundType").toString();
  // if (serviceItemId().value("backgroundType") == "image") {
  //   setImageBackground(serviceItemId().value("background").toString());
  //   setVideoBackground("");
  // } else {
  //   setVideoBackground(serviceItemId().value("background").toString());
  //   setImageBackground("");
  // }

  // setFont(serviceItemId().value("font").toString());
  // setFontSize(serviceItemId().value("fontSize").toInt());
  // setAudio("");

  // if (type() == "presentation") {
  //   qDebug() << "#$#$#$#$ THIS PDF $#$#$#$#";
  //   int pageCount;
  //   QString str = imageBackground().remove(0,6);
  //   qDebug() << str;
  //   std::string file = str.toStdString();
  //   // qDebug() << file;
  //   const char * doc = file.c_str();
  //   qDebug() << doc;
  //   try {
  //     PdfMemDocument pdf = PdfMemDocument(doc);
  //     pageCount = pdf.GetPageCount();
  //   } catch ( const PdfError & eCode ) {
  //     eCode.PrintErrorMsg();
  //     eCode.GetError();
  //     return;
  //   }
  //   setImageCount(pageCount);
  //   qDebug() << imageCount();
  //   m_slideSize = imageCount();
  // }

  // QStringList text = serviceItemId().value("text").toStringList();
  // if (type() == "song") {
  //   qDebug() << "TEXT LENGTH: " << text.length();
  //   m_slideSize = text.length();
  //   m_slideIndex = 1;
  //   setText(text[0]);
  //   setAudio(serviceItemId().value("audio").toString());
  // }

  // qDebug() << "MAP: " << serviceItemId().value("text");



  //New implementation
  // QVariantMap serviceItem = serviceItemModel->getItem(item.value("serviceItemId").toInt());
  if (item.value("text").toString() != text())
    setText(item.value("text").toString());
  if (item.value("type").toString() != type())
    setType(item.value("type").toString());
  if (item.value("audio").toString() != audio())
    setAudio(item.value("audio").toString());
  if (item.value("imageBackground").toString() != imageBackground())
    setImageBackground(item.value("imageBackground").toString());
  if (item.value("videoBackground").toString() != videoBackground()) {
    qDebug() << "Setting VIDEOBACKGROUND to:" << item.value("videoBackgroundl").toString();
    setVideoBackground(item.value("videoBackground").toString());
  }
  if (item.value("verticalTextAlignment").toString() != verticalTextAlignment())
    setVerticalTextAlignment(item.value("verticalTextAlignment").toString());
  if (item.value("horizontalTextAlignment").toString() != horizontalTextAlignment())
    setHorizontalTextAlignment(item.value("horizontalTextAlignment").toString());
  if (item.value("font").toString() != font())
    setFont(item.value("font").toString());
  if (item.value("fontSize").toInt() != fontSize())
    setFontSize(item.value("fontSize").toInt());

  setImageCount(item.value("imageCount").toInt());
  setSlideIndex(item.value("slideIndex").toInt());
  emit slideChanged(index);
  // m_slideSize = serviceItem.value("slideNumber").toInt();

  // emit slideSizeChanged(m_slideSize);
}

bool SlideObject::next(QVariantMap nextItem, SlideModel *slideModel)
{
  // qDebug() << "Starting to go to next item.";
  // qDebug() << "SlideObject Index: " << slideIndex() << " SlideObject Size: " << slideSize();
  // QStringList text = serviceItemId().value("text").toStringList();
  // if (slideIndex() == slideSize()) {
  //   // changeSlideObject(nextItem);
  //   return true;
  // }

  // qDebug() << type();
  // // since the string list is 0 indexed m_slideIndex actually
  // // maps to the next item.
  // if (type() == "song") {
  //   int nextTextIndex = slideIndex();
  //   qDebug() << nextTextIndex;
  //   qDebug() << text[nextTextIndex];
  //   setText(text[nextTextIndex]);
  //   m_slideSize++;
  //   emit slideIndexChanged(m_slideIndex);
  // }

  // if (type() == "presentation") {
  //   qDebug() << "prev slide index: " << slideIndex();
  //   m_slideIndex++;
  //   emit slideIndexChanged(m_slideIndex);
  //   qDebug() << "new slide index: " << slideIndex();
  // }

  //new implementation
  // QVariantMap serviceItem = serviceItemModel->getItem(nextItem.value("serviceItemId").toInt());
  setText(nextItem.value("text").toString());
  setType(nextItem.value("type").toString());
  setAudio(nextItem.value("audio").toString());
  setImageBackground(nextItem.value("imageBackground").toString());
  setVideoBackground(nextItem.value("videoBackground").toString());
  setVerticalTextAlignment(nextItem.value("verticalTextAlignment").toString());
  setHorizontalTextAlignment(nextItem.value("horizontalTextAlignment").toString());
  setFont(nextItem.value("font").toString());
  setFontSize(nextItem.value("fontSize").toInt());
  setImageCount(nextItem.value("imageCount").toInt());
  setSlideIndex(nextItem.value("slideIndex").toInt());
  // m_slideSize = serviceItem.value("slideNumber").toInt();


  // emit slideSizeChanged(m_slideSize);
  return false;
}

bool SlideObject::previous(QVariantMap prevItem, SlideModel *slideModel)
{
  // qDebug() << "Starting to go to previous item.";
  // qDebug() << "SlideObject Index: " << slideIndex() << " SlideObject Size: " << slideSize();
  // QStringList text = serviceItemId().value("text").toStringList();
  // if (slideIndex() == 1) {
  //   // changeSlideObject(prevItem);
  //   return true;
  // }

  // // since the string list is 0 indexed m_slideIndex actually
  // // maps to the next item. So the prev text is minus 2
  // if (type() == "song") {
  //   int prevTextIndex = slideIndex() - 2;
  //   qDebug() << prevTextIndex;
  //   qDebug() << text[prevTextIndex];
  //   setText(text[prevTextIndex]);
  //   m_slideIndex--;
  //   emit slideIndexChanged(m_slideIndex);
  // }

  // if (type() == "presentation") {
  //   qDebug() << "prev slide index: " << slideIndex();
  //   m_slideIndex--;
  //   emit slideIndexChanged(m_slideIndex);
  //   qDebug() << "new slide index: " << slideIndex();
  // }

  //new implementation
  // QVariantMap serviceItem = serviceItemModel->getItem(prevItem.value("serviceItemId").toInt());
  setText(prevItem.value("text").toString());
  setType(prevItem.value("type").toString());
  setAudio(prevItem.value("audio").toString());
  setImageBackground(prevItem.value("imageBackground").toString());
  setVideoBackground(prevItem.value("videoBackground").toString());
  setVerticalTextAlignment(prevItem.value("verticalTextAlignment").toString());
  setHorizontalTextAlignment(prevItem.value("horizontalTextAlignment").toString());
  setFont(prevItem.value("font").toString());
  setFontSize(prevItem.value("fontSize").toInt());
  setImageCount(prevItem.value("imageCount").toInt());
  setSlideIndex(prevItem.value("slideIndex").toInt());
  // m_slideSize = serviceItem.value("slideNumber").toInt();

  // emit slideSizeChanged(m_slideSize);
  return false;
}

bool SlideObject::changeSlideIndex(int index)
{
  qDebug() << "Starting to change slide index.";
  qDebug() << "SlideObject Index: " << slideIndex() << " SlideObject Size: " << slideSize();
  // QStringList text = serviceItemId().value("text").toStringList();
  if (index > slideSize() - 1 || index < 0) {
    qDebug() << "index is invalid: " << index;
    return false;
  }

  // since the string list is 0 indexed m_slideIndex actually
  // maps to the next item. So the prev text is minus 2
  if (type() == "song") {
    int textIndex = index;
    qDebug() << textIndex;
    // qDebug() << text[textIndex];
    // setText(text[textIndex]);
    m_slideIndex = index;
    emit slideIndexChanged(m_slideIndex);
    return true;
  }

  if (type() == "presentation") {
    qDebug() << "prev slide index: " << slideIndex();
    m_slideIndex = index;
    qDebug() << "new slide index: " << slideIndex();
    emit slideIndexChanged(m_slideIndex);
    return true;
  }
  return false;
}

void SlideObject::play()
{
  m_isPlaying = true;
  emit isPlayingChanged(m_isPlaying);
}

void SlideObject::setLoop()
{
  m_loop = true;
  emit loopChanged(m_loop);
}

void SlideObject::pause()
{
  m_isPlaying = false;
  emit isPlayingChanged(m_isPlaying);
}

void SlideObject::playPause()
{
  m_isPlaying = !m_isPlaying;
  emit isPlayingChanged(m_isPlaying);
}
