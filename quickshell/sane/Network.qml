import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Networking
import Quickshell.Io
import "file:/home/.config/quickshell/theme" as Theme

Rectangle {
    property bool hasMouse: mouse.containsMouse

    color: Theme.Colors.background
    implicitHeight: parent.parent.height - 5
    implicitWidth: !root.active ? height : root.width + 18
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
                Networking.wifiEnabled = !Networking.wifiEnabled
                return
            }
            proc.command = ["foot", "--title", "makemefloat", "-e", "wlctl"];
            proc.running = true;
        }
    }

    RowLayout {
        id: root

        property var wifi_device: Networking.devices.values.find((d) => {
            return d.type === DeviceType.Wifi;
        })
        property var active: wifi_device ? wifi_device.networks.values.find((n) => {
            return n.connected;
        }) : null
        readonly property real signal: active ? active.signalStrength : 0
        readonly property string icon: {
            if (!Networking.wifiEnabled)
                return String.fromCodePoint(985389);

            if (!active)
                return String.fromCodePoint(985384);

            let tier = signal >= 0.75 ? 4 : signal >= 0.5 ? 3 : signal >= 0.25 ? 2 : 1;
            return String.fromCodePoint(985375 + (tier - 1) * 3);
        }

        anchors.centerIn: parent
        spacing: 3

        Text {
            text: root.icon
            color: Networking.wifiEnabled ? (root.active ? Theme.Colors.red : Themes.Colors.brightBlack) : Theme.Colors.brightBlack

            font {
                family: "JetBrainsMono Nerd Font Propo"
                pixelSize: 16
            }

        }

        Text {
            visible: root.active && Networking.wifiEnabled ? true : false
            text: {
                if (!Networking.wifiEnabled)
                    return "off";

                // if (!root.active)
                //     return "disconected";

                return root.active.name;
            }
            color: Theme.Colors.foreground

            font {
                family: "SF Pro Display"
                weight: 600
                pixelSize: 13
            }

        }

    }

}
