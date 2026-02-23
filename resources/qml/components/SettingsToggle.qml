import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import ".."

RowLayout {
    id: root

    property string label: ""
    property string description: ""
    property bool checked: false
    signal toggled(bool newChecked)

    spacing: Theme.spacing.md

    ColumnLayout {
        Layout.fillWidth: true
        spacing: Theme.spacing.xs

        Text {
            text: root.label
            color: Theme.colors.text
            font.pixelSize: Theme.typography.body
            font.family: Theme.fontFamily
        }

        Text {
            text: root.description
            color: Theme.colors.textMuted
            font.pixelSize: Theme.typography.caption
            font.family: Theme.fontFamily
            visible: text.length > 0
        }
    }

    Rectangle {
        id: toggleSwitch
        width: 52
        height: 28
        radius: Theme.radius.full
        color: root.checked ? Theme.colors.primary : Theme.colors.surfaceActive

        Behavior on color {
            ColorAnimation { duration: Theme.animation.fast }
        }

        Rectangle {
            x: root.checked ? parent.width - width - 4 : 4
            anchors.verticalCenter: parent.verticalCenter
            width: 20
            height: 20
            radius: Theme.radius.full
            color: "white"

            Behavior on x {
                NumberAnimation { duration: Theme.animation.fast; easing.type: Easing.OutCubic }
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.toggled(!root.checked)
        }
    }
}
