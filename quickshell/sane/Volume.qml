import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import "file:/home/.config/quickshell/theme" as Theme

Rectangle {
    id: rec

    property bool hasMouse: {
        return mouse.containsMouse;
    }

    color: Theme.Colors.background
    implicitHeight: parent.parent.height - 5
    implicitWidth: root.muted ? height : root.width + 18
    radius: 50

    Process {
        id: proc

        running: false
        onExited: (exitCode) => {
            if (exitCode !== 0)
                console.log("Vol");

        }
    }

    MouseArea {
        id: mouse

        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onPressed: function(mouse) {
            if (mouse.button === Qt.RightButton) {
                if (!root.sink || !root.sink.audio)
                    return ;

                root.sink.audio.muted = !root.sink.audio.muted;
                return ;
            }
            proc.command = ["pavucontrol"];
            proc.running = true;
        }
        hoverEnabled: true
    }

    RowLayout {
        id: root

        property var sink: Pipewire.defaultAudioSink
        readonly property bool ready: {
            return sink && sink.ready;
        }
        readonly property bool muted: {
            return ready && sink.audio.muted;
        }
        readonly property int vol: {
            return (ready ? Math.round(sink.audio.volume * 100) : 0);
        }
        readonly property string icon: {
            if (!ready)
                return String.fromCodePoint(984449);

            if (muted)
                return String.fromCodePoint(986632);

            if (vol === 0)
                return String.fromCodePoint(984449);

            if (vol < 30)
                return String.fromCodePoint(984447);

            if (vol < 60)
                return String.fromCodePoint(984448);

            return String.fromCodePoint(984446);
        }

        anchors.centerIn: parent
        spacing: 3

        Text {
            Layout.preferredWidth: 16
            Layout.minimumWidth: 16
            Layout.maximumWidth: 16
            horizontalAlignment: Text.AlignHCenter
            text: root.icon
            color: Theme.Colors.yellow

            font {
                family: "JetBrainsMono Nerd Font Propo"
                pixelSize: 19
            }

        }

        Text {
            Layout.preferredWidth: 34
            Layout.minimumWidth: 34
            Layout.maximumWidth: 34
            horizontalAlignment: Text.AlignHCenter
            visible: !root.muted
            text: {
                if (!root.ready)
                    return "-";

                if (root.muted)
                    return "muted";

                return root.vol + "%";
            }
            color: root.muted ? Theme.Colors.brightBlack : Theme.Colors.foreground

            font {
                family: "SF Pro Display"
                weight: 600
                pixelSize: 13
            }

        }

        PwObjectTracker {
            objects: [root.sink]
        }

    }

}
