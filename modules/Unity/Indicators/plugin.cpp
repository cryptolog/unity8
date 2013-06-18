/*
 * Copyright (C) 2012 Canonical, Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Author: Michał Sawicz <michal.sawicz@canonical.com>
 */

// Qt
#include <QtQml>

// self
#include "plugin.h"

// local
#include "flatmenuproxymodel.h"
#include "indicatorsmanager.h"
#include "indicatorsmodel.h"
#include "indicators.h"

void IndicatorsPlugin::registerTypes(const char *uri)
{
    Q_INIT_RESOURCE(indicators);

    qmlRegisterType<IndicatorsManager>(uri, 0, 1, "IndicatorsManager");
    qmlRegisterType<FlatMenuProxyModel>(uri, 0, 1, "FlatMenuProxyModel");
    qmlRegisterType<IndicatorsModel>(uri, 0, 1, "IndicatorsModel");
    qmlRegisterUncreatableType<DefaultActionState>(uri, 0, 1, "DefaultActionState", "Can't create DefaultActionState class");
    qmlRegisterUncreatableType<NetworkActionState>(uri, 0, 1, "NetworkActionState", "Can't create NetworkActionState class");
    qmlRegisterUncreatableType<NetworkConnection>(uri, 0, 1, "NetworkConnection", "Can't create NetworkConnection class");
}
