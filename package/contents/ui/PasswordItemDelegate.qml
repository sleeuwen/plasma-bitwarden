import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.kquickcontrolsaddons 2.0 as KQuickControlsAddons

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
        visible: !menuItem.ListView.isCurrentItem
        anchors {
            left: parent.left
            leftMargin: PlasmaCore.Units.gridUnit / 2
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        PlasmaComponents3.Label {
            maximumLineCount: 3
            verticalAlignment: Text.AlignVCenter

            text: model.name

            elide: Text.ElideRight
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            textFormat: Text.PlainText
        }
    }
}
