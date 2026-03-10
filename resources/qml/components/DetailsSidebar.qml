import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import ".."

Rectangle {
    id: root
    implicitWidth: 320
    implicitHeight: mainLayout.implicitHeight + (Theme.spacing.lg * 2)
    color: Theme.colors.surface
    radius: 7
    border.color: Theme.colors.divider
    border.width: 1

    property var projectData: ({})

    // Background glow effect
    Rectangle {
        anchors.fill: parent
        radius: 7
        color: Theme.colors.primary
        opacity: 0.02
    }

    ColumnLayout {
        id: mainLayout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: Theme.spacing.lg
        spacing: Theme.spacing.xl

        // Header Section: Status
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing.md

            Text {
                text: "PROJECT STATUS"
                color: Theme.colors.textMuted
                font.pixelSize: 10
                font.bold: true
                font.letterSpacing: 1.5
                font.family: Theme.fontFamily
            }

            Rectangle {
                Layout.fillWidth: true
                height: 48
                radius: 7
                color: Theme.colors.background
                border.color: Theme.colors.divider
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Theme.spacing.md
                    anchors.rightMargin: Theme.spacing.md
                    spacing: Theme.spacing.sm

                    Rectangle {
                        width: 10; height: 10; radius: 5
                        color: {
                            switch(root.projectData.status) {
                                case "active": return Theme.colors.primary
                                case "completed": return Theme.colors.success
                                case "on_hold": return Theme.colors.warning
                                default: return Theme.colors.textMuted
                            }
                        }
                        
                        // Pulse animation for active projects
                        SequentialAnimation on opacity {
                            running: root.projectData.status === "active"
                            loops: Animation.Infinite
                            NumberAnimation { from: 1.0; to: 0.4; duration: 1000; easing.type: Easing.InOutQuad }
                            NumberAnimation { from: 0.4; to: 1.0; duration: 1000; easing.type: Easing.InOutQuad }
                        }
                    }

                    Text {
                        text: (root.projectData.status || "active").toUpperCase()
                        color: Theme.colors.text
                        font.pixelSize: 13
                        font.bold: true
                        font.family: Theme.fontFamily
                    }

                    Item { Layout.fillWidth: true }
                }
            }
        }

        // Timeline Section
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing.md

            Text {
                text: "TIMELINE"
                color: Theme.colors.textMuted
                font.pixelSize: 10
                font.bold: true
                font.letterSpacing: 1.5
                font.family: Theme.fontFamily
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: timelineLayout.implicitHeight + (Theme.spacing.md * 2)
                radius: 7
                color: Theme.colors.background
                border.color: Theme.colors.divider
                border.width: 1

                ColumnLayout {
                    id: timelineLayout
                    anchors.fill: parent
                    anchors.margins: Theme.spacing.md
                    spacing: Theme.spacing.md

                    TimelineItem {
                        label: "Start Date"
                        value: root.projectData.start_date ? root.projectData.start_date.substring(0, 10) : "Not set"
                        icon: Theme.icons.calendar
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: Theme.colors.divider; opacity: 0.5 }

                    TimelineItem {
                        label: "Deadline"
                        value: root.projectData.deadline ? root.projectData.deadline.substring(0, 10) : "Not set"
                        icon: Theme.icons.flag
                        valueColor: root.isOverdue ? Theme.colors.error : Theme.colors.text
                    }
                }
            }
        }

    // Tags Section (if any)
    ColumnLayout {
        Layout.fillWidth: true
        spacing: Theme.spacing.md
        visible: !!root.projectData && !!root.projectData.tags && root.projectData.tags.length > 0

            Text {
                text: "TAGS"
                color: Theme.colors.textMuted
                font.pixelSize: 10
                font.bold: true
                font.letterSpacing: 1.5
            }

            Flow {
                Layout.fillWidth: true
                spacing: Theme.spacing.sm
                
                Repeater {
                    model: root.projectData.tags || []
                    Rectangle {
                        height: 26
                        width: tagText.implicitWidth + 20
                        radius: 13
                        color: Qt.rgba(Theme.colors.primary.r, Theme.colors.primary.g, Theme.colors.primary.b, 0.1)
                        border.color: Qt.rgba(Theme.colors.primary.r, Theme.colors.primary.g, Theme.colors.primary.b, 0.2)
                        border.width: 1
                        
                        Text {
                            id: tagText
                            anchors.centerIn: parent
                            text: modelData
                            color: Theme.colors.primary
                            font.pixelSize: 11
                            font.bold: true
                        }
                    }
                }
            }
        }

        // Client Info Card
        Rectangle {
            Layout.fillWidth: true
            height: 80
            radius: 7
            color: Theme.colors.card
            border.color: Theme.colors.cardBorder
            border.width: 1
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: Theme.spacing.md
                spacing: Theme.spacing.md

                Rectangle {
                    width: 40; height: 40; radius: 20
                    color: Theme.colors.surface
                    Text {
                        anchors.centerIn: parent
                        text: Theme.icons.user; font.family: Theme.iconFontFamily; color: Theme.colors.primary; font.pixelSize: 16
                    }
                }

                ColumnLayout {
                    spacing: 0
                    Text {
                        text: root.projectData.client_name || "Internal Project"
                        color: Theme.colors.text; font.pixelSize: 14; font.bold: true
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    Text {
                        text: "Project Owner / Client"; color: Theme.colors.textSecondary; font.pixelSize: 11
                    }
                }
            }
        }
    }

    // Modern Timeline Item Component
    component TimelineItem : RowLayout {
        property string label: ""
        property string value: ""
        property string icon: ""
        property color valueColor: Theme.colors.text
        
        spacing: Theme.spacing.md
        
        Rectangle {
            width: 32; height: 32; radius: 16
            color: Theme.colors.surface
            Text {
                anchors.centerIn: parent
                text: icon; font.family: Theme.iconFontFamily; color: Theme.colors.textSecondary; font.pixelSize: 12
            }
        }
        
        ColumnLayout {
            spacing: 0
            Text { text: label; color: Theme.colors.textMuted; font.pixelSize: 10; font.bold: true }
            Text { text: value; color: valueColor; font.pixelSize: 13; font.family: Theme.fontFamily; font.weight: Font.Medium }
        }
    }

    readonly property bool isOverdue: {
        if (!projectData.deadline) return false
        return new Date(projectData.deadline) < new Date()
    }
}
