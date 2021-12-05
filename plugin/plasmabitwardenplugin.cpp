/*
    SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
    SPDX-License-Identifier: LGPL-2.1-or-later
*/

#include "plasmabitwardenplugin.h"
#include "bitwardenvault.h"
#include "passwordsmodel.h"

// KF
#include <KLocalizedString>
// Qt
#include <QJSEngine>
#include <QQmlEngine>
#include <QQmlContext>


void plasmabitwardenPlugin::registerTypes(const char* uri)
{
    Q_ASSERT(uri == QLatin1String("com.github.sleeuwen.private.plasmabitwarden"));

    qmlRegisterType<BitwardenVault>(uri, 1, 0, "BitwardenVault");
    qmlRegisterType<PlasmaBitwarden::PasswordsModel>(uri, 1, 0, "PasswordsModel");
}
