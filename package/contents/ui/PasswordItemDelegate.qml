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

    signal itemSelected(var index);

    onContainsMouseChanged: {
        if (containsMouse) {
            menuListView.currentIndex = index
        } else {
            menuListView.currentIndex = -1
        }
    }

    onClicked: {
        menuItem.itemSelected(index)
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

                elide: Text.ElideRight
                maximumLineCount: 1

                font.weight: Font.Normal
            }

            PlasmaComponents3.Label {
                id: listItemSubtitle

                visible: text.length > 0
                font: PlasmaCore.Theme.smallestFont

                // Otherwise colored text can be hard to see
                opacity: color === PlasmaCore.Theme.textColor ? 0.7 : 1.0

                Layout.fillWidth: true

                text: model.username

                elide: Text.ElideRight
                maximumLineCount: 1
                wrapMode: Text.NoWrap
            }
        }
    }
}
