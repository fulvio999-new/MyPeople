/*
 * Copyright (C) 2019  fulvio
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * ubuntu-calculator-app is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <QDebug>

#include "fileutils.h"

Fileutils::Fileutils() {

}

void Fileutils::speak() {
    qDebug() << "hello world!";
}

/* write provided content to a new file or exisitng one */
bool Fileutils::write(QString source, const QString &data)
{
  if (source.isEmpty())
      return false;

    if(source.startsWith("file://"))
      source.remove("file://");

    QDir dir = QFileInfo(source).absoluteDir();
    if(!dir.exists())
        dir.mkdir(dir.absolutePath());

    QFile file(source);
    if (!file.open(QFile::ReadWrite))
        return false;

    QTextStream out(&file);
    out << data;
    file.close();
    return true;
}


bool Fileutils::exists(QString source)
{
    if (source.isEmpty())
        return false;

    if(source.startsWith("file://"))
        source.remove("file://");

    QFileInfo fi(source);
    return fi.exists();
}


QString Fileutils::getHomePath()
{
    return QDir::homePath();
}
