import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import ".."

Rectangle {
    id: root

    property var projectData: ({})
    signal projectSaved(string projectId)

    visible: false
    width: 650
    height: 600
    radius: Theme.radius.xl
    color: Theme.colors.surface
    border.color: Theme.colors.divider
    border.width: 1

    // Modal background overlay
    parent: Overlay.overlay
    anchors.centerIn: parent

    onVisibleChanged: {
        if (visible) {
            if (projectData.id) {
                titleInput.text = projectData.title || ""
                headlineInput.text = projectData.headline || ""
                clientNameInput.text = projectData.client_name || ""
                startDateInput.text = projectData.start_date ? projectData.start_date.split("T")[0] : ""
                statusCombo.currentIndex = statusModel_indexOf(projectData.status || "active")
                deadlineInput.text = projectData.deadline ? projectData.deadline.split("T")[0] : ""
                tagsInput.text = (projectData.tags || []).join(", ")
            } else {
                titleInput.text = ""
                headlineInput.text = ""
                clientNameInput.text = ""
                startDateInput.text = ""
                statusCombo.currentIndex = 0
                deadlineInput.text = ""
                tagsInput.text = ""
            }
        }
    }

    function statusModel_indexOf(val) {
        for(var i=0; i<statusModel.count; i++) {
            if(statusModel.get(i).text === val) return i;
        }
        return 0;
    }

    ListModel {
        id: statusModel
        ListElement { text: "active" }
        ListElement { text: "completed" }
        ListElement { text: "on_hold" }
        ListElement { text: "archived" }
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
                    text: root.projectData.id ? "Edit Project" : "Create New Project"
                    color: Theme.colors.text
                    font.pixelSize: Theme.typography.h4
                    font.bold: true
                    font.family: Theme.fontFamily
                }
                Text {
                    text: "Fill in the details below to organize your workspace"
                    color: Theme.colors.textSecondary
                    font.pixelSize: 11
                    font.family: Theme.fontFamily
                }
            }

            Item { Layout.fillWidth: true }

            Rectangle {
                width: 32; height: 32; radius: 16
                color: closeBtn.containsMouse ? Theme.colors.surfaceActive : "transparent"
                Text {
                    anchors.centerIn: parent
                    text: Theme.icons.close; font.family: Theme.iconFontFamily; color: Theme.colors.textMuted; font.pixelSize: 12
                }
                MouseArea { id: closeBtn; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.visible = false }
            }
        }

        // Form fields
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing.md

            FormInput {
                id: titleInput
                Layout.fillWidth: true
                label: "PROJECT TITLE"
                placeholder: "Enter project name..."
                icon: Theme.icons.projects
            }

            FormInput {
                id: headlineInput
                Layout.fillWidth: true
                label: "HEADLINE"
                placeholder: "Brief catchphrase or focus area..."
                icon: Theme.icons.star
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing.lg
                
                FormInput {
                    id: clientNameInput
                    Layout.fillWidth: true
                    label: "CLIENT NAME"
                    placeholder: "Who is this for?"
                    icon: Theme.icons.user
                }

                FormComboBox {
                    id: statusCombo
                    Layout.fillWidth: true
                    label: "CURRENT STATUS"
                    model: statusModel
                    textRole: "text"
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing.lg
                
                FormInput {
                    id: startDateInput
                    Layout.fillWidth: true
                    label: "START DATE"
                    placeholder: "YYYY-MM-DD"
                    icon: Theme.icons.calendar
                }

                FormInput {
                    id: deadlineInput
                    Layout.fillWidth: true
                    label: "DEADLINE"
                    placeholder: "YYYY-MM-DD"
                    icon: Theme.icons.calendar
                }
            }

            FormInput {
                id: tagsInput
                Layout.fillWidth: true
                label: "TAGS"
                placeholder: "Separate tags with commas (e.g. web, design, high-priority)"
                icon: Theme.icons.tag
            }
        }

        Item { Layout.fillHeight: true }

        // Action buttons
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing.md

            Item { Layout.fillWidth: true }

            Rectangle {
                height: 44
                width: 120
                radius: Theme.radius.md
                color: cancelBtn.containsMouse ? Theme.colors.surfaceActive : "transparent"
                border.width: 1
                border.color: Theme.colors.divider

                Text {
                    anchors.centerIn: parent
                    text: "Discard"
                    color: Theme.colors.textSecondary
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    font.family: Theme.fontFamily
                }

                MouseArea {
                    id: cancelBtn
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.visible = false
                }
            }

            Rectangle {
                height: 44
                width: 140
                radius: Theme.radius.md
                color: saveBtn.containsMouse ? Theme.colors.primaryHover : Theme.colors.primary

                // Subtle inner shadow/glow for the primary button
                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: "white"
                    opacity: saveBtn.pressed ? 0.1 : (saveBtn.containsMouse ? 0.05 : 0)
                }

                Text {
                    anchors.centerIn: parent
                    text: root.projectData.id ? "Update Project" : "Create Project"
                    color: "white"
                    font.pixelSize: 14
                    font.weight: Font.Bold
                    font.family: Theme.fontFamily
                }

                MouseArea {
                    id: saveBtn
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        const tags = tagsInput.text.split(",").map(t => t.trim()).filter(t => t.length > 0)
                        if (root.projectData.id) {
                            ProjectsBackend.updateProject(root.projectData.id, titleInput.text, headlineInput.text, clientNameInput.text, startDateInput.text, deadlineInput.text, statusModel.get(statusCombo.currentIndex).text, tags)
                        } else {
                            ProjectsBackend.createProject(titleInput.text, headlineInput.text, clientNameInput.text, startDateInput.text, deadlineInput.text, statusModel.get(statusCombo.currentIndex).text, tags)
                        }
                        root.visible = false
                        root.projectSaved(root.projectData.id || "new")
                    }
                }
            }
        }
    }
}
