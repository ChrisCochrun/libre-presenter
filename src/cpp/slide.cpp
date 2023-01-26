#include "slide.h"
#include "serviceitemmodel.h"

#include <QDebug>

Slide::Slide(QObject *parent)
  : QObject{parent}
{
  qDebug() << "Initializing slide";
}

Slide::Slide(const QString &text, const QString &audio, const QString &imageBackground,
             const QString &videoBackground, const QString &horizontalTextAlignment,
             const QString &verticalTextAlignment, const QString &font,
             const int &fontSize, const int &imageCount,
             const QString &type, const int &slideIndex, QObject *parent)
  : QObject(parent),m_text(text),m_audio(audio),m_imageBackground(imageBackground),
    m_videoBackground(videoBackground),m_verticalTextAlignment(verticalTextAlignment),
    m_horizontalTextAlignment(horizontalTextAlignment),m_font(font),
    m_fontSize(fontSize),m_imageCount(imageCount),m_type(type),
    m_slideIndex(slideIndex),m_active(false),m_selected(false)
{
  qDebug() << "Initializing slide with defaults";
}

QString Slide::text() const {
  return m_text;
}

QString Slide::type() const {
  return m_type;
}

int Slide::serviceItemId() const {
  return m_serviceItemId;
}

QString Slide::audio() const {
  return m_audio;
}

QString Slide::imageBackground() const
{
  return m_imageBackground;
}

QString Slide::videoBackground() const
{
  return m_videoBackground;
}

QString Slide::horizontalTextAlignment() const
{
  return m_horizontalTextAlignment;
}

QString Slide::verticalTextAlignment() const
{
  return m_verticalTextAlignment;
}

QString Slide::font() const
{
  return m_font;
}

int Slide::fontSize() const
{
  return m_fontSize;
}

int Slide::imageCount() const
{
  return m_imageCount;
}

int Slide::slideIndex() const
{
  return m_slideIndex;
}

bool Slide::active() const {
  return m_active;
}

bool Slide::selected() const {
  return m_selected;
}

void Slide::setText(QString text)
{
    if (m_text == text)
        return;

    qDebug() << "####changing text to: " << text;
    m_text = text;
    emit textChanged(m_text);
}

void Slide::setType(QString type)
{
    if (m_type == type)
        return;

    qDebug() << "####changing type to: " << type;
    m_type = type;
    emit typeChanged(m_type);
}

void Slide::setServiceItemId(int serviceItemId)
{
    if (m_serviceItemId == serviceItemId)
        return;

    qDebug() << "####changing serviceItemId of slide:" << m_serviceItemId << "and" << m_slideIndex << "TO:" << serviceItemId;
    m_serviceItemId = serviceItemId;
    emit serviceItemIdChanged(m_serviceItemId);
}

void Slide::setAudio(QString audio)
{
    if (m_audio == audio)
        return;

    qDebug() << "####changing audio to: " << audio;
    m_audio = audio;
    emit audioChanged(m_audio);
}

void Slide::setImageBackground(QString imageBackground)
{
    if (m_imageBackground == imageBackground)
        return;

    qDebug() << "####changing image background to: " << imageBackground;
    m_imageBackground = imageBackground;
    emit imageBackgroundChanged(m_imageBackground);
}

void Slide::setVideoBackground(QString videoBackground)
{
    if (m_videoBackground == videoBackground)
        return;

    qDebug() << "####changing video background to: " << videoBackground;
    m_videoBackground = videoBackground;
    emit videoBackgroundChanged(m_videoBackground);
}

void Slide::setHorizontalTextAlignment(QString horizontalTextAlignment)
{
    if (m_horizontalTextAlignment == horizontalTextAlignment)
        return;

    m_horizontalTextAlignment = horizontalTextAlignment;
    emit horizontalTextAlignmentChanged(m_horizontalTextAlignment);
}

void Slide::setVerticalTextAlignment(QString verticalTextAlignment)
{
    if (m_verticalTextAlignment == verticalTextAlignment)
        return;

    m_verticalTextAlignment = verticalTextAlignment;
    emit verticalTextAlignmentChanged(m_verticalTextAlignment);
}

void Slide::setFont(QString font)
{
    if (m_font == font)
        return;

    m_font = font;
    emit fontChanged(m_font);
}

void Slide::setFontSize(int fontSize)
{
    if (m_fontSize == fontSize)
        return;

    m_fontSize = fontSize;
    emit fontSizeChanged(m_fontSize);
}

void Slide::setImageCount(int imageCount)
{
    if (m_imageCount == imageCount)
        return;

    qDebug() << "####changing imageCount to: " << imageCount;
    m_imageCount = imageCount;
    emit imageCountChanged(m_imageCount);
}

void Slide::setSlideIndex(int slideIndex)
{
    if (m_slideIndex == slideIndex)
        return;

    qDebug() << "####changing slideIndex to: " << slideIndex;
    m_slideIndex = slideIndex;
    emit slideIndexChanged(m_slideIndex);
}

void Slide::setActive(bool active)
{
  qDebug() << "::::::::::::::::::::";
  qDebug() << "CHANGE ME!";
  if (m_active == active)
    return;

  m_active = active;
  emit activeChanged(m_active);
}

void Slide::setSelected(bool selected)
{
    if (m_selected == selected)
        return;

    m_selected = selected;
    emit selectedChanged(m_selected);
}
