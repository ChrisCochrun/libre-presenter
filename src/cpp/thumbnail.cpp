#include "thumbnail.h"
#include <QDebug>

Thumbnail::Thumbnail(QObject *parent)
  : QObject{parent}
{

}

Thumbnail::Thumbnail(const QString &owner, const QString &type, QObject *parent)
  : QObject(parent),m_owner(owner),m_type(type)
{

}

Thumbnail::Thumbnail(const QString &owner, const QString &type, const QString &background,
                         const QString &backgroundType, QObject *parent)
  : QObject(parent),m_owner(owner),m_type(type),m_background(background),
    m_backgroundType(backgroundType)
{

}

Thumbnail::Thumbnail(const QString &owner, const QString &type, const QString &background,
                         const QString &backgroundType, const QStringList &text,
                         QObject *parent)
  : QObject(parent),m_owner(owner),m_type(type),m_background(background),
    m_backgroundType(backgroundType),m_text(text)
{

}

Thumbnail::Thumbnail(const QString &owner, const QString &type, const QString &background,
                     const QString &backgroundType, const QStringList &text,
                     const QString &songVerse, QObject *parent)
  : QObject(parent),m_owner(owner),m_type(type),m_background(background),
    m_backgroundType(backgroundType),m_text(text),m_songVerse(songVerse)
{

}

Thumbnail::Thumbnail(const QString &owner, const QString &type, const QString &background,
                         const QString &backgroundType, const QStringList &text,
                         const QString &font, const int &fontSize, const QString &songVerse
                         QObject *parent)
  : QObject(parent),m_owner(owner),m_type(type),m_background(background),
    m_backgroundType(backgroundType),m_text(text),m_font(font),m_fontSize(fontSize),
    m_songVerse(songVerse)
{

}

QString Thumbnail::owner() const {
  return m_owner;
}

QString Thumbnail::type() const {
  return m_type;
}

QString Thumbnail::songVerse() const {
  return m_songVerse;
}

QString Thumbnail::background() const
{
  return m_background;
}

QString Thumbnail::backgroundType() const
{
  return m_backgroundType;
}

QStringList Thumbnail::text() const
{
  return m_text;
}

QString Thumbnail::font() const {
  return m_font;
}

int Thumbnail::fontSize() const {
  return m_fontSize;
}

void Thumbnail::setOwner(QString owner)
{
    if (m_owner == owner)
        return;

    m_owner = owner;
    emit ownerChanged(m_owner);
}

void Thumbnail::setType(QString type)
{
    if (m_type == type)
        return;

    m_type = type;
    emit typeChanged(m_type);
}

void Thumbnail::setSongVerse(QString songVerse)
{
    if (m_songVerse == songVerse)
        return;

    m_songVerse = songVerse;
    emit songVerseChanged(m_songVerse);
}

void Thumbnail::setBackground(QString background)
{
    if (m_background == background)
        return;

    m_background = background;
    emit backgroundChanged(m_background);
}

void Thumbnail::setBackgroundType(QString backgroundType)
{
    if (m_backgroundType == backgroundType)
        return;

    m_backgroundType = backgroundType;
    emit backgroundTypeChanged(m_backgroundType);
}

void Thumbnail::setText(QStringList text)
{
    if (m_text == text)
        return;

    m_text = text;
    emit textChanged(m_text);

}

void Thumbnail::setFont(QString font)
{
    if (m_font == font)
        return;

    m_font = font;
    emit fontChanged(m_font);
}

void Thumbnail::setFontSize(int fontSize)
{
    if (m_fontSize == fontSize)
        return;

    m_fontSize = fontSize;
    emit fontSizeChanged(m_fontSize);
}
