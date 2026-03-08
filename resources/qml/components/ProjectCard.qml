import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import ".."

Item {
    id: root

    property var projectData: ({})
    signal openProject(string projectId)
    signal deleteProject(string projectId)

    width: parent ? parent.width : 300
    height: 160

    // Main Card Body
    Rectangle {
        id: cardBody
        anchors.fill: parent
        radius: Theme.radius.lg
        color: Theme.colors.surface
        border.color: mouseArea.containsMouse ? Theme.colors.primary : Theme.colors.divider
        border.width: 1

        // Animated glow effect on hover
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            opacity: mouseArea.containsMouse ? 0.05 : 0
            color: Theme.colors.primary
            Behavior on opacity { NumberAnimation { duration: 300 } }
        }

        Behavior on border.color { ColorAnimation { duration: 200 } }
        
        // Animated scale effect
        scale: mouseArea.pressed ? 0.98 : (mouseArea.containsMouse ? 1.01 : 1.0)
        Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.openProject(root.projectData.id)
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: Theme.spacing.lg
            spacing: Theme.spacing.lg

            // Left Side: Status Ribbon
            Rectangle {
                Layout.fillHeight: true
                width: 6
                radius: 3
                color: {
                    switch(root.projectData.status) {
                        case "active": return Theme.colors.primary
                        case "completed": return Theme.colors.success
                        case "on_hold": return Theme.colors.warning
                        case "archived": return Theme.colors.textMuted
                        default: return Theme.colors.surfaceActive
                    }
                }
            }

            // Middle: Content
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing.md

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0
                        Text {
                            text: root.projectData.title || "Untitled Project"
                            color: Theme.colors.text
                            font.pixelSize: 20
                            font.weight: Font.Bold
                            font.family: Theme.fontFamily
                            elide: Text.ElideRight
                        }
                        Text {
                            text: root.projectData.headline || "Uncategorized work"
                            color: Theme.colors.primary
                            font.pixelSize: 13
                            font.family: Theme.fontFamily
                            font.weight: Font.Medium
                            opacity: 0.9
                            elide: Text.ElideRight
                            visible: text !== ""
                        }
                    }

                    // Status Badge
                    Rectangle {
                        height: 26
                        width: statusText.implicitWidth + 24
                        radius: 13
                        color: Qt.rgba(statusColor.r, statusColor.g, statusColor.b, 0.15)
                        border.color: Qt.rgba(statusColor.r, statusColor.g, statusColor.b, 0.3)
                        border.width: 1

                        property color statusColor: {
                            switch(root.projectData.status) {
                                case "active": return Theme.colors.primary
                                case "completed": return Theme.colors.success
                                case "on_hold": return Theme.colors.warning
                                default: return Theme.colors.textMuted
                            }
                        }

                        Text {
                            id: statusText
                            anchors.centerIn: parent
                            text: root.projectData.status ? root.projectData.status.toUpperCase() : ""
                            color: parent.statusColor
                            font.pixelSize: 10
                            font.bold: true
                            font.letterSpacing: 1
                        }
                    }
                }

                Item { Layout.preferredHeight: Theme.spacing.xs }

                // Metadata Row (Client & Dates)
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing.xl

                    // Client
                    RowLayout {
                        spacing: 8
                        visible: root.projectData.client_name !== ""
                        Text {
                            text: Theme.icons.user
                            font.family: Theme.iconFontFamily
                            font.pixelSize: 12
                            color: Theme.colors.textSecondary
                        }
                        Text {
                            text: root.projectData.client_name
                            color: Theme.colors.textSecondary
                            font.pixelSize: 13
                            font.family: Theme.fontFamily
                        }
                    }

                    // Timeline
                    RowLayout {
                        spacing: 12
                        Text {
                            text: Theme.icons.calendar
                            font.family: Theme.iconFontFamily
                            font.pixelSize: 12
                            color: Theme.colors.textSecondary
                        }
                        Text {
                            text: (root.projectData.start_date ? root.projectData.start_date.split("T")[0] : "Start") + 
                                  "  →  " + 
                                  (root.projectData.deadline ? root.projectData.deadline.split("T")[0] : "End")
                            color: Theme.colors.textSecondary
                            font.pixelSize: 12
                            font.family: Theme.fontFamily
                        }
                    }
                }

                Item { Layout.fillHeight: true }

                // Footer: Tags
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Text {
                        visible: root.projectData.tags && root.projectData.tags.length > 0
                        text: Theme.icons.tag
                        font.family: Theme.iconFontFamily
                        font.pixelSize: 11
                        color: Theme.colors.textMuted
                    }

                    RowLayout {
                        spacing: 6
                        Repeater {
                            model: root.projectData.tags ? root.projectData.tags.slice(0, 4) : []
                            Rectangle {
                                height: 22
                                width: tagText.implicitWidth + 16
                                radius: 6
                                color: Theme.colors.surfaceActive
                                Text {
                                    id: tagText
                                    anchors.centerIn: parent
                                    text: modelData
                                    color: Theme.colors.textSecondary
                                    font.pixelSize: 11
                                    font.family: Theme.fontFamily
                                }
                            }
                        }
                    }

                    Item { Layout.fillWidth: true }
                }
            }

            // Right side: Delete Button
            Rectangle {
                Layout.alignment: Qt.AlignTop
                width: 32; height: 32; radius: 16
                color: deleteBtn.containsMouse ? Theme.colors.error : "transparent"
                opacity: mouseArea.containsMouse ? 1 : 0
                
                Behavior on opacity { NumberAnimation { duration: 200 } }

                Text {
                    anchors.centerIn: parent
                    text: Theme.icons.close
                    font.family: Theme.iconFontFamily
                    color: deleteBtn.containsMouse ? "white" : Theme.colors.textMuted
                    font.pixelSize: 12
                }

                MouseArea {
                    id: deleteBtn
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: function(mouse) {
                        mouse.accepted = true
                        root.deleteProject(root.projectData.id)
                    }
                }
            }
        }
    }
}
