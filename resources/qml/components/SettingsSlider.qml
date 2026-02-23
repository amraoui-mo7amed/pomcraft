import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import ".."

ColumnLayout {
    id: root

    property string label: ""
    property real value: 25
    property real from: 1
    property real to: 60
    property string suffix: ""

    signal sliderValueChanged(real newValue)

    spacing: Theme.spacing.sm

    RowLayout {
        Layout.fillWidth: true

        Text {
            text: root.label
            color: Theme.colors.text
            font.pixelSize: Theme.typography.body
            font.family: Theme.fontFamily
        }

        Item { Layout.fillWidth: true }

        Text {
            text: Math.round(root.value) + root.suffix
            color: Theme.colors.primary
            font.pixelSize: Theme.typography.body
            font.weight: Font.Medium
            font.family: Theme.fontFamily
        }
    }

    Rectangle {
        Layout.fillWidth: true
        height: 8
        radius: Theme.radius.full
        color: Theme.colors.surfaceActive

        Rectangle {
            width: sliderHandle.x + sliderHandle.width / 2
            height: parent.height
            radius: parent.radius
            color: Theme.colors.primary

            Behavior on width {
                NumberAnimation { duration: Theme.animation.fast }
            }
        }

        Rectangle {
            id: sliderHandle
            property bool animationEnabled: true
            x: ((root.value - root.from) / (root.to - root.from)) * (parent.width - width)
            anchors.verticalCenter: parent.verticalCenter
            width: 20
            height: 20
            radius: Theme.radius.full
            color: Theme.colors.primary
            border.color: "white"
            border.width: 2

            Behavior on x {
                enabled: sliderHandle.animationEnabled
                NumberAnimation { duration: 50 }
            }

            ScaleAnimator on scale {
                running: sliderDrag.pressed
                from: 1.0
                to: 1.2
                duration: Theme.animation.fast
            }

            ScaleAnimator on scale {
                running: !sliderDrag.pressed
                from: 1.2
                to: 1.0
                duration: Theme.animation.fast
            }
        }

        MouseArea {
            id: sliderDrag
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            function updateValue(mouseX) {
                const percent = Math.max(0, Math.min(1, mouseX / sliderDrag.width))
                const newValue = root.from + (percent * (root.to - root.from))
                
                // Real-time smooth update for the handle and label
                root.value = newValue
                
                const roundedValue = Math.round(newValue)
                // Only emit signal when integer value changes to avoid backend overload
                if (root._lastEmittedValue !== roundedValue) {
                    root._lastEmittedValue = roundedValue
                    root.sliderValueChanged(roundedValue)
                }
            }

            onPressed: function(mouse) { 
                sliderHandle.animationEnabled = false
                updateValue(mouse.x) 
            }
            onPositionChanged: function(mouse) {
                if (pressed) updateValue(mouse.x)
            }
            onReleased: {
                sliderHandle.animationEnabled = true
            }
        }
    }

    property int _lastEmittedValue: Math.round(value)
}
