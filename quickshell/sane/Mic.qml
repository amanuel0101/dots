import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import "file:/home/.config/quickshell/theme" as Theme

Rectangle {
    color: Theme.Colors.background
    implicitHeight: parent.parent.height - 6
    implicitWidth: txt.width + 18
    radius: 50
    clip: true
    visible: vars.used

    QtObject {
        id: vars

        readonly property PwNode micc: Pipewire.defaultAudioSource
        readonly property var gVals: Pipewire.linkGroups.values
        readonly property bool used: bch.linkGroups.length > 0
        readonly property bool micRecording: {
            if (!micc)
                return false;

            for (const link of Pipewire.linkGroups.values) {
                if (link.source === micc && link.state === PwLinkState.Active)
                    return true;

            }
            return false;
        }
    }

    PwNodeLinkTracker {
        id: bch

        node: Pipewire.defaultAudioSource
    }

    Text {
        id: txt

        anchors.centerIn: parent
        text: vars.used ? "Mic (" + bch.linkGroups.length + ")" : "OFF"
        color: Theme.Colors.red

        font {
            family: "JetBrainsMono Nerd Font Propo"
            pixelSize: 17
        }

    }

}
