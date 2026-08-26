import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Io
import "file:/home/.config/quickshell/theme" as Theme

Rectangle {
    property bool hasMouse: {
        return mouse.containsMouse;
    }

    color: Theme.Colors.background
    implicitHeight: parent.parent.height - 5
    implicitWidth: root.ready ? root.width + 18 : height
    radius: 50

    Process {
        id: proc

        running: false
        onExited: (exitCode) => {
            if (exitCode !== 0)
                console.log("Blue");

        }
    }

    MouseArea {
        id: mouse

        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onPressed: function(mouse) {
            if (mouse.button === Qt.RightButton) {
                Bluetooth.defaultAdapter.discoverable = !Bluetooth.defaultAdapter.discoverable;
                return ;
            }
            proc.command = ["foot", "--title", "makemefloat", "-e", "bluetui"];
            proc.running = true;
        }
    }

    RowLayout {
        id: root

        property bool ready: {
            console.log("power: ", Bluetooth.defaultAdapter.discoverable);
            return (Bluetooth.defaultAdapter.discoverable);
        }
        property bool conected: {
            // console.log(Bluetooth.defaultAdapter);
            return (Bluetooth.defaultAdapter.discoverable);
        }
        readonly property string icon: {
            if (!ready)
                return String.fromCodePoint(983218);

            return String.fromCodePoint(983215);
        }

        anchors.centerIn: parent
        spacing: 3

        Text {
            text: root.icon
            color: Theme.Colors.blue

            font {
                family: "JetBrainsMono Nerd Font Propo"
                pixelSize: 19
            }

        }

        Text {
            visible: root.ready
            text: {
                if (!root.ready)
                    return "off";
                else
                    return "on";
            }
            color: !root.ready ? Theme.Colors.brightBlack : Theme.Colors.foreground

            font {
                family: "SF Pro Display"
                weight: 600
                pixelSize: 13
            }

        }

    }

}
