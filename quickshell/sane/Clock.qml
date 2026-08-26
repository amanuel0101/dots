import QtQuick
import QtQuick.Layouts
import Quickshell
import "file:/home/.config/quickshell/theme" as Theme

Rectangle {
    //     anchors.centerIn: parent
    //     spacing: -3
    // Text {
    //     id: t
    //     anchors.horizontalCenter: parent.horizontalCenter
    //     text: Qt.formatDateTime(clock.date, "hh:mm AP")
    //     // text: Qt.formatDateTime(clock.date, "hh:mm AP")
    //     color: Qt.alpha(Theme.Colors.red, 0.85)
    //     font {
    //         family: "SF Mono"
    //         pixelSize: 15
    //         letterSpacing: -0.5
    //         weight: 600
    //     }
    //     SystemClock {
    //         id: clock
    //         precision: SystemClock.Minutes
    //     }
    // }
    // Text {
    //     id: p
    //     anchors.horizontalCenter: parent.horizontalCenter
    //     text: Qt.formatDateTime(clock2.date, "ddd, MMM d")
    //     // text: Qt.formatDateTime(clock.date, "hh:mm AP")
    //     color: Qt.alpha(Theme.Colors.red, 0.85)
    //     font {
    //         family: "SF Mono"
    //         pixelSize: 11
    //         letterSpacing: -0.5
    //         weight: 600
    //     }
    //     SystemClock {
    //         id: clock2
    //         precision: SystemClock.Minutes
    //     }
    // }
    // }

    color: Theme.Colors.background
    implicitHeight: parent.height - 5
    implicitWidth: t.width + 25
    radius: 50

    Text {
        id: t

        anchors.centerIn: parent
        text: Qt.formatDateTime(clock.date, "ddd, MMM d • hh:mm AP")
        // text: Qt.formatDateTime(clock.date, "hh:mm AP")
        color: Qt.alpha(Theme.Colors.foreground, 1)

        font {
            family: "SF Mono"
            pixelSize: 15
            letterSpacing: -0.5
            weight: 600
            bold: true
        }

        SystemClock {
            id: clock

            precision: SystemClock.Minutes
        }

    }
    // Column {

}
