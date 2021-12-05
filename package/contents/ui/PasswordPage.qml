import QtQuick 2.4
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras
import com.github.sleeuwen.private.plasmabitwarden 1.0

ColumnLayout {
    Keys.onPressed: {
        switch (event.key) {
            case Qt.Key_Up: {
                passwordMenu.view.decrementCurrentIndex();
                event.accepted = true;
                break;
            }
            case Qt.Key_Down: {
                passwordMenu.view.incrementCurrentIndex();
                event.accepted = true;
                break;
            }
            case Qt.Key_Enter:
            case Qt.Key_Return:
                if (passwordMenu.view.currentIndex >= 0) {
                    var id = passwordMenu.model.get(passwordMenu.view.currentIndex).id;
                    if (id) {
                        passwordsModel.copyToClipboard(id);
                        if (plasmoid.hideOnWindowDeactivate) {
                            plasmoid.expanded = false;
                        }
                    }
                }
                break;
            case Qt.Key_Escape: {
                if (filter.text != "") {
                    fitler.text = "";
                    event.accepted = true;
                }
                break;
            }
            default: {
                if (event.key === Qt.Key_Backspace && filter.text == "") {
                    return;
                }
                if (event.text !== "" && !filter.activeFocus) {
                    passwordMenu.view.currentIndex = -1
                    if (event.matches(StandardKey.Paste)) {
                        filter.paste();
                    } else {
                        filter.text = "";
                        filter.text += event.text;
                    }
                    filter.forceActiveFocus();
                    event.accepted = true;
                }
            }
        }
    }

    property var header: PlasmaExtras.PlasmoidHeading {
        RowLayout {
            anchors.fill: parent
            enabled: passwordMenu.model.count > 0 || filter.text.length > 0

            PlasmaComponents3.TextField {
                id: filter
                placeholderText: i18n("Search…")
                clearButtonShown: true
                Layout.fillWidth: true

                // Only override delete key behavior to delete list items if it would do nothing
                Keys.enabled: filter.text.length == 0 || filter.cursorPosition == filter.length

                Connections {
                    target: main
                    function onClearSearchField() {
                        filter.clear();
                    }
                }
            }
        }
    }

    Menu {
        id: passwordMenu
        model: PlasmaCore.SortFilterModel {
            id: sortFilterModel
            sourceModel: PasswordsModel { id: passwordsModel }
            filterRole: 'filterText'
            filterRegExp: filter.text
        }
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.topMargin: PlasmaCore.Units.smallSpacing

        onItemSelected: {
            var item = sortFilterModel.get(index);
            passwordsModel.copyToClipboard(item.id);

            if (plasmoid.hideOnWindowDeactivate) {
                plasmoid.expanded = false;
            }
        }
    }

    Connections {
        target: plasmoid

        function onExpandedChanged(expanded) {
            if (expanded) {
                filter.focus = true;
                passwordMenu.view.currentIndex = -1;
            } else {
                filter.text = "";
                passwordMenu.view.currentIndex = -1;
            }
        }
    }
}
