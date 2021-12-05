import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

MouseArea {
    onClicked: plasmoid.expanded = !plasmoid.expanded

    implicitWidth: PlasmaCore.Units.iconSizeHints.panel
    implicitHeight: PlasmaCore.Units.iconSizeHints.panel

    PlasmaCore.IconItem {
        anchors.fill: parent

        source: '/usr/share/plasma/plasmoids/com.github.sleeuwen.plasmabitwarden/contents/icons/bitwarden.svg'
    }
}
