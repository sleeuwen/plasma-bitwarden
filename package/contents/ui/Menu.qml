import QtQuick 2.0
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents // For Highlight

import org.kde.kirigami 2.12 as Kirigami

PlasmaExtras.ScrollArea {
    id: menu

    property alias view: menuListView
    property alias model: menuListView.model

    frameVisible: false

    signal itemSelected(var index)

    ListView {
        id: menuListView
        focus: true

        boundsBehavior: Flickable.StopAtBounds
        interactive: contentHeight > height
        highlight: PlasmaComponents.Highlight { }
        highlightMoveDuration: 0
        highlightResizeDuration: 0
        currentIndex: -1

        delegate: PasswordItemDelegate {
            width: menuListView.width

            onItemSelected: {
                menu.itemSelected(index);
            }
        }

        PlasmaExtras.PlaceholderMessage {
            id: emptyHint

            anchors.centerIn: parent
            width: parent.width - (PlasmaCore.Units.largeSpacing * 4)

            visible: menuListView.count === 0
            text: model.filterRegExp.length > 0 ? i18n("No matches") : i18n("No saved passwords")
        }
    }
}
