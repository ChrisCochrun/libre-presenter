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
  qDebug() << "File path is: " << file.toString();
  qDebug() << "serviceList is: " << serviceList;
  qDebug() << "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@";

  //first we'll get a json representation of our serviceList
  //save that to a temp file in case we need it but also convert
  //it to a byte array just before putting it into the archive
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

  //finalize the temp json file, in case something goes wrong in the
  //archive, we'll have this to jump back to
  jsonFile.write(jsonText.toJson());
  qDebug() << jsonFile.fileName();
  jsonFile.close();

  //now we create our archive file and set it's parameters
  QString filename = file.toString().right(file.toString().size() - 7);
  qDebug() << filename;

  KTar tar(filename, "application/zstd");

  if (!tar.open(QIODevice::WriteOnly)) {
    qDebug() << tar.isOpen();
    return false;
  }

  //write our json data to the archive
  tar.writeFile("servicelist.json",jsonText.toJson());

  //let's add the backgrounds and audios to the archive
  for (int i = 0; i < serviceList.size(); i++) {
    QMap item = serviceList[i].toMap();
    QString background = item.value("background").toString();
    QString backgroundFile = background.right(background.size() - 5);
    qDebug() << backgroundFile;
    QString audio = item.value("audio").toString();
    QString audioFile = audio.right(audio.size() - 5);
    qDebug() << audioFile;

    //here we need to cut off all the directories before
    //adding into the archive
    tar.addLocalFile(backgroundFile,
                     backgroundFile.right(backgroundFile.size() -
                                          backgroundFile.lastIndexOf("/") - 1));
    tar.addLocalFile(audioFile,
                     audioFile.right(audioFile.size() -
                                     audioFile.lastIndexOf("/") - 1));
  }

  //close the archive so that everything is done
  tar.close();

  
  return true;
}