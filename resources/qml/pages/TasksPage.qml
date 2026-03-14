import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import ".."
import "../components"
import "../components" as Components

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

        // Header
        RowLayout {
            Layout.fillWidth: true

            ColumnLayout {
                Text {
                    text: "Tasks"
                    color: Theme.colors.text
                    font.pixelSize: Theme.typography.h3
                    font.bold: true
                    font.family: Theme.fontFamily
                }
                Text {
                    text: "Manage your daily tasks"
                    color: Theme.colors.textSecondary
                    font.pixelSize: 12
                    font.family: Theme.fontFamily
                }
            }

            Item { Layout.fillWidth: true }

            // Add task button with popup
            Rectangle {
                id: addTaskBtn
                width: 44
                height: 44
                radius: 22
                color: addTaskBtnArea.containsMouse ? Theme.colors.primaryHover : Theme.colors.primary

                Text {
                    anchors.centerIn: parent
                    text: Theme.icons.plus
                    font.family: Theme.iconFontFamily
                    color: "white"
                    font.pixelSize: 18
                }

                MouseArea {
                    id: addTaskBtnArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: taskDialog.open()
                }
            }
        }

        // Stats Row
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing.md

            Rectangle {
                Layout.fillWidth: true
                height: 50
                radius: Theme.radius.md
                color: Theme.colors.surface

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.spacing.md

                    Text {
                        text: TasksBackend.getTaskCount().toString()
                        color: Theme.colors.primary
                        font.pixelSize: 20
                        font.bold: true
                    }
                    Text {
                        text: "Total Tasks"
                        color: Theme.colors.textSecondary
                        font.pixelSize: 13
                    }
                    Item { Layout.fillWidth: true }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 50
                radius: Theme.radius.md
                color: Theme.colors.surface

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.spacing.md

                    Text {
                        text: TasksBackend.getCompletedCount().toString()
                        color: Theme.colors.success
                        font.pixelSize: 20
                        font.bold: true
                    }
                    Text {
                        text: "Completed"
                        color: Theme.colors.textSecondary
                        font.pixelSize: 13
                    }
                    Item { Layout.fillWidth: true }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 50
                radius: Theme.radius.md
                color: Theme.colors.surface

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.spacing.md

                    Text {
                        text: (TasksBackend.getTaskCount() - TasksBackend.getCompletedCount()).toString()
                        color: Theme.colors.warning
                        font.pixelSize: 20
                        font.bold: true
                    }
                    Text {
                        text: "Pending"
                        color: Theme.colors.textSecondary
                        font.pixelSize: 13
                    }
                    Item { Layout.fillWidth: true }
                }
            }
        }

        // Tasks List
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            ScrollBar.vertical.policy: ScrollBar.AsNeeded

            ColumnLayout {
                width: parent.width - 20
                spacing: Theme.spacing.sm

                Repeater {
                    model: root.tasks

                    TaskCard {
                        Layout.fillWidth: true
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
                }
            }
        }
    }

    // Empty state
    Rectangle {
        anchors.fill: parent
        visible: root.tasks.length === 0
        color: "transparent"

        Column {
            anchors.centerIn: parent
            spacing: Theme.spacing.md

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: Theme.icons.tasks
                font.family: Theme.iconFontFamily
                font.pixelSize: 64
                color: Theme.colors.textMuted
                opacity: 0.4
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "No tasks yet. Click + to add one!"
                color: Theme.colors.textMuted
                font.pixelSize: 16
                font.family: Theme.fontFamily
            }
        }
    }

    // Add Task Dialog (Popup)
    AddTaskDialog {
        id: taskDialog

        onTaskAdded: function(title, description) {
            TasksBackend.addTask(title, description)
        }
    }

    Connections {
        target: TasksBackend
        function onTasksChanged() {
            root.tasks = TasksBackend.getTasks()
        }
    }
}
