#include "filemanager.h"
#include <ktar.h>
#include <QDebug>

File::File(QObject *parent)
  : QObject{parent}
{
  qDebug() << "Initializing empty file";
}

File::File(const QString &name, const QString &filePath, QObject *parent)
  : QObject(parent),m_name(name),m_filePath(filePath)
{
  qDebug() << "Initializing file with defaults";
}

QString File::name() const {
  return m_name;
}

QString File::filePath() const {
  return m_filePath;
}

void File::setName(QString name)
{
    if (m_name == name)
        return;

    qDebug() << "####changing name to: " << name;
    m_name = name;
    emit nameChanged(m_name);
}

void File::setFilePath(QString filePath)
{
    if (m_filePath == filePath)
        return;

    qDebug() << "####changing filePath to: " << filePath;
    m_filePath = filePath;
    emit filePathChanged(m_filePath);
}

bool File::save(QUrl file, QVariantList serviceList) {
  qDebug() << "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@";
  qDebug() << "Saving...";
  qDebug() << "File path is: " << file;
  qDebug() << "serviceList is: " << serviceList;
  qDebug() << "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@";
  return true;
}
