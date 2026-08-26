//@ pragma UseQApplication
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import "file:/home/.config/quickshell/theme" as Theme

Rectangle {
    id: container

    required property var trayWindow
    property bool hasMouse: mouse.containsMouse

    color: Theme.Colors.background
    implicitHeight: parent.parent.height - 5
    implicitWidth: root.width + (SystemTray.items.values.length ? 30 : 0)
    radius: 50

    Row {
        id: root

        spacing: 12
        anchors.centerIn: parent

        Repeater {
            model: SystemTray.items

            delegate: Image {
                id: trayIcon

                required property var modelData

                width: 18
                height: 18
                source: modelData.icon
                fillMode: Image.PreserveAspectFit

                QsMenuAnchor {
                    id: trayMenu

                    menu: trayIcon.modelData.menu

                    anchor {
                        item: trayIcon
                        edges: Edges.Bottom | Edges.Left
                        gravity: Edges.Bottom | Edges.Left
                        adjustment: PopupAdjustment.Flip
                    }

                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onPressed: (mouse) => {
                        if (mouse.button === Qt.LeftButton) {
                            modelData.activate();
                            return ;
                        }
                        trayMenu.open();
                    }
                }

            }

        }

    }

}
