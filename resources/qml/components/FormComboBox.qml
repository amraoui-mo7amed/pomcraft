import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import ".."

ColumnLayout {
    id: root
    spacing: 6

    property string label: ""
    property alias model: control.model
    property alias currentIndex: control.currentIndex
    property alias textRole: control.textRole

    Text {
        text: root.label
        color: control.activeFocus ? Theme.colors.primary : Theme.colors.textSecondary
        font.pixelSize: 11
        font.weight: Font.Bold
        font.family: Theme.fontFamily
        visible: text !== ""

        Behavior on color { ColorAnimation { duration: 200 } }
    }

    ComboBox {
        id: control
        Layout.fillWidth: true
        implicitHeight: 44

        delegate: ItemDelegate {
            width: control.width
            contentItem: Text {
                text: modelData || (textRole ? model[textRole] : "")
                color: Theme.colors.text
                font.family: Theme.fontFamily
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                color: highlighted ? Theme.colors.surfaceActive : "transparent"
            }
            highlighted: control.highlightedIndex === index
        }

        indicator: Text {
            x: control.width - width - Theme.spacing.md
            y: (control.height - height) / 2
            text: Theme.icons.arrowDown
            font.family: Theme.iconFontFamily
            font.pixelSize: 12
            color: control.activeFocus ? Theme.colors.primary : Theme.colors.textMuted
            
            Behavior on rotation { NumberAnimation { duration: 200 } }
            rotation: control.opened ? 180 : 0
        }

        contentItem: Text {
            leftPadding: Theme.spacing.md
            rightPadding: control.indicator.width + Theme.spacing.md
            text: control.displayText
            font.family: Theme.fontFamily
            font.pixelSize: 14
            color: Theme.colors.text
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            implicitWidth: 120
            implicitHeight: 44
            color: Theme.colors.background
            border.color: control.activeFocus ? Theme.colors.primary : Theme.colors.divider
            border.width: 1
            radius: Theme.radius.md

            Behavior on border.color { ColorAnimation { duration: 200 } }

            // Glow effect on focus
            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: "transparent"
                border.width: 2
                border.color: Theme.colors.primary
                opacity: control.activeFocus ? 0.15 : 0
                scale: control.activeFocus ? 1.02 : 1.0

                Behavior on opacity { NumberAnimation { duration: 200 } }
                Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }
            }
        }

        popup: Popup {
            y: control.height + 5
            width: control.width
            implicitHeight: contentItem.implicitHeight + 10
            padding: 5

            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight
                model: control.popup.visible ? control.delegateModel : null
                currentIndex: control.highlightedIndex

                ScrollIndicator.vertical: ScrollIndicator { }
            }

            background: Rectangle {
                color: Theme.colors.surface
                border.color: Theme.colors.divider
                radius: Theme.radius.md
                
                // Subtle shadow/glow
                layer.enabled: true
                layer.effect: ShaderEffect {
                    // This is a placeholder for a real shadow effect if needed
                }
            }
        }
    }
}
