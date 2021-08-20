import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.kquickcontrolsaddons 2.0 as KQuickControlsAddons
import org.kde.plasma.extras 2.0 as PlasmaExtras

PlasmaComponents.ListItem {
    id: menuItem

    enabled: true

    onContainsMouseChanged: {
        if (containsMouse) {
            menuListView.currentIndex = index
        } else {
            menuListView.currentIndex = -1
        }
    }

    Item {
        id: label
        height: childrenRect.height
        anchors {
            left: parent.left
            leftMargin: PlasmaCore.Units.gridUnit / 2
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter

            spacing: 0

            PlasmaExtras.Heading {
                id: listItemTitle

                visible: text.length > 0

                Layout.fillWidth: true

                level: 5

                text: model.name

                textFormat: listItem.allowStyledText ? Text.StyledText : Text.PlainText
                elide: Text.ElideRight
                maximumLineCount: 1

                // Even if it's the default item, only make it bold when
                // there's more than one item in the list, or else there's
                // only one item and it's bold, which is a little bit weird
                font.weight: listItem.isDefault && listItem.ListView.view.count > 1
                                    ? Font.Bold
                                    : Font.Normal
            }

            PlasmaComponents3.Label {
                id: listItemSubtitle

                visible: text.length > 0
                font: PlasmaCore.Theme.smallestFont

                // Otherwise colored text can be hard to see
                opacity: color === PlasmaCore.Theme.textColor ? 0.7 : 1.0

                Layout.fillWidth: true

                text: model.username

                textFormat: listItem.allowStyledText ? Text.StyledText : Text.PlainText
                elide: Text.ElideRight
                maximumLineCount: subtitleCanWrap ? 9999 : 1
                wrapMode: subtitleCanWrap ? Text.WordWrap : Text.NoWrap
            }
        }
    }
}
