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

    Component.onCompleted: {
        // Change settings here
    }

    ListModel {
        id: passwordsModel
    }

    PlasmaCore.DataSource {
        id: passwordSource
        engine: "executable"
        connectedSources: ["bw list items --session '***'"]

        onNewData: {
            var stdout = data["stdout"]
            passwordsModel.clear()
            var list = JSON.parse(stdout)
            for (var i = 0; i < list.length; i++) {
                if (!list[i].login) continue;

                passwordsModel.append({
                    id: list[i].id,
                    name: list[i].name,
                    username: list[i].login && list[i].login.username,
                    password: list[i].login && list[i].login.password,
                });
            }

            stack.replace(passwordPage, null, true);
        }
    }

    Connections {
        target: plasmoid

        function onExpandedChanged(expanded) {
            if (expanded && stack.currentPage.filter) {
                stack.currentPage.filter.text = "";
            }
        }
    }
}
