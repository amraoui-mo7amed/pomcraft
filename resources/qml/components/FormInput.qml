import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import ".."

ColumnLayout {
    id: root
    spacing: 6

    property string label: ""
    property string placeholder: ""
    property string icon: ""
    property alias text: input.text
    property alias inputMethodHints: input.inputMethodHints
    property bool error: false
    property string errorMessage: ""

    Text {
        text: root.label
        color: input.activeFocus ? Theme.colors.primary : Theme.colors.textSecondary
        font.pixelSize: 11
        font.weight: Font.Bold
        font.family: Theme.fontFamily
        visible: text !== ""

        Behavior on color { ColorAnimation { duration: 200 } }
    }

    Rectangle {
        Layout.fillWidth: true
        height: 44
        radius: Theme.radius.md
        color: Theme.colors.background
        border.width: 1
        border.color: {
            if (root.error) return Theme.colors.error
            if (input.activeFocus) return Theme.colors.primary
            return Theme.colors.divider
        }

        Behavior on border.color { ColorAnimation { duration: 200 } }

        // Glow effect on focus
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.width: 2
            border.color: Theme.colors.primary
            opacity: input.activeFocus ? 0.15 : 0
            scale: input.activeFocus ? 1.02 : 1.0

            Behavior on opacity { NumberAnimation { duration: 200 } }
            Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: Theme.spacing.md
            anchors.rightMargin: Theme.spacing.md
            spacing: Theme.spacing.sm

            Text {
                visible: root.icon !== ""
                text: root.icon
                font.family: Theme.iconFontFamily
                font.pixelSize: 14
                color: input.activeFocus ? Theme.colors.primary : Theme.colors.textMuted
                
                Behavior on color { ColorAnimation { duration: 200 } }
            }

            TextInput {
                id: input
                Layout.fillWidth: true
                verticalAlignment: TextInput.AlignVCenter
                color: Theme.colors.text
                font.pixelSize: 14
                font.family: Theme.fontFamily
                selectByMouse: true
                clip: true

                Text {
                    text: root.placeholder
                    color: Theme.colors.textMuted
                    font.pixelSize: 14
                    font.family: Theme.fontFamily
                    visible: !input.text && !input.activeFocus
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    Text {
        text: root.errorMessage
        color: Theme.colors.error
        font.pixelSize: 10
        visible: root.error && text !== ""
    }
}
