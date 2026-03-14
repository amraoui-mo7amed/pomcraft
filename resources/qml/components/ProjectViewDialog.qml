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
    color: Theme.colors.background // Fully opaque background
    z: 1000

    MouseArea {
        anchors.fill: parent
        onClicked: {} // Prevent click-through
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.spacing.xl
        spacing: Theme.spacing.lg

        // Header Section
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing.xl

            ColumnLayout {
                spacing: 2
                Text {
                    text: root.projectData.title || "Project"
                    color: Theme.colors.text
                    font.pixelSize: 32
                    font.bold: true
                    font.family: Theme.fontFamily
                }
                Text {
                    text: (root.projectData.headline || "Workspace") + " • " + (root.projectData.client_name || "Internal")
                    color: Theme.colors.primary
                    font.pixelSize: 14
                    font.family: Theme.fontFamily
                    font.weight: Font.Medium
                }
            }

            Item { Layout.fillWidth: true }

            // Tab Switcher
            Rectangle {
                height: 44
                width: 220
                radius: 22
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
                            radius: 22
                            color: tabStack.currentIndex === index ? Theme.colors.primary : "transparent"

                            Behavior on color { ColorAnimation { duration: 200 } }

                            Text {
                                anchors.centerIn: parent
                                text: modelData
                                color: tabStack.currentIndex === index ? "white" : Theme.colors.textSecondary
                                font.bold: tabStack.currentIndex === index
                                font.pixelSize: 13
                                font.family: Theme.fontFamily
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
                width: 44
                height: 44
                radius: 22
                color: closeArea.containsMouse ? Theme.colors.error : Theme.colors.surface

                Text {
                    anchors.centerIn: parent
                    text: Theme.icons.close
                    font.family: Theme.iconFontFamily
                    color: closeArea.containsMouse ? "white" : Theme.colors.text
                    font.pixelSize: 16
                }

                MouseArea {
                    id: closeArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.visible = false
                }
            }
        }

        // Main Layout (Editor + Sidebar)
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Theme.spacing.xl

            // Left side content
            StackLayout {
                id: tabStack
                Layout.fillWidth: true
                Layout.fillHeight: true

                // README Tab
                MarkdownWorkspace {
                    text: root.projectData.details_markdown || ""
                    placeholder: "# Project README\nDescribe your project goals here..."
                    onContentUpdated: newText => {
                        ProjectsBackend.updateProjectMarkdown(root.projectData.id, "details", newText);
                    }
                }

                // Tasks Tab
                ColumnLayout {
                    spacing: Theme.spacing.md

                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: "Project Tasks"
                            color: Theme.colors.text
                            font.pixelSize: 22
                            font.bold: true
                            font.family: Theme.fontFamily
                        }
                        Text {
                            text: "(" + root.projectTasks.length + ")"
                            color: Theme.colors.textMuted
                            font.pixelSize: 18
                        }
                        Item { Layout.fillWidth: true }
                        Rectangle {
                            height: 40
                            width: 120
                            radius: 20
                            color: addTaskBtnArea.containsMouse ? Theme.colors.primaryHover : Theme.colors.primary
                            Text {
                                anchors.centerIn: parent
                                text: "+ Add Task"
                                color: "white"
                                font.pixelSize: 14
                                font.bold: true
                            }
                            MouseArea {
                                id: addTaskBtnArea
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
                            width: parent.width - 24
                            spacing: Theme.spacing.sm

                            Repeater {
                                model: root.projectTasks
                                Rectangle {
                                    Layout.fillWidth: true
                                    height: 60
                                    radius: 12
                                    color: Theme.colors.surface
                                    border.color: Theme.colors.divider
                                    border.width: 1

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: Theme.spacing.md
                                        spacing: Theme.spacing.md

                                        Rectangle {
                                            width: 28; height: 28; radius: 8
                                            color: modelData.completed ? Theme.colors.success : "transparent"
                                            border.color: modelData.completed ? Theme.colors.success : Theme.colors.textMuted
                                            border.width: 2
                                            Text {
                                                anchors.centerIn: parent
                                                text: Theme.icons.check
                                                font.family: Theme.iconFontFamily
                                                color: "white"
                                                font.pixelSize: 14
                                                visible: modelData.completed
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
                                            font.pixelSize: 16
                                            font.strikeout: modelData.completed
                                            elide: Text.ElideRight
                                            font.family: Theme.fontFamily
                                        }

                                        MouseArea {
                                            width: 32; height: 32
                                            cursorShape: Qt.PointingHandCursor
                                            Text {
                                                anchors.centerIn: parent
                                                text: Theme.icons.trash
                                                font.family: Theme.iconFontFamily
                                                color: parent.containsMouse ? Theme.colors.error : Theme.colors.textMuted
                                                font.pixelSize: 18
                                            }
                                            onClicked: ProjectTasksBackend.deleteTask(modelData.id)
                                        }
                                    }
                                }
                            }

                            // Centered Empty State
                            Item {
                                visible: root.projectTasks.length === 0
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.minimumHeight: 300

                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: Theme.spacing.md
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: Theme.icons.tasks
                                        font.family: Theme.iconFontFamily
                                        font.pixelSize: 64
                                        color: Theme.colors.textMuted
                                        opacity: 0.2
                                    }
                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Click '+ Add Task' to start tracking progress!"
                                        color: Theme.colors.textMuted
                                        font.pixelSize: 16
                                        font.family: Theme.fontFamily
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Right Sidebar (Details)
            Rectangle {
                Layout.preferredWidth: 320
                Layout.fillHeight: true
                color: "transparent"

                ScrollView {
                    anchors.fill: parent
                    clip: true
                    ScrollBar.vertical.policy: ScrollBar.AsNeeded

                    ColumnLayout {
                        width: parent.width - 20
                        spacing: Theme.spacing.lg

                        DetailsSidebar {
                            projectData: root.projectData
                            Layout.fillWidth: true
                        }
                        
                        Item { Layout.fillHeight: true }
                    }
                }
            }
        }

        // Footer Section
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing.md
            
            Text {
                text: "Last modified: " + (root.projectData.updated_at ? root.projectData.updated_at.replace("T", " ").substring(0, 16) : "Just now")
                color: Theme.colors.textMuted
                font.pixelSize: 11
                font.family: Theme.fontFamily
            }
            Item { Layout.fillWidth: true }
            Text {
                text: root.projectTasks.length + " project tasks tracked"
                color: Theme.colors.primary
                font.pixelSize: 11
                font.family: Theme.fontFamily
                opacity: 0.8
            }
        }
    }

    // Modal Popup
    Rectangle {
        id: addTaskPopup
        anchors.fill: parent
        visible: false
        color: Qt.rgba(0, 0, 0, 0.85) // Darker backdrop
        z: 5000

        MouseArea { anchors.fill: parent } // Block all interactions

        Rectangle {
            width: 460
            height: 240
            radius: 20
            color: Theme.colors.surface
            anchors.centerIn: parent
            border.color: Theme.colors.divider
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Theme.spacing.xl
                spacing: Theme.spacing.lg

                Text {
                    text: "Create Project Task"
                    color: Theme.colors.text
                    font.pixelSize: 22
                    font.bold: true
                    font.family: Theme.fontFamily
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 52
                    radius: 10
                    color: Theme.colors.background
                    border.color: taskIn.activeFocus ? Theme.colors.primary : Theme.colors.divider
                    border.width: 1
                    
                    TextInput {
                        id: taskIn
                        anchors.fill: parent
                        anchors.margins: 14
                        verticalAlignment: TextInput.AlignVCenter
                        color: Theme.colors.text
                        font.pixelSize: 15
                        font.family: Theme.fontFamily
                        focus: addTaskPopup.visible

                        Text {
                            text: "Enter task title..."
                            color: Theme.colors.textMuted
                            visible: !parent.text && !parent.activeFocus
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            font.family: Theme.fontFamily
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing.md
                    Item { Layout.fillWidth: true }
                    
                    Rectangle {
                        height: 40; width: 100; radius: 10
                        color: Theme.colors.surfaceActive
                        Text { anchors.centerIn: parent; text: "Cancel"; color: Theme.colors.textSecondary; font.family: Theme.fontFamily }
                        MouseArea { 
                            anchors.fill: parent
                            onClicked: addTaskPopup.visible = false
                            cursorShape: Qt.PointingHandCursor
                        }
                    }

                    Rectangle {
                        height: 40; width: 120; radius: 10
                        color: Theme.colors.primary
                        Text { anchors.centerIn: parent; text: "Create Task"; color: "white"; font.bold: true; font.family: Theme.fontFamily }
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
