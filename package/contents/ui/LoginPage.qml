import QtQuick 2.1
import QtQuick.Layouts 1.1
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

Item {
    anchors.fill: parent

    property var header: PlasmaExtras.PlasmoidHeading {
    }

    ColumnLayout {
        anchors.centerIn: parent

        PlasmaComponents.Label {
            text: i18n("Vault is locked.");
        }

    }
}
