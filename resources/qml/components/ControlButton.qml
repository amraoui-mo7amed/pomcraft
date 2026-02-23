import QtQuick 2.15
import QtQuick.Controls 2.15
import ".."

Rectangle {
    id: root

    property string icon: "▶"
    property string tooltip: ""
    signal clicked()

    width: 48
    height: 48
    radius: Theme.radius.full
    color: area.containsMouse ? Theme.colors.surfaceActive : Theme.colors.surface
    border.color: Theme.colors.divider
    border.width: 1

    Behavior on color {
        ColorAnimation { duration: Theme.animation.fast }
    }

    ScaleAnimator on scale {
        running: area.pressed
        from: 1.0
        to: 0.95
        duration: 50
    }

    ScaleAnimator on scale {
        running: !area.pressed
        from: 0.95
        to: 1.0
        duration: 100
    }

    Text {
        anchors.centerIn: parent
        text: root.icon
        color: Theme.colors.textSecondary
        font.pixelSize: 18
        font.family: Theme.fontFamily
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }

    ToolTip {
        visible: root.tooltip && area.containsMouse
        text: root.tooltip
        delay: 500
    }
}
