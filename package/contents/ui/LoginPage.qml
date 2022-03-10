import QtQuick 2.1
import QtQuick.Layouts 1.1
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras

Item {
    anchors.fill: parent

    function tryUnlock() {
        var password = passwordField.text;
        passwordField.enabled = false;
        loginButton.enabled = false;
        invalidPasswordLabel.visible = false;
        vault.unlock(password);
    }

    property var header: PlasmaExtras.PlasmoidHeading {
    }

    ColumnLayout {
        anchors.fill: parent

        PlasmaExtras.Heading {
            text: i18n("Vault is locked.");
            Layout.fillHeight: false
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignVCenter
            Layout.fillHeight: true

            PlasmaComponents.Label {
                text: i18n("Password");
            }

            PlasmaComponents.TextField {
                id: passwordField
                Layout.fillWidth: true

                echoMode: TextInput.Password

                onAccepted: tryUnlock();
            }

            PlasmaComponents.Label {
                id: invalidPasswordLabel
                text: i18n("The password was invalid.");
                visible: false
            }

            PlasmaComponents.Button {
                id: loginButton;
                text: i18n("Login");

                onClicked: tryUnlock();
            }
        }
    }

    Connections {
        target: vault

        function onUnlockFailed() {
            passwordField.enabled = true;
            loginButton.enabled = true;
            invalidPasswordLabel.visible = true;
            passwordField.focus = true;
        }
    }

    Component.onCompleted: {
        passwordField.focus = true;
    }
}
