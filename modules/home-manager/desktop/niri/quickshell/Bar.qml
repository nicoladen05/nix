import QtQuick
import Quickshell
import "."

Scope {
    id: root

    property date currentTime: clock.date

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData

            screen: modelData
            anchors {
                top: true
                left: true
                right: true
            }
            exclusiveZone: 32
            implicitHeight: 32
            color: Theme.background

            Rectangle {
                anchors.fill: parent
                color: Theme.background
                border.color: Theme.border
                border.width: 1

                Clock {
                    anchors.centerIn: parent
                    currentTime: root.currentTime
                }
            }
        }
    }
}
