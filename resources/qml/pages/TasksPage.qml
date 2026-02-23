import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import ".."
import "../components"

Item {
    id: root

    property var tasks: TasksBackend.getTasks()

    Rectangle {
        anchors.fill: parent
        color: Theme.colors.background
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.spacing.xl
        spacing: Theme.spacing.lg

        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing.md

            Text {
                text: "Tasks"
                color: Theme.colors.text
                font.pixelSize: Theme.typography.h3
                font.bold: true
                font.family: Theme.fontFamily
            }

            Item { Layout.fillWidth: true }

            Text {
                text: TasksBackend.getCompletedCount() + "/" + TasksBackend.getTaskCount() + " completed"
                color: Theme.colors.textSecondary
                font.pixelSize: Theme.typography.bodySmall
                font.family: Theme.fontFamily
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 56
            radius: Theme.radius.md
            color: Theme.colors.surface
            border.color: Theme.colors.divider
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Theme.spacing.md
                anchors.rightMargin: Theme.spacing.md
                spacing: Theme.spacing.md

                Text {
                    text: "🔍"
                    color: Theme.colors.textMuted
                    font.pixelSize: 18
                    font.family: Theme.fontFamily
                }

                TextField {
                    id: searchInput
                    Layout.fillWidth: true
                    placeholderText: "Search tasks..."
                    color: Theme.colors.text
                    font.pixelSize: Theme.typography.body
                    font.family: Theme.fontFamily
                    selectByMouse: true
                    background: null

                    ColorAnimation on color {
                        duration: Theme.animation.fast
                    }
                }
            }
        }

        ListView {
            id: taskList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: Theme.spacing.sm
            model: root.tasks

            add: Transition {
                NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Theme.animation.normal }
                NumberAnimation { property: "y"; from: 20; duration: Theme.animation.normal }
            }

            remove: Transition {
                NumberAnimation { property: "opacity"; to: 0; duration: Theme.animation.fast }
                NumberAnimation { property: "scale"; to: 0.9; duration: Theme.animation.fast }
            }

            displaced: Transition {
                NumberAnimation { property: "y"; duration: Theme.animation.normal; easing.type: Easing.OutCubic }
            }

            delegate: TaskCard {
                width: taskList.width
                taskData: modelData
                onToggleTask: function(taskId) {
                    TasksBackend.toggleTask(taskId)
                }
                onDeleteTask: function(taskId) {
                    TasksBackend.deleteTask(taskId)
                }
                onEditTask: function(taskId, title, description) {
                    TasksBackend.updateTask(taskId, title, description)
                }
            }

            Text {
                anchors.centerIn: parent
                visible: taskList.count === 0
                text: "No tasks yet\n\nClick the + button to add a task"
                color: Theme.colors.textMuted
                font.pixelSize: Theme.typography.body
                font.family: Theme.fontFamily
                horizontalAlignment: Text.AlignHCenter
            }
        }

        Rectangle {
            id: addTaskBtn
            Layout.alignment: Qt.AlignRight
            width: 56
            height: 56
            radius: Theme.radius.full
            color: addTaskArea.containsMouse ? Theme.colors.primaryHover : Theme.colors.primary

            Behavior on scale {
                NumberAnimation { duration: Theme.animation.fast }
            }

            scale: addTaskArea.pressed ? 0.95 : 1.0

            Text {
                anchors.centerIn: parent
                text: "+"
                color: "white"
                font.pixelSize: 32
                font.family: Theme.fontFamily
            }

            MouseArea {
                id: addTaskArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: addTaskDialog.open()
            }
        }
    }

    AddTaskDialog {
        id: addTaskDialog
        anchors.centerIn: parent
        onTaskAdded: function(title, description) {
            TasksBackend.addTask(title, description)
            root.tasks = TasksBackend.getTasks()
        }
    }

    Connections {
        target: TasksBackend
        function onTasksChanged() {
            root.tasks = TasksBackend.getTasks()
        }
    }
}
