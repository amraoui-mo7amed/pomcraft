import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import ".."

Item {
    id: root

    property var projectData: ({})
    signal openProject(string projectId)
    signal deleteProject(string projectId)

    width: parent ? parent.width : 350
    height: 220

    // Bootstrap-style Card Container
    Rectangle {
        id: cardContainer
        anchors.fill: parent
        anchors.margins: Theme.spacing.sm
        radius: 8
        color: Theme.colors.surface
        border.color: mouseArea.containsMouse ? Theme.colors.primary : Theme.colors.divider
        border.width: 1

        // Bootstrap shadow: none by default, shadow on hover
        Rectangle {
            id: cardShadow
            anchors.fill: parent
            anchors.margins: mouseArea.containsMouse ? 0 : 0
            radius: parent.radius
            color: "transparent"
            z: -1

            // Simulate box-shadow with multiple offset rectangles
            Rectangle {
                anchors.fill: parent
                anchors.margins: -1
                radius: parent.radius + 1
                color: mouseArea.containsMouse ? Theme.colors.background : "transparent"
                opacity: mouseArea.containsMouse ? 0.3 : 0
                Behavior on opacity { NumberAnimation { duration: 200 } }
            }

            Rectangle {
                anchors.fill: parent
                anchors.margins: -2
                radius: parent.radius + 2
                color: mouseArea.containsMouse ? Theme.colors.background : "transparent"
                opacity: mouseArea.containsMouse ? 0.2 : 0
                Behavior on opacity { NumberAnimation { duration: 200 } }
            }

            Rectangle {
                anchors.fill: parent
                anchors.margins: -4
                radius: parent.radius + 4
                color: mouseArea.containsMouse ? Theme.colors.background : "transparent"
                opacity: mouseArea.containsMouse ? 0.1 : 0
                Behavior on opacity { NumberAnimation { duration: 200 } }
            }
        }

        // Smooth transitions
        Behavior on border.color { ColorAnimation { duration: 200 } }

        // Click handler
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.openProject(root.projectData.id)
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Theme.spacing.lg
            spacing: Theme.spacing.md

            // Card Header: Status Badge
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing.sm

                // Bootstrap Badge Style
                Rectangle {
                    id: statusBadge
                    height: 24
                    width: statusText.implicitWidth + 20
                    radius: 4
                    color: {
                        switch(root.projectData.status) {
                        case "active": return Theme.colors.primary
                        case "completed": return Theme.colors.success
                        case "on_hold": return Theme.colors.warning
                        default: return Theme.colors.textMuted
                        }
                    }
                    opacity: 0.9

                    Text {
                        id: statusText
                        anchors.centerIn: parent
                        text: (root.projectData.status || "active").toUpperCase()
                        color: "white"
                        font.pixelSize: 10
                        font.bold: true
                        font.letterSpacing: 0.5
                    }
                }

                Item { Layout.fillWidth: true }

                // Delete button (Bootstrap close style)
                Text {
                    text: "×"
                    font.pixelSize: 24
                    color: deleteBtn.containsMouse ? Theme.colors.error : Theme.colors.textMuted
                    opacity: mouseArea.containsMouse ? 1 : 0

                    Behavior on opacity { NumberAnimation { duration: 200 } }

                    MouseArea {
                        id: deleteBtn
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            mouse.accepted = true
                            root.deleteProject(root.projectData.id)
                        }
                    }
                }
            }

            // Card Body: Title and Description
            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing.xs

                // Bootstrap card-title style
                Text {
                    Layout.fillWidth: true
                    text: root.projectData.title || "Untitled Project"
                    color: Theme.colors.text
                    font.pixelSize: 18
                    font.bold: true
                    font.family: Theme.fontFamily
                    elide: Text.ElideRight
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    maximumLineCount: 2
                }

                // Bootstrap card-subtitle style
                Text {
                    Layout.fillWidth: true
                    visible: !!root.projectData.headline && root.projectData.headline !== ""
                    text: root.projectData.headline
                    color: Theme.colors.primary
                    font.pixelSize: 13
                    font.family: Theme.fontFamily
                    elide: Text.ElideRight
                }

                // Bootstrap card-text style
                Text {
                    Layout.fillWidth: true
                    text: root.projectData.description || "No description available."
                    color: Theme.colors.textSecondary
                    font.pixelSize: 13
                    font.family: Theme.fontFamily
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    elide: Text.ElideRight
                    maximumLineCount: 3
                    opacity: 0.9
                }
            }

            Item { Layout.fillHeight: true }

            // Card Footer: Metadata
            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing.sm

                // Divider
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Theme.colors.divider
                    opacity: 0.5
                }

                // Bootstrap list-group style for metadata
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing.md

                    // Client
                    RowLayout {
                        visible: root.projectData.client_name !== ""
                        spacing: 6

                        Text {
                            text: Theme.icons.user
                            font.family: Theme.iconFontFamily
                            font.pixelSize: 12
                            color: Theme.colors.textMuted
                        }

                        Text {
                            text: root.projectData.client_name
                            color: Theme.colors.textSecondary
                            font.pixelSize: 12
                            font.family: Theme.fontFamily
                            elide: Text.ElideRight
                        }
                    }

                    Item { Layout.fillWidth: true }

                    // Timeline
                    RowLayout {
                        spacing: 6

                        Text {
                            text: Theme.icons.calendar
                            font.family: Theme.iconFontFamily
                            font.pixelSize: 12
                            color: Theme.colors.textMuted
                        }

                        Text {
                            text: (root.projectData.start_date ?
                                   root.projectData.start_date.split("T")[0] : "--") +
                                  " / " +
                                  (root.projectData.deadline ?
                                   root.projectData.deadline.split("T")[0] : "--")
                            color: Theme.colors.textSecondary
                            font.pixelSize: 11
                            font.family: Theme.fontFamily
                        }
                    }
                }
            }
        }
    }
}
