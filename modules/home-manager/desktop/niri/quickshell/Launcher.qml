import QtQuick
import QtQml
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import "."

PanelWindow {
    id: root

    readonly property var targetScreen: Quickshell.screens.values.length > 0 ? Quickshell.screens.values[0] : null
    property var filteredEntries: []
    property int selectedIndex: 0
    readonly property string query: input.text.trim().toLowerCase()
    readonly property bool hasQuery: query.length > 0
    readonly property int resultCount: filteredEntries.length

    screen: targetScreen
    visible: false
    focusable: true
    aboveWindows: true
    exclusiveZone: 0
    color: Qt.rgba(0, 0, 0, 0)
    surfaceFormat.opaque: false

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    implicitHeight: targetScreen ? targetScreen.height : 900

    function fuzzyScore(text, normalizedQuery) {
        if (!text || !normalizedQuery) {
            return -1;
        }

        var normalizedText = text.toLowerCase();
        var queryIndex = 0;
        var firstMatch = -1;
        var previousMatch = -2;
        var gaps = 0;

        for (var i = 0; i < normalizedText.length && queryIndex < normalizedQuery.length; i++) {
            if (normalizedText[i] !== normalizedQuery[queryIndex]) {
                continue;
            }

            if (firstMatch === -1) {
                firstMatch = i;
            }

            if (previousMatch >= 0) {
                gaps += i - previousMatch - 1;
            }

            previousMatch = i;
            queryIndex++;
        }

        if (queryIndex !== normalizedQuery.length) {
            return -1;
        }

        return firstMatch * 10 + gaps;
    }

    function scoreEntry(entry, normalizedQuery) {
        var name = (entry.name || "").toLowerCase();
        var genericName = (entry.genericName || "").toLowerCase();
        var id = (entry.id || "").toLowerCase();
        var keywords = entry.keywords ? entry.keywords.join(" ").toLowerCase() : "";
        var nameFuzzy = root.fuzzyScore(entry.name || "", normalizedQuery);
        var genericFuzzy = root.fuzzyScore(entry.genericName || "", normalizedQuery);
        var idFuzzy = root.fuzzyScore(entry.id || "", normalizedQuery);

        if (name === normalizedQuery) return 0;
        if (name.startsWith(normalizedQuery)) return 1;
        if (genericName.startsWith(normalizedQuery)) return 2;
        if (keywords.indexOf(normalizedQuery) !== -1) return 3;
        if (name.indexOf(normalizedQuery) !== -1) return 4;
        if (genericName.indexOf(normalizedQuery) !== -1) return 5;
        if (id.indexOf(normalizedQuery) !== -1) return 6;
        if (nameFuzzy >= 0) return 100 + nameFuzzy;
        if (genericFuzzy >= 0) return 200 + genericFuzzy;
        if (idFuzzy >= 0) return 300 + idFuzzy;
        return -1;
    }

    function updateResults() {
        if (!root.hasQuery) {
            root.filteredEntries = [];
            root.selectedIndex = 0;
            return;
        }

        var scored = DesktopEntries.applications.values.map(function(entry) {
            return {
                entry: entry,
                score: root.scoreEntry(entry, root.query)
            };
        }).filter(function(item) {
            return item.score >= 0;
        }).sort(function(a, b) {
            if (a.score !== b.score) {
                return a.score - b.score;
            }

            return a.entry.name.localeCompare(b.entry.name);
        }).slice(0, 5).map(function(item) {
            return item.entry;
        });

        root.filteredEntries = scored;
        root.selectedIndex = Math.min(root.selectedIndex, Math.max(0, scored.length - 1));
    }

    function activateSelection() {
        if (root.resultCount < 1) {
            return;
        }

        root.filteredEntries[root.selectedIndex].execute();
        root.hideLauncher();
    }

    function moveSelection(step) {
        if (root.resultCount < 1) {
            return;
        }

        root.selectedIndex = (root.selectedIndex + step + root.resultCount) % root.resultCount;
    }

    Connections {
        target: DesktopEntries

        function onApplicationsChanged() {
            root.updateResults();
        }
    }

    Item {
        anchors.fill: parent

        MouseArea {
            anchors.fill: parent
            onClicked: root.hideLauncher()
        }

        Rectangle {
            width: 640
            height: 72 + (root.hasQuery ? root.resultCount * 52 : 0)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: targetScreen ? Math.round(targetScreen.height / 3) : 320
            radius: 10
            color: Theme.surface
            border.width: 1
            border.color: Theme.border

            MouseArea {
                anchors.fill: parent
            }

            TextInput {
                id: input

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                height: 72
                color: Theme.foreground
                selectionColor: Theme.accent
                selectedTextColor: Theme.background
                verticalAlignment: TextInput.AlignVCenter
                font.pixelSize: 22
                clip: true

                onTextChanged: {
                    root.selectedIndex = 0;
                    root.updateResults();
                }
                Keys.onDownPressed: root.moveSelection(1)
                Keys.onUpPressed: root.moveSelection(-1)
                Keys.onReturnPressed: root.activateSelection()
                Keys.onEnterPressed: root.activateSelection()
                Keys.onEscapePressed: root.hideLauncher()
            }

            Text {
                x: 20
                y: 0
                width: parent.width - 40
                height: 72
                verticalAlignment: Text.AlignVCenter
                text: input.text.length === 0 ? "Search apps" : ""
                color: Theme.foreground
                opacity: 0.55
                font.pixelSize: 22
            }

            Column {
                x: 12
                y: 72
                width: parent.width - 24
                spacing: 4
                visible: root.hasQuery && root.resultCount > 0

                Repeater {
                    model: root.filteredEntries

                    Rectangle {
                        required property var modelData
                        required property int index
                        readonly property bool selected: index === root.selectedIndex

                        width: parent.width
                        height: 48
                        radius: 8
                        color: selected ? Theme.accent : Theme.surface

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: root.selectedIndex = parent.index
                            onClicked: {
                                modelData.execute();
                                root.hideLauncher();
                            }
                        }

                        Image {
                            id: appIcon

                            anchors.left: parent.left
                            anchors.leftMargin: 12
                            anchors.verticalCenter: parent.verticalCenter
                            width: 22
                            height: 22
                            source: Quickshell.iconPath(modelData.icon || "application-x-executable", "application-x-executable")
                            sourceSize.width: width
                            sourceSize.height: height
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }

                        Text {
                            anchors.left: appIcon.right
                            anchors.leftMargin: 12
                            anchors.right: parent.right
                            anchors.rightMargin: 12
                            anchors.verticalCenter: parent.verticalCenter
                            text: modelData.name
                            color: selected ? Theme.background : Theme.foreground
                            elide: Text.ElideRight
                            font.pixelSize: 18
                        }
                    }
                }
            }
        }
    }

    function showLauncher(): void {
        root.visible = true;
        root.updateResults();
        Qt.callLater(function() {
            input.forceActiveFocus();
            input.selectAll();
        });
    }

    function hideLauncher(): void {
        root.visible = false;
        input.text = "";
    }

    function toggleLauncher(): void {
        if (root.visible) {
            root.hideLauncher();
        } else {
            root.showLauncher();
        }
    }

    IpcHandler {
        target: "launcher"

        function show(): void {
            root.showLauncher();
        }

        function hide(): void {
            root.hideLauncher();
        }

        function toggle(): void {
            root.toggleLauncher();
        }
    }
}
