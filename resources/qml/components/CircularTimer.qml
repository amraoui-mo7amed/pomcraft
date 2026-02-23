import QtQuick 2.15
import QtQuick.Controls 2.15
import ".."

Item {
    id: root

    property real size: 280
    property real strokeWidth: 10
    property real progress: 0.0
    property string timeText: "25:00"
    property color sessionColor: Theme.colors.primary

    implicitWidth: size
    implicitHeight: size

    Rectangle {
        id: backgroundCircle
        anchors.centerIn: parent
        width: root.size
        height: root.size
        radius: root.size / 2
        color: "transparent"
        border.color: Theme.colors.surfaceHover
        border.width: root.strokeWidth

        Behavior on border.color {
            ColorAnimation { duration: Theme.animation.normal }
        }
    }

    Canvas {
        id: progressCanvas
        anchors.centerIn: parent
        width: root.size
        height: root.size

        property real progressValue: root.progress

        Behavior on progressValue {
            NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
        }

        onProgressValueChanged: requestPaint()

        onPaint: {
            const ctx = getContext("2d")
            ctx.reset()

            const centerX = width / 2
            const centerY = height / 2
            const radius = (width - root.strokeWidth) / 2
            const startAngle = -Math.PI / 2
            const endAngle = startAngle + (2 * Math.PI * progressValue)

            ctx.beginPath()
            ctx.arc(centerX, centerY, radius, startAngle, endAngle)
            ctx.strokeStyle = root.sessionColor
            ctx.lineWidth = root.strokeWidth
            ctx.lineCap = "round"
            ctx.stroke()
        }
    }

    Rectangle {
        id: innerCircle
        anchors.centerIn: parent
        width: root.size - (root.strokeWidth * 2) - 20
        height: root.size - (root.strokeWidth * 2) - 20
        radius: width / 2
        color: Theme.colors.card

        Behavior on color {
            ColorAnimation { duration: Theme.animation.normal }
        }

        Column {
            anchors.centerIn: parent
            spacing: Theme.spacing.xs

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.timeText
                color: Theme.colors.text
                font.pixelSize: 64
                font.bold: true
                font.family: Theme.fontFamily

                Behavior on text {
                    enabled: true
                    PropertyAnimation { duration: 100 }
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "remaining"
                color: Theme.colors.textMuted
                font.pixelSize: Theme.typography.caption
                font.family: Theme.fontFamily
            }
        }

        SequentialAnimation {
            id: pulseGlow
            running: root.progress > 0 && root.progress < 1
            loops: Animation.Infinite

            NumberAnimation {
                target: innerCircle
                property: "scale"
                from: 1.0
                to: 1.02
                duration: 2000
                easing.type: Easing.InOutSine
            }

            NumberAnimation {
                target: innerCircle
                property: "scale"
                from: 1.02
                to: 1.0
                duration: 2000
                easing.type: Easing.InOutSine
            }
        }
    }
}
