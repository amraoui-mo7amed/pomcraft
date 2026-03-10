import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.15
import ".."

Item {
    id: root

    property var projectData: ({})
    signal openProject(string projectId)
    signal deleteProject(string projectId)

    width: parent ? parent.width : 300
    height: 140

    // Main Card Body with glassmorphism effect
    Rectangle {
        id: cardBody
        anchors.fill: parent
        radius: Theme.radius.lg
        color: Theme.colors.surface
        border.color: mouseArea.containsMouse ? Theme.colors.primary : Theme.colors.divider
        border.width: mouseArea.containsMouse ? 2 : 1

        // Gradient background overlay
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            opacity: mouseArea.containsMouse ? 0.1 : 0
            gradient: Gradient {
                GradientStop { position: 0.0; color: Theme.colors.primary }
                GradientStop { position: 1.0; color: "transparent" }
            }
            Behavior on opacity { NumberAnimation { duration: 300 } }
        }

        // Subtle shadow
        Rectangle {
            id: shadowLayer
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            opacity: mouseArea.containsMouse ? 0.3 : 0.1
            anchors.margins: mouseArea.containsMouse ? -4 : -2

            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: Theme.colors.background
                opacity: 0.5
            }

            Behavior on opacity { NumberAnimation { duration: 250 } }
            Behavior on anchors.margins { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
        }

        // Animated border glow
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.color: Theme.colors.primary
            border.width: mouseArea.containsMouse ? 2 : 0
            opacity: mouseArea.containsMouse ? 0.5 : 0
            Behavior on opacity { NumberAnimation { duration: 300 } }
            Behavior on border.width { NumberAnimation { duration: 200 } }
        }

        Behavior on border.color { ColorAnimation { duration: 200 } }

        // Entrance animation
        opacity: 0
        scale: 0.95
        Component.onCompleted: {
            opacity = 1
            scale = 1
        }

        Behavior on opacity { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
        Behavior on scale { NumberAnimation { duration: 400; easing.type: Easing.OutBack } }

        // Hover scale effect
        scale: mouseArea.pressed ? 0.98 : (mouseArea.containsMouse ? 1.02 : 1.0)
        Behavior on scale { NumberAnimation { duration: 250; easing.type: Easing.OutBack } }

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

            // Left Side: Animated Status Ribbon
            Item {
                Layout.fillHeight: true
                width: 6

                Rectangle {
                    id: statusRibbon
                    width: 6
                    height: parent.height
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

                    // Pulse animation for active projects
                    SequentialAnimation on opacity {
                        running: root.projectData.status === "active"
                        loops: Animation.Infinite
                        NumberAnimation { from: 1.0; to: 0.6; duration: 1200; easing.type: Easing.InOutSine }
                        NumberAnimation { from: 0.6; to: 1.0; duration: 1200; easing.type: Easing.InOutSine }
                    }

                    // Glow effect
                    Rectangle {
                        anchors.fill: parent
                        radius: parent.radius
                        color: parent.color
                        opacity: 0.4
                        anchors.margins: -2
                    }
                }
            }

            // Middle: Content
            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing.sm

                // Header with title and status
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing.md

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0

                        Text {
                            id: titleText
                            text: root.projectData.title || "Untitled Project"
                            color: Theme.colors.text
                            font.pixelSize: 22
                            font.weight: Font.Bold
                            font.family: Theme.fontFamily
                            elide: Text.ElideRight

                            // Subtle entrance animation
                            opacity: 0
                            x: -10
                            Component.onCompleted: {
                                opacity = 1
                                x = 0
                            }
                            Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }
                            Behavior on x { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }
                        }

                        Text {
                            id: headlineText
                            text: root.projectData.headline || "Uncategorized work"
                            color: Theme.colors.primary
                            font.pixelSize: 13
                            font.family: Theme.fontFamily
                            font.weight: Font.Medium
                            opacity: 0.85
                            elide: Text.ElideRight
                            visible: text !== ""

                            opacity: 0
                            x: -10
                            Component.onCompleted: {
                                opacity = 0.85
                                x = 0
                            }
                            Behavior on opacity { NumberAnimation { duration: 500; delay: 100; easing.type: Easing.OutCubic } }
                            Behavior on x { NumberAnimation { duration: 500; delay: 100; easing.type: Easing.OutCubic } }
                        }
                    }

                    // Animated Status Badge
                    Rectangle {
                        id: statusBadge
                        height: 28
                        width: statusText.implicitWidth + 28
                        radius: 14
                        color: Qt.rgba(statusColor.r, statusColor.g, statusColor.b, 0.12)
                        border.color: Qt.rgba(statusColor.r, statusColor.g, statusColor.b, 0.4)
                        border.width: 1

                        property color statusColor: {
                            switch(root.projectData.status) {
                            case "active": return Theme.colors.primary
                            case "completed": return Theme.colors.success
                            case "on_hold": return Theme.colors.warning
                            default: return Theme.colors.textMuted
                            }
                        }

                        // Badge glow on hover
                        Rectangle {
                            anchors.fill: parent
                            radius: parent.radius
                            color: parent.statusColor
                            opacity: mouseArea.containsMouse ? 0.1 : 0
                            Behavior on opacity { NumberAnimation { duration: 200 } }
                        }

                        RowLayout {
                            anchors.centerIn: parent
                            spacing: 4

                            // Animated dot
                            Rectangle {
                                width: 6
                                height: 6
                                radius: 3
                                color: parent.parent.statusColor

                                SequentialAnimation on opacity {
                                    running: root.projectData.status === "active"
                                    loops: Animation.Infinite
                                    NumberAnimation { from: 1.0; to: 0.4; duration: 1000; easing.type: Easing.InOutQuad }
                                    NumberAnimation { from: 0.4; to: 1.0; duration: 1000; easing.type: Easing.InOutQuad }
                                }
                            }

                            Text {
                                id: statusText
                                text: root.projectData.status ? root.projectData.status.toUpperCase() : ""
                                color: parent.parent.statusColor
                                font.pixelSize: 10
                                font.bold: true
                                font.letterSpacing: 1
                            }
                        }
                    }
                }

                Item { Layout.preferredHeight: Theme.spacing.sm }

                // Metadata Row with enhanced icons
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing.xl

                    // Client with icon animation
                    RowLayout {
                        spacing: 8
                        visible: root.projectData.client_name !== ""

                        Text {
                            text: Theme.icons.user
                            font.family: Theme.iconFontFamily
                            font.pixelSize: 13
                            color: Theme.colors.textSecondary
                            opacity: 0
                            Component.onCompleted: opacity = 1
                            Behavior on opacity { NumberAnimation { duration: 300; delay: 200 } }
                        }

                        Text {
                            text: root.projectData.client_name
                            color: Theme.colors.textSecondary
                            font.pixelSize: 13
                            font.family: Theme.fontFamily
                        }
                    }

                    // Timeline with animated arrow
                    RowLayout {
                        spacing: 8

                        Text {
                            text: Theme.icons.calendar
                            font.family: Theme.iconFontFamily
                            font.pixelSize: 13
                            color: Theme.colors.textSecondary
                            opacity: 0
                            Component.onCompleted: opacity = 1
                            Behavior on opacity { NumberAnimation { duration: 300; delay: 250 } }
                        }

                        Text {
                            text: (root.projectData.start_date ? root.projectData.start_date.split("T")[0] : "Start") +
                                  " → " +
                                  (root.projectData.deadline ? root.projectData.deadline.split("T")[0] : "End")
                            color: Theme.colors.textSecondary
                            font.pixelSize: 12
                            font.family: Theme.fontFamily
                            opacity: 0.8

                            // Animated arrow on hover
                            opacity: mouseArea.containsMouse ? 1 : 0.8
                            Behavior on opacity { NumberAnimation { duration: 200 } }
                        }
                    }
                }

                Item { Layout.fillHeight: true }

                // Footer: Tags with staggered animation
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Text {
                        visible: root.projectData.tags && root.projectData.tags.length > 0
                        text: Theme.icons.tag
                        font.family: Theme.iconFontFamily
                        font.pixelSize: 12
                        color: Theme.colors.textMuted
                    }

                    Flow {
                        Layout.fillWidth: true
                        spacing: 6

                        Repeater {
                            model: root.projectData.tags ? root.projectData.tags.slice(0, 3) : []

                            Rectangle {
                                height: 24
                                width: tagText.implicitWidth + 14
                                radius: 6
                                color: mouseArea.containsMouse ? Theme.colors.surfaceHover : Theme.colors.surfaceActive
                                border.color: Theme.colors.divider
                                border.width: 1

                                opacity: 0
                                y: 5
                                Component.onCompleted: {
                                    opacity = 1
                                    y = 0
                                }
                                Behavior on opacity { NumberAnimation { duration: 300; delay: index * 80 + 300 } }
                                Behavior on y { NumberAnimation { duration: 300; delay: index * 80 + 300; easing.type: Easing.OutBack } }

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

            // Right side: Enhanced Delete Button with tooltip effect
            Rectangle {
                Layout.alignment: Qt.AlignTop
                width: 34
                height: 34
                radius: 17
                color: deleteBtn.containsMouse ? Theme.colors.error : "transparent"
                border.color: deleteBtn.containsMouse ? Theme.colors.error : "transparent"
                border.width: 1
                opacity: mouseArea.containsMouse ? 1 : 0

                // Scale animation on hover
                scale: deleteBtn.containsMouse ? 1.1 : 1.0
                Behavior on opacity { NumberAnimation { duration: 250 } }
                Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }

                Text {
                    anchors.centerIn: parent
                    text: Theme.icons.close
                    font.family: Theme.iconFontFamily
                    color: deleteBtn.containsMouse ? "white" : Theme.colors.textMuted
                    font.pixelSize: 14
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
