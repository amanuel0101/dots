import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Networking
import Quickshell.Wayland

ShellRoot {
    id: root

    property bool drawerOpen: false
    property int drawerPage: 0 // 0 = control center, 1 = notifications

    // BAR
    PanelWindow {
        id: bar

        implicitHeight: 40
        color: "transparent"

        anchors {
            top: true
            left: true
            right: true
        }

        Rectangle {
            anchors.fill: parent
            color: "#1a1b26"

            RowLayout {
                anchors.fill: parent

                Item {
                    Layout.fillWidth: true
                }

                Rectangle {
                    width: 100
                    height: 30
                    radius: 8
                    color: "#24283b"

                    Text {
                        anchors.centerIn: parent
                        text: "☰"
                        color: "#c0caf5"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            root.drawerPage = 0;
                            root.drawerOpen = !root.drawerOpen;
                        }
                    }

                }

                Rectangle {
                    width: 100
                    height: 30
                    radius: 8
                    color: "#24283b"

                    Text {
                        anchors.centerIn: parent
                        text: "🔔"
                        color: "#c0caf5"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            root.drawerPage = 1;
                            root.drawerOpen = true;
                        }
                    }

                }

            }

        }

    }

    // DRAWER
    PanelWindow {
        id: drawer

        visible: root.drawerOpen
        implicitWidth: 400
        implicitHeight: 600
        color: "transparent"
        Component.onCompleted: {
            let ns = Networking.devices.values[0].networks.values
            console.log(Networking.devices.values[0].networks.values)
            for (let n of ns) {
                console.log(n.name);
            }
        }

        anchors {
            top: true
            right: true
        }

        Rectangle {
            anchors.fill: parent
            radius: 20
            color: "#1a1b26"

            Loader {
                anchors.fill: parent
                sourceComponent: root.drawerPage === 0 ? controlCenter : notificationCenter
            }

        }

        Component {
            id: controlCenter

            ColumnLayout {
                anchors.centerIn: parent

                Repeater {
                    model: Networking.devices

                    delegate: Text {
                        required property var modelData

                        text: toString(modelData)
                    }

                }

            }

        }

        Component {
            id: notificationCenter

            ColumnLayout {
                anchors.centerIn: parent

                Text {
                    text: "Notifications"
                    color: "#c0caf5"
                    font.pixelSize: 24
                }

                Text {
                    text: "No notifications"
                    color: "#a9b1d6"
                }

            }

        }

    }

}
