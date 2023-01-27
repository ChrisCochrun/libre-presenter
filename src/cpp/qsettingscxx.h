#pragma once

#include <QSettings>

#include "rust/cxx.h"

class QSettingsCXX : public QSettings
{
public:
  explicit QSettingsCXX(QObject* parent = nullptr)
    : QSettings(parent)
  {
  }

  // Can't define in CXX as they are protected
  // so crate public methods that are proxied
  void setValue(QString key, QString value)
  {
    QSettings::setValue(key, value);
  }

  void sync() { QSettings::sync(); }

};
