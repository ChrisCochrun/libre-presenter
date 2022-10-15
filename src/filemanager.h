#ifndef FILEMANAGER_H
#define FILEMANAGER_H

#include <qobjectdefs.h>
#include <qqml.h>
#include <QObject>
#include <qobject.h>

class File : public QObject
{
  Q_OBJECT
  Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
  Q_PROPERTY(QString filePath READ filePath WRITE setFilePath NOTIFY filePathChanged)
  // QML_ELEMENT

public:
  explicit File(QObject *parent = nullptr);
  File(const QString &name, const QString &filePath,
        QObject * parent = nullptr);

  QString name() const;
  QString filePath() const;

  Q_INVOKABLE void setName(QString name);
  Q_INVOKABLE void setFilePath(QString filePath);

  Q_INVOKABLE bool save(QUrl file, QVariantList serviceList);
  Q_INVOKABLE QVariantList load(QUrl file);

signals:
    Q_INVOKABLE void nameChanged(QString name);
    Q_INVOKABLE void filePathChanged(QString filePath);

private:
    QString m_name;
    QString m_filePath;
};

#endif //FILEMANAGER_H
