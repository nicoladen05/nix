import QtQuick
import Quickshell.Bluetooth
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell
import "."

Scope {
    id: root

    property date currentTime: clock.date
    readonly property int barPadding: 6
    readonly property int barRadius: 12
    readonly property int contentPadding: 12
    readonly property var defaultSink: Pipewire.ready ? Pipewire.defaultAudioSink : null
    readonly property int volumePercent: defaultSink && defaultSink.audio ? Math.round(defaultSink.audio.volume * 100) : 0
    readonly property bool volumeMuted: defaultSink && defaultSink.audio ? defaultSink.audio.muted : true
    readonly property string volumeIcon: volumeMuted ? "󰖁" : volumePercent < 1 ? "󰕿" : volumePercent < 50 ? "󰖀" : "󰕾"
    readonly property string volumeLabel: volumeMuted ? "muted" : volumePercent + "%"
    readonly property var bluetoothAdapter: Bluetooth.defaultAdapter
    readonly property bool bluetoothEnabled: bluetoothAdapter && bluetoothAdapter.enabled
    readonly property int connectedBluetoothDevices: Bluetooth.devices && Bluetooth.devices.values
        ? Bluetooth.devices.values.filter(function(device) {
            return device.state === BluetoothDeviceState.Connected;
        }).length
        : 0
    readonly property string bluetoothIcon: bluetoothEnabled ? "" : "󰂲"
    readonly property string bluetoothLabel: bluetoothEnabled && connectedBluetoothDevices > 0 ? String(connectedBluetoothDevices) : ""
    property var workspaces: []
    property string networkIcon: "󰤭"
    property string networkLabel: "offline"

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    PwObjectTracker {
        objects: root.defaultSink ? [root.defaultSink] : []
    }

    function parseWorkspaces(text) {
        try {
            var parsed = JSON.parse(text);
            if (!Array.isArray(parsed)) {
                root.workspaces = [];
                return;
            }

            root.workspaces = parsed.sort(function(a, b) {
                return (a.idx || 0) - (b.idx || 0);
            });
        } catch (error) {
            root.workspaces = [];
        }
    }

    function workspacesForScreen(screen) {
        if (!screen || !screen.name) {
            return root.workspaces;
        }

        return root.workspaces.filter(function(workspace) {
            return !workspace.output || workspace.output === screen.name;
        });
    }

    function workspaceText(workspace) {
        return String(workspace.name || workspace.idx || "").substring(0, 10);
    }

    function parseNetwork(text) {
        var lines = text.trim().split("\n");

        for (var i = 0; i < lines.length; i++) {
            var parts = lines[i].split(":");
            if (parts.length < 3 || !parts[1].startsWith("connected")) {
                continue;
            }

            if (parts[0] === "wifi") {
                root.networkIcon = "";
                root.networkLabel = parts[2] ? parts[2].substring(0, 14) : "wifi";
                return;
            }

            if (parts[0] === "ethernet") {
                root.networkIcon = "󰈀";
                root.networkLabel = parts[2] ? parts[2].substring(0, 14) : "wired";
                return;
            }

            root.networkIcon = "󰌘";
            root.networkLabel = parts[2] ? parts[2].substring(0, 14) : parts[0];
            return;
        }

        root.networkIcon = "󰤭";
        root.networkLabel = "offline";
    }

    Process {
        id: workspaceProc
        command: ["@niri@", "msg", "--json", "workspaces"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.parseWorkspaces(this.text)
        }
    }

    Process {
        id: networkProc
        command: ["@nmcli@", "-t", "-f", "TYPE,STATE,CONNECTION", "device", "status"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.parseNetwork(this.text)
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: if (!workspaceProc.running) workspaceProc.running = true
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: if (!networkProc.running) networkProc.running = true
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
            exclusiveZone: 32 + root.barPadding * 2
            implicitHeight: 32 + root.barPadding * 2
            color: Qt.rgba(0, 0, 0, 0)

            Rectangle {
                anchors.fill: parent
                anchors.margins: root.barPadding
                color: Theme.background
                radius: root.barRadius

                Row {
                    anchors.left: parent.left
                    anchors.leftMargin: root.contentPadding
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 6

                    Repeater {
                        model: root.workspacesForScreen(modelData)

                        Rectangle {
                            required property var modelData

                            height: 22
                            width: Math.max(22, workspaceLabel.implicitWidth + 12)
                            radius: 6
                            color: modelData.is_focused ? Theme.accent : Theme.surface

                            Text {
                                id: workspaceLabel

                                anchors.centerIn: parent
                                text: root.workspaceText(modelData)
                                color: modelData.is_focused ? Theme.background : Theme.foreground
                                font.pixelSize: 12
                                font.bold: modelData.is_focused
                            }
                        }
                    }
                }

                Clock {
                    anchors.centerIn: parent
                    currentTime: root.currentTime
                }

                Row {
                    anchors.right: parent.right
                    anchors.rightMargin: root.contentPadding
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 12

                    Text {
                        text: root.volumeIcon + " " + root.volumeLabel
                        color: Theme.foreground
                        font.pixelSize: 14
                    }

                    Text {
                        text: root.networkIcon + " " + root.networkLabel
                        color: Theme.foreground
                        font.pixelSize: 14
                    }

                    Text {
                        text: root.bluetoothLabel ? root.bluetoothIcon + " " + root.bluetoothLabel : root.bluetoothIcon
                        color: Theme.foreground
                        font.pixelSize: 14
                    }
                }
            }
        }
    }
}
