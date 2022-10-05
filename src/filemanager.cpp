#include "filemanager.h"
#include <ktar.h>
#include <QDebug>
#include <QJsonArray>
#include <QJsonDocument>
#include <QFile>
#include <QDir>

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
  QJsonArray jsonData = QJsonArray::fromVariantList(serviceList);
  qDebug() << jsonData;

  QJsonDocument jsonText(jsonData);

  QDir dir;
  dir.mkpath("/tmp/presenter");
  QFile jsonFile("/tmp/presenter/json");
  if (!jsonFile.exists())
    qDebug() << "NOT EXISTS!";
  if (!jsonFile.open(QIODevice::WriteOnly | QIODevice::Text))
    return false;

  jsonFile.write(jsonText.toJson());
  
  return true;
}
