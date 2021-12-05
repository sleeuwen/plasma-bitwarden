/*
    SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
    SPDX-License-Identifier: LGPL-2.1-or-later
*/

import QtQuick 2.1
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras
import com.github.sleeuwen.private.plasmabitwarden 1.0

PlasmaComponents3.Page {
    id: main

    Layout.minimumWidth: PlasmaCore.Units.gridUnit * 5
    Layout.minimumHeight: PlasmaCore.Units.gridUnit * 5
    Layout.preferredWidth: 480 * PlasmaCore.Units.devicePixelRatio
    Layout.preferredHeight: 640 * PlasmaCore.Units.devicePixelRatio

    focus: true

    signal clearSearchField

    header: stack.currentPage.header

    Keys.forwardTo: [stack.currentPage]

    BitwardenVault {
        id: vault

        onStatusChanged: {
            if (vault.status == "loading") {
                stack.replace(stack.initialPage, null, true);
            } else if (vault.status == "locked") {
                stack.replace(loginPage, null, true);
            } else if (vault.status == "unlocked") {
                stack.replace(passwordPage, null, true);
            }
        }
    }

    PlasmaComponents.PageStack {
        id: stack
        anchors.fill: parent
        initialPage: LoadingPage {
            anchors.fill: parent
        }
    }

    Component {
        id: passwordPage
        PasswordPage {
            anchors.fill: parent
        }
    }

    Component {
        id: loginPage
        LoginPage {
            anchors.fill: parent
        }
    }

    Component.onCompleted: {
        // Change settings here
        vault.loadVaultStatus();
    }
}
