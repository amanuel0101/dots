import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import "file:/home/.config/quickshell/theme" as Theme

Rectangle {
    property bool hasMouse: mouse.containsMouse

    color: Theme.Colors.background
    implicitHeight: parent.parent.height - 5
    implicitWidth: root.width + 20
    radius: 50

    MouseArea {
        id: mouse

        anchors.fill: parent
        onClicked: print("Battery clicked")
        hoverEnabled: true
    }

    RowLayout {
        id: root

        property var battery: UPower.displayDevice
        property bool charging: battery.state === UPowerDeviceState.Charging
        readonly property int level: Math.round(battery.percentage * 100)
        readonly property string icon: {
            if (charging)
                return String.fromCodePoint(983172);

            if (level >= 100)
                return String.fromCodePoint(983161);

            if (level < 10)
                return String.fromCodePoint(983171);

            return String.fromCodePoint(983162 + Math.floor((level / 10) - 1));
        }

        anchors.centerIn: parent
        spacing: 3

        Text {
            text: root.icon
            color: root.charging ? Theme.Colors.green : (root.level <= 30 ? Theme.Colors.red : (root.level <= 50 ? Theme.Colors.yellow : Theme.Colors.green))

            font {
                family: "JetBrains Nerd Font Propo"
                pixelSize: 17
            }

        }

        Text {
            Layout.preferredWidth: 32
            Layout.minimumWidth: 32
            Layout.maximumWidth: 32
            horizontalAlignment: Text.AlignHCenter
            text: root.level + "%"
            color: Theme.Colors.foreground

            font {
                family: "SF Pro Display"
                weight: 600
                pixelSize: 13
            }

        }

    }

}
