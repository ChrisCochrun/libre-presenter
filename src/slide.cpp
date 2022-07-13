#include "slide.h"

#include <QDebug>

Slide::Slide(QObject *parent)
  : QObject{parent}
{
  qDebug() << "Initializing slide";
}

Slide::Slide(const QString &text, const QString &audio, const QString &imageBackground,
             const QString &videoBackground, const QString &horizontalTextAlignment,
             const QString &verticalTextAlignment, const QString &font,
             const int &fontSize, QObject *parent)
  : QObject(parent),m_text(text),m_audio(audio),m_imageBackground(imageBackground),
    m_videoBackground(videoBackground),m_verticalTextAlignment(verticalTextAlignment),
    m_horizontalTextAlignment(horizontalTextAlignment),m_font(font),m_fontSize(fontSize)
{
  qDebug() << "Initializing slide with defaults";
  qDebug() << m_imageBackground;
}

QString Slide::text() const {
  return m_text;
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

void Slide::setText(QString text)
{
    if (m_text == text)
        return;

    qDebug() << "####changing text to: " << text;
    m_text = text;
    emit textChanged(m_text);
}

void Slide::setAudio(QString audio)
{
    if (m_audio == audio)
        return;

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
