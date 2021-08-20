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

Item {
    id: main

    signal clearSearchField

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
                passwordsModel.append({
                    name: list[i].name,
                    username: list[i].username,
                })
            }
        }
    }

    Plasmoid.fullRepresentation: PlasmaComponents3.Page {
        id: dialogItem
        Layout.minimumWidth: PlasmaCore.Units.gridUnit * 5
        Layout.minimumHeight: PlasmaCore.Units.gridUnit * 5

        focus: true

        header: stack.currentPage.header

        Keys.forwardTo: [stack.currentPage]

        PlasmaComponents.PageStack {
            id: stack
            anchors.fill: parent
            initialPage: PasswordPage {
                anchors.fill: parent
            }
        }
    }

    /*Plasmoid.fullRepresentation: ColumnLayout {
        anchors.fill: parent


        PlasmaExtras.ScrollArea {
            id: scrollView

            ListView {
                id: view
                width: parent.width
                height: parent.height
                model: itemsModel
                spacing: 7
                interactive: false
                clip: false

                delegate: RowLayout {
                    width: parent.width

                    ColumnLayout {
                        PlasmaComponents.Label {
                            id: itemName
                            text: model.name
                            clip: false
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                        }

                        PlasmaComponents.Label {
                            id: itemUsername
                            text: model.name
                            clip: false
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                        }
                    }
                }
            }
        }
    }*/
}
