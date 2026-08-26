//@ pragma UseQApplication
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import Quickshell.Wayland
import "file:/home/.config/quickshell/theme" as Theme

ShellRoot {
    // PanelWindow {
    //     id: center
    //     anchors.right: true
    //     anchors.top: true
    //     margins.top: panel.height + panel.margins.top + 2
    //     implicitHeight: screen.height/2
    //     implicitWidth: 500
    //     visible: rec.height > 0
    //     property var notif: true
    //     exclusionMode: ExclusionMode.Ignore
    //     color: "transparent"
    //     property var v: true
    //     Behavior on visible {
    //     }
    //     MouseArea {
    //         anchors.fill: parent
    //         onClicked: function(m) {
    //             center.v= !center.v
    //         }
    //     }
    //     Rectangle {
    //         id: rec
    //         clip: true
    //         height: center.v ? parent.height - 5 : 0
    //         implicitWidth: parent.width - 10
    //         anchors.centerIn: parent
    //         color: Theme.Colors.background
    //         border.width: 1
    //         border.color: Theme.Colors.foreground
    //         radius: 20
    //         layer.enabled: true
    //     layer.effect: MultiEffect {
    //         maskEnabled: true
    //         maskSource: ShaderEffectSource {
    //             sourceItem: Rectangle {
    //                 width: rec.width
    //                 height: rec.height
    //                 radius: rec.radius
    //             }
    //         }
    //     }
    //         Behavior on height{
    //         NumberAnimation {
    //         duration: 200
    //     }
    //     }
    //         Item {
    //     anchors.fill: parent
    //     clip: true
    //     Row {
    //         anchors.fill: parent
    //         Text {
    //             width: parent.width
    //             text: "Notification"
    //             elide: Text.ElideRight
    //         }
    //     }
    // }
    //         Row {}
    //     }
    // }

    PanelWindow {
        id: panel

        property bool lock: true
        property bool childContainsMouse: (network.hasMouse || volume.hasMouse || battery.hasMouse || bluetooth.hasMouse || systemtray.hasMouse) //|| mic.hasMouse)

        implicitHeight: 38
        implicitWidth: screen.width
        color: "transparent"
        exclusionMode: ExclusionMode.Normal
        margins.top: (lock || mouse.containsMouse || childContainsMouse) ? 0 : -(height - 5)

        anchors {
            top: true
        }

        Binding {
            target: panel.WlrLayershell
            property: "exclusiveZone"
            value: panel.lock ? (panel.height) - 5 : 0 //panel.height / 4
            when: panel.WlrLayershell != null
        }

        MouseArea {
            id: mouse

            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onPressed: function(mouse) {
                if (mouse.button === Qt.RightButton) {
                    panel.lock = !panel.lock;
                    return ;
                }
            }
            hoverEnabled: true
        }

        Rectangle {
            // border {
            //     color: "red"
            //     width: 1
            // }

            anchors.fill: parent
            color: "transparent"

            Item {
                anchors.fill: parent

                Workspaces {
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                }

                Clock {
                    anchors.centerIn: parent
                }

                RowLayout {
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter

                    SystemTray {
                        id: systemtray
                    }

                    Mic {
                        id: mic
                    }

                    Network {
                        id: network
                    }

                    Bluetooth {
                        id: bluetooth
                    }

                    Volume {
                        id: volume
                    }

                    Battery {
                        id: battery
                    }

                }

            }

        }

        Behavior on margins.top {
            NumberAnimation {
                duration: 50
            }

        }

    }

    PanelWindow {
        // visible: center.notif

        id: notificationOverlay

        Process {
    id: sound

    command: ["paplay", "/home/sounds/click.wav"]
}

        exclusionMode: ExclusionMode.Ignore
        // Position it safely below your 40px bar
        anchors.top: true
        anchors.right: true
        margins.top: panel.height + panel.margins.top + 8
        margins.right: 12
        // Dynamic sizing: If there are notifications, give it a bounding box.
        // If empty, collapse it completely so it doesn't block mouse clicks on your desktop!
        implicitWidth: 350
        implicitHeight: c.height
        color: "transparent"

        // The backend server instantiates here silently
        NotificationServer {
            id: notifyServer

            actionsSupported: true
            onNotification: (notification) => {
                notification.tracked = true;
                sound.running = true
            }
        }

        // The visual container for the popups
        Column {
            id: c
            anchors.centerIn: parent

            width: parent.width
            spacing: 10

            Repeater {
                model: notifyServer.trackedNotifications

                delegate: Rectangle {
                    required property var modelData
                    property var self: true

                    width: parent.width
                    height: true ? col.height + 20 : 0
                    color: Theme.Colors.background
                    radius: 6
                    border.color: Theme.Colors.brightBlack

                    // dismiss animation
                    anchors.bottomMargin: 1000

                    Behavior on height {
                        NumberAnimation {
                            duration: 200
                        }

                    }

                    Column {
                        id: col

                        width: parent.width - 60
                        y: 8
                        spacing: -10

                        Row {
                            property var icon: {
                                if (modelData.image.length > 0)
                                    return modelData.image;

                                if (modelData.appIcon.length > 0)
                                    return Quickshell.iconPath(modelData.appIcon);

                                return "file:///home/.config/quickshell/assets/dialog-information.svg";
                            }

                            width: parent.width
                            spacing: 10
                            x: 8

                            Image {
                                source: parent.icon
                                width: 32
                                height: 32
                                visible: source ? true : false
                                fillMode: Image.PreserveAspectFit
                                asynchronous: true
                            }

                            Text {
                                id: t

                                width: parent.width
                                text: modelData.summary
                                color: Theme.Colors.foreground
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere

                                font {
                                    bold: true
                                    pixelSize: 16
                                    family: "SF Mono"
                                }

                            }

                        }

                        Text {
                            id: t2

                            x: 52
                            width: parent.width
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            text: modelData.body
                            color: Theme.Colors.brightBlack

                            font {
                                pixelSize: 15
                            }

                        }

                    }

                    Timer {
                        interval: modelData.expireTimeout > 0 ? modelData.expireTimeout : 10000
                        running: true
                        repeat: false
                        onTriggered: {
                            modelData.dismiss();
                            parent.self = false;
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onPressed: function(mouse) {
                            if (mouse.button === Qt.LeftButton) {
                                if (modelData.actions.length == 0) {
                                    modelData.dismiss();
                                    return ;
                                }
                                modelData.actions[0].invoke();
                                return ;
                            }
                            modelData.dismiss();
                        }
                    }

                }

            }

        }

    }

}
