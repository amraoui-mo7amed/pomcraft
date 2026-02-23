import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import ".."
import "../components"

Item {
    id: root

    signal sessionChanged(string session)

    property string timeDisplay: TimerBackend.getTime()
    property real progress: TimerBackend.getProgress()
    property string currentSession: TimerBackend.getSession()
    property string timerState: TimerBackend.getState()

    Rectangle {
        anchors.fill: parent
        color: Theme.colors.background
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: Theme.spacing.xxl

        ColumnLayout {
            spacing: Theme.spacing.md
            Layout.alignment: Qt.AlignHCenter

            Rectangle {
                id: sessionPill
                Layout.alignment: Qt.AlignHCenter
                width: sessionLabel.implicitWidth + Theme.spacing.lg
                height: 36
                radius: Theme.radius.full
                color: Theme.getSessionColor(root.currentSession)

                Behavior on color {
                    ColorAnimation { duration: Theme.animation.normal }
                }

                Text {
                    id: sessionLabel
                    anchors.centerIn: parent
                    text: Theme.getSessionLabel(root.currentSession)
                    color: "white"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    font.family: Theme.fontFamily
                }
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "Session #" + (TimerBackend.getCompletedSessions() + 1)
                color: Theme.colors.textMuted
                font.pixelSize: Theme.typography.caption
                font.family: Theme.fontFamily
            }
        }

        CircularTimer {
            id: circularTimer
            Layout.alignment: Qt.AlignHCenter
            size: 320
            strokeWidth: 12
            progress: root.progress
            timeText: root.timeDisplay
            sessionColor: Theme.getSessionColor(root.currentSession)

            Behavior on progress {
                NumberAnimation { duration: 1000; easing.type: Easing.OutCubic }
            }
        }

        ColumnLayout {
            spacing: Theme.spacing.md
            Layout.alignment: Qt.AlignHCenter

            RowLayout {
                spacing: Theme.spacing.md
                Layout.alignment: Qt.AlignHCenter

                ControlButton {
                    icon: "↺"
                    onClicked: TimerBackend.reset()
                    tooltip: "Reset"
                }

                Rectangle {
                    id: playPauseBtn
                    width: 72
                    height: 72
                    radius: Theme.radius.full
                    color: playPauseArea.containsMouse ? Theme.colors.primaryHover : Theme.colors.primary

                    Behavior on color {
                        ColorAnimation { duration: Theme.animation.fast }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: root.timerState === "running" ? "❚❚" : "▶"
                        color: "white"
                        font.pixelSize: 28
                        font.family: Theme.fontFamily
                    }

                    RotationAnimation on rotation {
                        id: playAnimation
                        running: false
                        from: 0
                        to: 360
                        duration: Theme.animation.fast
                    }

                    ScaleAnimator on scale {
                        id: pulseAnimation
                        running: root.timerState === "running"
                        from: 1.0
                        to: 1.05
                        duration: 1000
                        easing.type: Easing.InOutSine
                        loops: Animation.Infinite
                    }

                    MouseArea {
                        id: playPauseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (root.timerState === "running") {
                                TimerBackend.pause()
                            } else {
                                TimerBackend.start()
                            }
                        }
                    }
                }

                ControlButton {
                    icon: "⏭"
                    onClicked: TimerBackend.skip()
                    tooltip: "Skip"
                }
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: root.timerState === "running" ? "Focus time!" : root.timerState === "paused" ? "Paused" : "Ready to start"
                color: Theme.colors.textSecondary
                font.pixelSize: Theme.typography.bodySmall
                font.family: Theme.fontFamily

                Behavior on text {
                    enabled: true
                    PropertyAnimation { duration: Theme.animation.fast }
                }
            }
        }
    }

    Connections {
        target: TimerBackend
        function onTimeChanged(time) {
            root.timeDisplay = time
        }
        function onProgressChanged(p) {
            root.progress = p
        }
        function onSessionChanged(session) {
            root.currentSession = session
            root.sessionChanged(session)
        }
        function onStateChanged(state) {
            root.timerState = state
        }
    }
}
