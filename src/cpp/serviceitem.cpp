#include "serviceitem.h"
#include <QDebug>

ServiceItem::ServiceItem(QObject *parent)
  : QObject{parent}
{

}

ServiceItem::ServiceItem(const QString &name, const QString &type, QObject *parent)
  : QObject(parent),m_name(name),m_type(type)
{

}

ServiceItem::ServiceItem(const QString &name, const QString &type, const QString &background,
                         const QString &backgroundType, QObject *parent)
  : QObject(parent),m_name(name),m_type(type),m_background(background),
    m_backgroundType(backgroundType)
{

}

ServiceItem::ServiceItem(const QString &name, const QString &type, const QString &background,
                         const QString &backgroundType, const QStringList &text,
                         QObject *parent)
  : QObject(parent),m_name(name),m_type(type),m_background(background),
    m_backgroundType(backgroundType),m_text(text)
{

}

ServiceItem::ServiceItem(const QString &name, const QString &type, const QString &background,
                         const QString &backgroundType, const QStringList &text,
                         const QString &audio, QObject *parent)
  : QObject(parent),m_name(name),m_type(type),m_background(background),
    m_backgroundType(backgroundType),m_text(text),m_audio(audio)
{

}

ServiceItem::ServiceItem(const QString &name, const QString &type, const QString &background,
                         const QString &backgroundType, const QStringList &text,
                         const QString &audio, const QString &font, const int &fontSize,
                         QObject *parent)
  : QObject(parent),m_name(name),m_type(type),m_background(background),
    m_backgroundType(backgroundType),m_text(text),m_audio(audio),m_font(font),m_fontSize(fontSize)
{

}

ServiceItem::ServiceItem(const QString &name, const QString &type, const QString &background,
                         const QString &backgroundType, const QStringList &text,
                         const QString &audio, const QString &font, const int &fontSize,
                         const int &slideNumber, QObject *parent)
  : QObject(parent),m_name(name),m_type(type),m_background(background),
    m_backgroundType(backgroundType),m_text(text),m_audio(audio),m_font(font),m_fontSize(fontSize),m_slideNumber(slideNumber)
{

}

QString ServiceItem::name() const {
  return m_name;
}

QString ServiceItem::type() const {
  return m_type;
}

QString ServiceItem::background() const
{
  return m_background;
}

QString ServiceItem::backgroundType() const
{
  return m_backgroundType;
}

QStringList ServiceItem::text() const
{
  return m_text;
}

QString ServiceItem::audio() const {
  return m_audio;
}

QString ServiceItem::font() const {
  return m_font;
}

int ServiceItem::fontSize() const {
  return m_fontSize;
}

int ServiceItem::slideNumber() const {
  return m_slideNumber;
}

bool ServiceItem::active() const {
  return m_active;
}

bool ServiceItem::selected() const {
  return m_selected;
}

void ServiceItem::setName(QString name)
{
    if (m_name == name)
        return;

    m_name = name;
    emit nameChanged(m_name);
}

void ServiceItem::setType(QString type)
{
    if (m_type == type)
        return;

    m_type = type;
    emit typeChanged(m_type);
}

void ServiceItem::setBackground(QString background)
{
    if (m_background == background)
        return;

    m_background = background;
    emit backgroundChanged(m_background);
}

void ServiceItem::setBackgroundType(QString backgroundType)
{
    if (m_backgroundType == backgroundType)
        return;

    m_backgroundType = backgroundType;
    emit backgroundTypeChanged(m_backgroundType);
}

void ServiceItem::setText(QStringList text)
{
    if (m_text == text)
        return;

    m_text = text;
    emit textChanged(m_text);

}

void ServiceItem::setAudio(QString audio)
{
    if (m_audio == audio)
        return;

    m_audio = audio;
    emit audioChanged(m_audio);
}

void ServiceItem::setFont(QString font)
{
    if (m_font == font)
        return;

    m_font = font;
    emit fontChanged(m_font);
}

void ServiceItem::setFontSize(int fontSize)
{
    if (m_fontSize == fontSize)
        return;

    m_fontSize = fontSize;
    emit fontSizeChanged(m_fontSize);
}

void ServiceItem::setSlideNumber(int slideNumber)
{
    if (m_slideNumber == slideNumber)
        return;

    m_slideNumber = slideNumber;
    emit slideNumberChanged(m_slideNumber);
}

void ServiceItem::setActive(bool active)
{
  qDebug() << "::::::::::::::::::::";
  qDebug() << "CHANGE ME!";
  if (m_active == active)
    return;

  m_active = active;
  emit activeChanged(m_active);
}

void ServiceItem::setSelected(bool selected)
{
    if (m_selected == selected)
        return;

    m_selected = selected;
    emit selectedChanged(m_selected);
}
