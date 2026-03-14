import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import ".."

Rectangle {
    id: root

    property var projectData: ({})
    property var projectTasks: []
    visible: false

    opacity: visible ? 1 : 0
    scale: visible ? 1 : 0.98
    Behavior on opacity {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }
    Behavior on scale {
        NumberAnimation {
            duration: 250
            easing.type: Easing.OutBack
        }
    }

    anchors.fill: parent
    color: Theme.colors.background // Changed to solid background to fix mess
    z: 1000

    MouseArea {
        anchors.fill: parent
        onClicked: {}
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.spacing.xl
        spacing: Theme.spacing.lg

        // Header
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing.xl

            ColumnLayout {
                spacing: 2
                Text {
                    text: root.projectData.title || ""
                    color: Theme.colors.text
                    font.pixelSize: 28
                    font.bold: true
                    font.family: Theme.fontFamily
                }
                Text {
                    text: (root.projectData.headline || "Project Workspace") + " • " + (root.projectData.client_name || "Internal")
                    color: Theme.colors.primary
                    font.pixelSize: 13
                    font.weight: Font.Medium
                }
            }

            Item {
                Layout.fillWidth: true
            }

            // Tab Switcher
            Rectangle {
                height: 40
                width: 180
                radius: 20
                color: Theme.colors.surface
                border.width: 1
                border.color: Theme.colors.divider

                RowLayout {
                    anchors.fill: parent
                    spacing: 0

                    Repeater {
                        model: ["Details", "Tasks"]
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 20
                            color: tabStack.currentIndex === index ? Theme.colors.primary : "transparent"

                            Text {
                                anchors.centerIn: parent
                                text: modelData
                                color: tabStack.currentIndex === index ? "white" : Theme.colors.textSecondary
                                font.bold: tabStack.currentIndex === index
                                font.pixelSize: 12
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: tabStack.currentIndex = index
                            }
                        }
                    }
                }
            }

            // Close Button
            Rectangle {
                width: 36
                height: 36
                radius: 18
                color: closeHover.containsMouse ? Theme.colors.error : Theme.colors.surface

                Text {
                    anchors.centerIn: parent
                    text: Theme.icons.close
                    font.family: Theme.iconFontFamily
                    color: closeHover.containsMouse ? "white" : Theme.colors.text
                    font.pixelSize: 14
                }

                MouseArea {
                    id: closeHover
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: root.visible = false
                }
            }
        }

        // Content Area
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Theme.spacing.lg

            StackLayout {
                id: tabStack
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: 0

                MarkdownWorkspace {
                    text: root.projectData.details_markdown || ""
                    placeholder: "# Project README\nAdd goals, resources, and notes here..."
                    onContentUpdated: newText => {
                        ProjectsBackend.updateProjectMarkdown(root.projectData.id, "details", newText);
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: Theme.spacing.md

                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: "Project Tasks (" + root.projectTasks.length + ")"
                            color: Theme.colors.text
                            font.pixelSize: 18
                            font.bold: true
                            font.family: Theme.fontFamily
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        Rectangle {
                            height: 32
                            width: 100
                            radius: 16
                            color: addTaskArea.containsMouse ? Theme.colors.primaryHover : Theme.colors.primary
                            Text {
                                anchors.centerIn: parent
                                text: "+ Add Task"
                                color: "white"
                                font.pixelSize: 12
                                font.bold: true
                            }
                            MouseArea {
                                id: addTaskArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: addTaskPopup.visible = true
                            }
                        }
                    }

                    ScrollView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        ScrollBar.vertical.policy: ScrollBar.AsNeeded

                        ColumnLayout {
                            width: parent.width - 20
                            spacing: Theme.spacing.sm

                            Repeater {
                                model: root.projectTasks
                                Rectangle {
                                    Layout.fillWidth: true
                                    height: 50
                                    radius: 8
                                    color: Theme.colors.surface
                                    border.color: Theme.colors.divider
                                    border.width: 1

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: Theme.spacing.md
                                        spacing: Theme.spacing.md

                                        Rectangle {
                                            width: 20
                                            height: 20
                                            radius: 4
                                            color: modelData.completed ? Theme.colors.success : "transparent"
                                            border.color: modelData.completed ? Theme.colors.success : Theme.colors.textMuted
                                            border.width: 2
                                            Text {
                                                anchors.centerIn: parent
                                                text: modelData.completed ? Theme.icons.check : ""
                                                font.family: Theme.iconFontFamily
                                                color: "white"
                                                font.pixelSize: 10
                                            }
                                            MouseArea {
                                                anchors.fill: parent
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: ProjectTasksBackend.toggleTask(modelData.id)
                                            }
                                        }

                                        Text {
                                            Layout.fillWidth: true
                                            text: modelData.title
                                            color: modelData.completed ? Theme.colors.textMuted : Theme.colors.text
                                            font.pixelSize: 14
                                            font.strikeout: modelData.completed
                                            elide: Text.ElideRight
                                        }

                                        MouseArea {
                                            width: 24
                                            height: 24
                                            cursorShape: Qt.PointingHandCursor
                                            Text {
                                                anchors.centerIn: parent
                                                text: Theme.icons.trash
                                                font.family: Theme.iconFontFamily
                                                color: parent.containsMouse ? Theme.colors.error : Theme.colors.textMuted
                                                font.pixelSize: 14
                                            }
                                            onClicked: ProjectTasksBackend.deleteTask(modelData.id)
                                        }
                                    }
                                }
                            }

                            Item {
                                visible: root.projectTasks.length === 0
                                Layout.fillWidth: true
                                height: 200
                                Column {
                                    anchors.centerIn: parent
                                    spacing: 10
                                    Text {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: Theme.icons.tasks
                                        font.family: Theme.iconFontFamily
                                        font.pixelSize: 48
                                        color: Theme.colors.textMuted
                                        opacity: 0.3
                                    }
                                    Text {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "Click '+ Add Task' to create one!"
                                        color: Theme.colors.textMuted
                                        font.pixelSize: 14
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Sidebar
            ScrollView {
                Layout.preferredWidth: 300
                Layout.fillHeight: true
                clip: true
                ScrollBar.vertical.policy: ScrollBar.AsNeeded

                ColumnLayout {
                    width: parent.width - 20
                    spacing: Theme.spacing.lg

                    DetailsSidebar {
                        projectData: root.projectData
                        Layout.fillWidth: true
                    }
                }
            }
        }

        // Footer
        RowLayout {
            Layout.fillWidth: true
            Text {
                text: "Last modified: " + (root.projectData.updated_at ? root.projectData.updated_at.replace("T", " ").substring(0, 16) : "Just now")
                color: Theme.colors.textMuted
                font.pixelSize: 11
            }
            Item {
                Layout.fillWidth: true
            }
            Text {
                text: root.projectTasks.length + " task" + (root.projectTasks.length !== 1 ? "s" : "")
                color: Theme.colors.primary
                font.pixelSize: 11
            }
        }
    }

    // Modal
    Rectangle {
        id: addTaskPopup
        anchors.fill: parent
        visible: false
        color: Qt.rgba(0, 0, 0, 0.7)
        z: 3000

        MouseArea {
            anchors.fill: parent
        }

        Rectangle {
            width: 440
            height: 200
            radius: 16
            color: Theme.colors.surface
            anchors.centerIn: parent
            border.color: Theme.colors.divider

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 20

                Text {
                    text: "Add New Task"
                    color: Theme.colors.text
                    font.pixelSize: 20
                    font.bold: true
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 48
                    radius: 8
                    color: Theme.colors.background
                    border.color: taskIn.activeFocus ? Theme.colors.primary : Theme.colors.divider

                    TextInput {
                        id: taskIn
                        anchors.fill: parent
                        anchors.margins: 12
                        verticalAlignment: TextInput.AlignVCenter
                        color: Theme.colors.text
                        font.pixelSize: 14
                        focus: addTaskPopup.visible

                        Text {
                            text: "Enter task title..."
                            color: Theme.colors.textMuted
                            visible: !parent.text && !parent.activeFocus
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12
                    Item {
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        height: 36
                        width: 80
                        radius: 8
                        color: Theme.colors.surfaceActive
                        Text {
                            anchors.centerIn: parent
                            text: "Cancel"
                            color: Theme.colors.textSecondary
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: addTaskPopup.visible = false
                            cursorShape: Qt.PointingHandCursor
                        }
                    }

                    Rectangle {
                        height: 36
                        width: 80
                        radius: 8
                        color: Theme.colors.primary
                        Text {
                            anchors.centerIn: parent
                            text: "Add"
                            color: "white"
                            font.bold: true
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (taskIn.text.trim()) {
                                    ProjectTasksBackend.addTask(root.projectData.id, taskIn.text.trim());
                                    taskIn.text = "";
                                    addTaskPopup.visible = false;
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    onProjectDataChanged: {
        if (projectData && projectData.id) {
            root.projectTasks = ProjectTasksBackend.getProjectTasks(projectData.id);
        }
    }

    Connections {
        target: ProjectTasksBackend
        function onProjectTasksChanged(projectId) {
            if (root.projectData && root.projectData.id === projectId) {
                root.projectTasks = ProjectTasksBackend.getProjectTasks(projectId);
            }
        }
    }
}
