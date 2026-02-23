import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import ".."

Rectangle {
    id: root

    property var taskData: ({})
    signal toggleTask(string taskId)
    signal deleteTask(string taskId)
    signal editTask(string taskId, string title, string description)

    height: 88
    radius: Theme.radius.md
    color: taskArea.containsMouse ? Theme.colors.surfaceHover : Theme.colors.surface
    border.color: root.taskData.completed ? Theme.colors.success : Theme.colors.divider
    border.width: 1

    Behavior on color {
        ColorAnimation { duration: Theme.animation.fast }
    }

    Behavior on border.color {
        ColorAnimation { duration: Theme.animation.normal }
    }

    ScaleAnimator on scale {
        id: completeAnimation
        running: false
        from: 1.0
        to: 1.05
        duration: 150
        easing.type: Easing.OutCubic
        onFinished: {
            scaleBack.from = 1.05
            scaleBack.start()
        }
    }

    ScaleAnimator on scale {
        id: scaleBack
        running: false
        from: 1.05
        to: 1.0
        duration: 150
        easing.type: Easing.OutCubic
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.spacing.md
        anchors.rightMargin: Theme.spacing.md
        spacing: Theme.spacing.md

        Rectangle {
            id: checkbox
            width: 28
            height: 28
            radius: Theme.radius.full
            color: root.taskData.completed ? Theme.colors.success : "transparent"
            border.color: root.taskData.completed ? Theme.colors.success : Theme.colors.textMuted
            border.width: 2

            Behavior on color {
                ColorAnimation { duration: Theme.animation.fast }
            }

            Behavior on border.color {
                ColorAnimation { duration: Theme.animation.fast }
            }

            Text {
                anchors.centerIn: parent
                text: "✓"
                color: "white"
                font.pixelSize: 16
                font.bold: true
                font.family: Theme.fontFamily
                visible: root.taskData.completed
                opacity: root.taskData.completed ? 1 : 0

                Behavior on opacity {
                    NumberAnimation { duration: Theme.animation.fast }
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    completeAnimation.start()
                    root.toggleTask(root.taskData.id)
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing.xs

            Text {
                text: root.taskData.title || "Untitled Task"
                color: root.taskData.completed ? Theme.colors.textMuted : Theme.colors.text
                font.pixelSize: Theme.typography.body
                font.strikeout: root.taskData.completed
                font.family: Theme.fontFamily
                elide: Text.ElideRight
                Layout.fillWidth: true

                Behavior on color {
                    ColorAnimation { duration: Theme.animation.fast }
                }
            }

            Text {
                text: root.taskData.description || ""
                color: Theme.colors.textMuted
                font.pixelSize: Theme.typography.caption
                font.family: Theme.fontFamily
                elide: Text.ElideRight
                Layout.fillWidth: true
                visible: text.length > 0
            }

            RowLayout {
                spacing: Theme.spacing.sm

                Rectangle {
                    visible: root.taskData.pomodoros_completed > 0
                    height: 20
                    radius: Theme.radius.full
                    color: Theme.colors.surfaceActive

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: Theme.spacing.sm
                        anchors.rightMargin: Theme.spacing.sm
                        spacing: Theme.spacing.xs

                        Text {
                            text: "🍅"
                            font.pixelSize: 12
                        }

                        Text {
                            text: root.taskData.pomodoros_completed.toString()
                            color: Theme.colors.textSecondary
                            font.pixelSize: Theme.typography.tiny
                            font.family: Theme.fontFamily
                        }
                    }
                }

                Text {
                    text: Qt.formatDateTime(new Date(root.taskData.created_at), "MMM d")
                    color: Theme.colors.textMuted
                    font.pixelSize: Theme.typography.tiny
                    font.family: Theme.fontFamily
                    visible: root.taskData.created_at
                }
            }
        }

        Rectangle {
            width: 32
            height: 32
            radius: Theme.radius.sm
            color: deleteArea.containsMouse ? Theme.colors.error + "20" : "transparent"

            Text {
                anchors.centerIn: parent
                text: "🗑"
                color: deleteArea.containsMouse ? Theme.colors.error : Theme.colors.textMuted
                font.pixelSize: 16
                font.family: Theme.fontFamily
            }

            MouseArea {
                id: deleteArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.deleteTask(root.taskData.id)
            }
        }
    }

    MouseArea {
        id: taskArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
    }
}
