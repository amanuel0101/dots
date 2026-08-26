import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "file:/home/.config/quickshell/theme" as Theme

Rectangle {
    color: Qt.alpha(Theme.Colors.background, 0.95)
    implicitHeight: parent.height - 5
    implicitWidth: r.width + 20
    radius: 50

    RowLayout {
        id: r

        spacing: 6
        anchors.centerIn: parent

        Repeater {
            model: 9

            Rectangle {
                id: ws_button

                required property int index
                property var ws: Hyprland.workspaces.values.find(function(w) {
                    return w.id === index + 1;
                })
                property bool is_active: Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.id === (index + 1)

                implicitWidth: lable.implicitWidth + 14
                implicitHeight: 22
                radius: 6
                color: is_active ? Qt.alpha(Theme.Colors.red, 0.3) : (ws ? Qt.alpha(Theme.Colors.red, 0.1) : "transparent")

                Text {
                    id: lable

                    text: ws_button.index + 1
                    anchors.centerIn: parent
                    color: ws_button.is_active ? Theme.Colors.brightRed : (ws_button.ws ? Theme.Colors.brightWhite : Theme.Colors.brightBlack)

                    font {
                        family: "SF Mono"
                        pixelSize: 14
                        weight: is_active ? 600 : 400
                    }

                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + (parent.index + 1) + " })")
                }

                Behavior on color {
                    ColorAnimation {
                        duration: 0
                    }

                }

            }

        }

    }

}
