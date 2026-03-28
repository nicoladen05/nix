import QtQuick
import "."

Text {
    required property date currentTime

    text: Qt.formatDateTime(currentTime, "hh:mm")
    color: Theme.foreground
    font.pixelSize: 14
}
