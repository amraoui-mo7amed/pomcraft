import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import ".."

Rectangle {
    id: root

    property var projectData: ({})
    visible: false

    // Scale and opacity animations for "window" effect
    opacity: visible ? 1 : 0
    scale: visible ? 1 : 0.95
    Behavior on opacity {
        NumberAnimation {
            duration: 250
            easing.type: Easing.OutCubic
        }
    }
    Behavior on scale {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutBack
        }
    }

    anchors.fill: parent
    color: Qt.rgba(Theme.colors.background.r, Theme.colors.background.g, Theme.colors.background.b, 0.95)
    z: 1000

    // Prevent clicking through to the main window
    MouseArea {
        anchors.fill: parent
        onClicked: {}
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.spacing.xxl
        spacing: Theme.spacing.xl

        // Header
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing.xl

            ColumnLayout {
                spacing: 4
                Text {
                    text: root.projectData.title || ""
                    color: Theme.colors.text
                    font.pixelSize: 32
                    font.bold: true
                    font.family: Theme.fontFamily
                }
                Text {
                    text: (root.projectData.headline || "Project Workspace") + " • " + (root.projectData.client_name || "Internal")
                    color: Theme.colors.primary
                    font.pixelSize: 14
                    font.weight: Font.Medium
                }
            }

            Item {
                Layout.fillWidth: true
            }

            // Tab Switcher
            Rectangle {
                height: 44
                width: 240
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

                            Behavior on color {
                                ColorAnimation {
                                    duration: 200
                                }
                            }

                            Text {
                                anchors.centerIn: parent
                                text: modelData
                                color: tabStack.currentIndex === index ? "white" : Theme.colors.textSecondary
                                font.bold: tabStack.currentIndex === index
                                font.pixelSize: 13
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
                color: closeHover.containsMouse ? Theme.colors.error : Theme.colors.surface

                Text {
                    anchors.centerIn: parent
                    text: Theme.icons.close
                    font.family: Theme.iconFontFamily
                    color: closeHover.containsMouse ? "white" : Theme.colors.text
                    font.pixelSize: 16
                }

                MouseArea {
                    id: closeHover
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: root.visible = false
                }
            }
        }

        // Main Content Area
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Theme.spacing.xl

            // Editor / Preview Section (Left)
            StackLayout {
                id: tabStack
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: 0

                // Details Tab
                MarkdownWorkspace {
                    text: root.projectData.details_markdown || ""
                    placeholder: "# Project Details\nAdd goals, resources, and notes here..."
                    onContentUpdated: newText => {
                        ProjectsBackend.updateProjectMarkdown(root.projectData.id, "details", newText);
                    }
                }

                // Tasks Tab
                MarkdownWorkspace {
                    text: root.projectData.tasks_markdown || ""
                    placeholder: "# Project Tasks\n- [ ] Task 1\n- [ ] Task 2\n- [x] Completed task"
                    onContentUpdated: newText => {
                        ProjectsBackend.updateProjectMarkdown(root.projectData.id, "tasks", newText);
                    }
                }
            }

            // Sidebar Area (Right)
            ScrollView {
                id: sidebarScroll
                Layout.preferredWidth: 320
                Layout.fillHeight: true
                clip: true
                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                ColumnLayout {
                    width: sidebarScroll.availableWidth
                    spacing: Theme.spacing.lg

                    // Project Details Card
                    DetailsSidebar {
                        id: detailsSidebar
                        projectData: root.projectData
                        Layout.fillWidth: true
                        Layout.preferredHeight: implicitHeight
                    }
                }

                // Entrance animation
                property real translateX: root.visible ? 0 : 40
                opacity: root.visible ? 1 : 0
                transform: Translate {
                    x: sidebarScroll.translateX
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: 400
                        easing.type: Easing.OutCubic
                    }
                }
                Behavior on translateX {
                    NumberAnimation {
                        duration: 500
                        easing.type: Easing.OutBack
                    }
                }
            }
        }

        // Footer Stats
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
                text: "Markdown automatically saves as you type"
                color: Theme.colors.primary
                font.pixelSize: 11
                font.italic: true
                opacity: 0.7
            }
        }
    }

    // Floating Timer Card
    ProjectTimerCard {
        id: projectTimer
        width: 320
        x: root.width - width - Theme.spacing.xxl
        y: root.height - height - Theme.spacing.xxl - 40
        z: 2000
    }
}
