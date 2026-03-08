import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import ".."
import "../components" as Components
import "../components"

Item {
    id: root

    property var projects: ProjectsBackend.getProjects()
    property string currentFilter: "all"

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
            spacing: Theme.spacing.md

            ColumnLayout {
                spacing: 2
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
                            onClicked: root.currentFilter = modelData.filter
                        }
                    }
                }
            }

            // Add project button
            Rectangle {
                width: 40; height: 40; radius: 20
                color: addBtn.containsMouse ? Theme.colors.primaryHover : Theme.colors.primary
                Text {
                    anchors.centerIn: parent
                    text: Theme.icons.plus; font.family: Theme.iconFontFamily; color: "white"; font.pixelSize: 16
                }
                MouseArea {
                    id: addBtn; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                    onClicked: { projectDialog.projectData = {}; projectDialog.visible = true }
                }
            }
        }

        // Project List
        ListView {
            id: projectList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: Theme.spacing.md
            model: {
                if (root.currentFilter === "all") return root.projects;
                return root.projects.filter(p => p.status === root.currentFilter);
            }

            delegate: ProjectCard {
                projectData: modelData
                onOpenProject: function(projectId) {
                    projectView.projectData = ProjectsBackend.getProject(projectId)
                    projectView.visible = true
                }
                onDeleteProject: function(projectId) {
                    ProjectsBackend.deleteProject(projectId)
                }
            }

            // Empty state
            ColumnLayout {
                anchors.centerIn: parent
                visible: projectList.count === 0
                spacing: Theme.spacing.md
                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "📁"; font.pixelSize: 48; opacity: 0.2
                }
                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "No " + (root.currentFilter !== "all" ? root.currentFilter + " " : "") + "projects found."
                    color: Theme.colors.textMuted; font.pixelSize: 16; font.family: Theme.fontFamily
                }
            }
        }
    }

    ProjectDetailDialog {
        id: projectDialog
        anchors.centerIn: parent
        onProjectSaved: root.projects = ProjectsBackend.getProjects()
    }

    ProjectViewDialog {
        id: projectView
    }

    Connections {
        target: ProjectsBackend
        function onProjectsChanged() { root.projects = ProjectsBackend.getProjects() }
    }
}
