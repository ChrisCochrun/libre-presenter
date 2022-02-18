#ifndef SONGTEXT_H
#define SONGTEXT_H

#include <QObject>
#include <QString>
#include <qqml.h>

class SongText : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString songText READ songText WRITE setSongText NOTIFY songTextChanged)
    QML_ELEMENT

public:
    explicit SongText(QObject *parent = nullptr);

    QString songText();
    void setSongText(const QString &lyrics);

signals:
    void songTextChanged();

private:
    QString m_songText;
};

#endif // SONGTEXT_H
