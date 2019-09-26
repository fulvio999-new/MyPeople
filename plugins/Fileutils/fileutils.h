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

#ifndef FILEUTILS_H
#define FILEUTILS_H

#include <QObject>
#include <QDir>
#include <QDateTime>

class Fileutils: public QObject {
    Q_OBJECT

public:
    Fileutils();
    ~Fileutils() = default;

    Q_INVOKABLE void speak();
    Q_INVOKABLE bool write(QString source, const QString& data);
    Q_INVOKABLE bool exists(QString source);
    Q_INVOKABLE QString getHomePath();
};

#endif
