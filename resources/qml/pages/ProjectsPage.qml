import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import ".."
import "../components" as Components
import "../components"

Item {
    id: root

    property var allProjects: ProjectsBackend.getProjects()
    property var projects: {
        var filtered = [];
        for (var i = 0; i < allProjects.length; i++) {
            if (root.currentFilter === "all" || allProjects[i].status === root.currentFilter) {
                filtered.push(allProjects[i]);
            }
        }
        return filtered;
    }
    property string currentFilter: "all"

    onAllProjectsChanged: {
        // Trigger recalculation of filtered projects
    }

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
                    text: "Projects"
                    color: Theme.colors.text
                    font.pixelSize: Theme.typography.h3
                    font.bold: true
                    font.family: Theme.fontFamily
                }
                Text {
                    text: "Manage your workspaces and clients"
                    color: Theme.colors.textSecondary
                    font.pixelSize: 12
                    font.family: Theme.fontFamily
                }
            }

            Item { Layout.fillWidth: true }

            // Filter buttons
            RowLayout {
                spacing: Theme.spacing.sm
                Repeater {
                    model: [
                        { name: "All", filter: "all" },
                        { name: "Active", filter: "active" },
                        { name: "Completed", filter: "completed" }
                    ]
                    Rectangle {
                        height: 36
                        width: filterText.implicitWidth + 30
                        radius: 18
                        color: root.currentFilter === modelData.filter ? Theme.colors.primary : Theme.colors.surface
                        border.color: root.currentFilter === modelData.filter ? Theme.colors.primary : Theme.colors.divider
                        border.width: 1
                        Text {
                            id: filterText
                            anchors.centerIn: parent
                            text: modelData.name
                            color: root.currentFilter === modelData.filter ? "white" : Theme.colors.textSecondary
                            font.pixelSize: 12
                            font.bold: root.currentFilter === modelData.filter
                            font.family: Theme.fontFamily
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.currentFilter = modelData.filter
                                root.allProjects = ProjectsBackend.getProjects()
                            }
                        }
                    }
                }
            }

            // Add project button
            Rectangle {
                width: 40
                height: 40
                radius: 20
                color: addBtn.containsMouse ? Theme.colors.primaryHover : Theme.colors.primary
                Text {
                    anchors.centerIn: parent
                    text: Theme.icons.plus
                    font.family: Theme.iconFontFamily
                    color: "white"
                    font.pixelSize: 16
                }
                MouseArea {
                    id: addBtn
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        projectDialog.projectData = {}
                        projectDialog.visible = true
                    }
                }
            }
        }

        // Projects Grid - 2 columns
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            ScrollBar.vertical.policy: ScrollBar.AsNeeded

            GridLayout {
                width: parent.width - 40
                columns: 2
                rowSpacing: Theme.spacing.md
                columnSpacing: Theme.spacing.md

                Repeater {
                    model: root.projects
                    ProjectCard {
                        Layout.fillWidth: true
                        Layout.minimumWidth: 220
                        Layout.preferredHeight: 220
                        projectData: modelData
                        onOpenProject: function(projectId) {
                            projectView.projectData = ProjectsBackend.getProject(projectId)
                            projectView.visible = true
                        }
                        onDeleteProject: function(projectId) {
                            ProjectsBackend.deleteProject(projectId)
                        }
                    }
                }
            }
        }
    }

    // Empty state
    Rectangle {
        anchors.fill: parent
        visible: root.projects.length === 0
        color: "transparent"

        Column {
            anchors.centerIn: parent
            spacing: Theme.spacing.md

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: Theme.icons.projects
                font.family: Theme.iconFontFamily
                font.pixelSize: 64
                color: Theme.colors.textMuted
                opacity: 0.4
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "No projects found. Create one to get started!"
                color: Theme.colors.textMuted
                font.pixelSize: 16
                font.family: Theme.fontFamily
            }
        }
    }

    ProjectDetailDialog {
        id: projectDialog
        anchors.centerIn: parent
        visible: false
        onProjectSaved: root.projects = ProjectsBackend.getProjects()
    }

    ProjectViewDialog {
        id: projectView
        visible: false
    }

    Connections {
        target: ProjectsBackend
        function onProjectsChanged() {
            root.allProjects = ProjectsBackend.getProjects()
        }
    }
}
