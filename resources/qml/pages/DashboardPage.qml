import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"
import ".."

Item {
    id: root

    Rectangle {
        anchors.fill: parent
        color: Theme.colors.background

        // Decorative background glow
        Rectangle {
            width: parent.width * 0.8
            height: width
            radius: width / 2
            x: -width * 0.3
            y: -height * 0.3
            color: Theme.colors.primary
            opacity: 0.05
        }
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent
        anchors.margins: Theme.spacing.xl

        clip: true
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        ColumnLayout {
            width: scrollView.availableWidth
            spacing: Theme.spacing.xxl

            // 1. Dynamic Greeting Section
            RowLayout {
                Layout.fillWidth: true
                ColumnLayout {
                    spacing: 4
                    Text {
                        text: {
                            const hour = new Date().getHours();
                            if (hour < 12)
                                return "GOOD MORNING";
                            if (hour < 18)
                                return "GOOD AFTERNOON";
                            return "GOOD EVENING";
                        }
                        color: Theme.colors.primary
                        font.pixelSize: 12
                        font.letterSpacing: 2
                        font.bold: true
                        font.family: Theme.fontFamily
                    }
                    Text {
                        text: "Ready to stay focused?"
                        color: Theme.colors.text
                        font.pixelSize: Theme.typography.h2
                        font.bold: true
                        font.family: Theme.fontFamily
                    }
                }
                Item {
                    Layout.fillWidth: true
                }

                Rectangle {
                    height: 44
                    width: dateText.implicitWidth + 40
                    radius: Theme.radius.full
                    color: Theme.colors.surface
                    border.color: Theme.colors.divider
                    Text {
                        id: dateText
                        anchors.centerIn: parent
                        text: new Date().toLocaleDateString(undefined, {
                            weekday: 'long',
                            month: 'short',
                            day: 'numeric'
                        })
                        color: Theme.colors.textSecondary
                        font.family: Theme.fontFamily
                        font.pixelSize: 13
                    }
                }
            }

            // 2. Dynamic Stat Pills
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing.lg

                // Stat: Total Projects
                Rectangle {
                    Layout.fillWidth: true
                    height: 140
                    radius: Theme.radius.xl
                    color: Theme.colors.surface
                    border.color: Theme.colors.divider
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Theme.spacing.xl
                        spacing: Theme.spacing.lg

                        Item {
                            width: 56
                            height: 56
                            Rectangle {
                                anchors.fill: parent
                                radius: 28
                                color: Theme.colors.text
                                opacity: 0.1
                            }
                            Text {
                                anchors.centerIn: parent
                                text: Theme.icons.projects
                                font.family: Theme.iconFontFamily
                                font.pixelSize: 24
                                color: Theme.colors.text
                            }
                        }
                        ColumnLayout {
                            spacing: 2
                            Text {
                                text: ProjectsBackend.getProjectCount().toString()
                                color: Theme.colors.text
                                font.pixelSize: 34
                                font.bold: true
                            }
                            Text {
                                text: "Total Projects"
                                color: Theme.colors.textMuted
                                font.pixelSize: 13
                                font.bold: true
                            }
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                    }
                }

                // Stat: Active Projects
                Rectangle {
                    Layout.fillWidth: true
                    height: 140
                    radius: Theme.radius.xl
                    color: Theme.colors.surface
                    border.color: Theme.colors.divider
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Theme.spacing.xl
                        spacing: Theme.spacing.lg

                        Item {
                            width: 56
                            height: 56
                            Rectangle {
                                anchors.fill: parent
                                radius: 28
                                color: Theme.colors.primary
                                opacity: 0.15
                            }
                            Text {
                                anchors.centerIn: parent
                                text: Theme.icons.fire
                                font.family: Theme.iconFontFamily
                                font.pixelSize: 24
                                color: Theme.colors.primary
                            }
                        }
                        ColumnLayout {
                            spacing: 2
                            Text {
                                text: ProjectsBackend.getProjectCountByStatus("active").toString()
                                color: Theme.colors.primary
                                font.pixelSize: 34
                                font.bold: true
                            }
                            Text {
                                text: "Active Projects"
                                color: Theme.colors.textMuted
                                font.pixelSize: 13
                                font.bold: true
                            }
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                    }
                }

                // Stat: Completed Projects
                Rectangle {
                    Layout.fillWidth: true
                    height: 140
                    radius: Theme.radius.xl
                    color: Theme.colors.surface
                    border.color: Theme.colors.divider
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Theme.spacing.xl
                        spacing: Theme.spacing.lg

                        Item {
                            width: 56
                            height: 56
                            Rectangle {
                                anchors.fill: parent
                                radius: 28
                                color: Theme.colors.success
                                opacity: 0.15
                            }
                            Text {
                                anchors.centerIn: parent
                                text: Theme.icons.check
                                font.family: Theme.iconFontFamily
                                font.pixelSize: 24
                                color: Theme.colors.success
                            }
                        }
                        ColumnLayout {
                            spacing: 2
                            Text {
                                text: ProjectsBackend.getProjectCountByStatus("completed").toString()
                                color: Theme.colors.success
                                font.pixelSize: 34
                                font.bold: true
                            }
                            Text {
                                text: "Completed Projects"
                                color: Theme.colors.textMuted
                                font.pixelSize: 13
                                font.bold: true
                            }
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                    }
                }
            }

            // 3. Creative Insights Row
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 380
                spacing: Theme.spacing.lg

                // Insights Section (Chart & Health)
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: Theme.radius.xl
                    color: Theme.colors.surface
                    border.color: Theme.colors.divider

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Theme.spacing.xl
                        spacing: Theme.spacing.xl

                        // Chart 1: Project Activity Bar Chart
                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            Text {
                                text: "ACTIVITY GROWTH"
                                color: Theme.colors.textMuted
                                font.pixelSize: 11
                                font.letterSpacing: 1.5
                                font.bold: true
                            }

                            Item {
                                Layout.fillHeight: true
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 180
                                spacing: 15

                                Repeater {
                                    model: [0.3, 0.5, 0.4, 0.8, 0.6, 0.5, 0.7]

                                    Item {
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true

                                        Rectangle {
                                            anchors.bottom: parent.bottom
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            width: Math.min(40, parent.width * 0.6)
                                            radius: 6
                                            color: index === 6 ? Theme.colors.primary : Theme.colors.textMuted
                                            opacity: index === 6 ? 1.0 : 0.3

                                            property real heightFactor: 0
                                            height: parent.height * modelData * heightFactor

                                            NumberAnimation on heightFactor {
                                                from: 0
                                                to: 1
                                                duration: 1500
                                                easing.type: Easing.OutCubic
                                                running: true
                                            }
                                        }
                                    }
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Repeater {
                                    model: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                                    Text {
                                        Layout.fillWidth: true
                                        text: modelData
                                        color: Theme.colors.textMuted
                                        font.pixelSize: 10
                                        horizontalAlignment: Text.AlignHCenter
                                    }
                                }
                            }
                        }

                        // Vertical Divider
                        Rectangle {
                            Layout.fillHeight: true
                            width: 1
                            color: Theme.colors.divider
                        }

                        // Chart 2: Task Distribution / Project Health
                        ColumnLayout {
                            Layout.preferredWidth: 220
                            Layout.fillHeight: true
                            spacing: Theme.spacing.md

                            Text {
                                text: "TASK STATUS"
                                color: Theme.colors.textMuted
                                font.pixelSize: 11
                                font.letterSpacing: 1.5
                                font.bold: true
                            }

                            Item {
                                Layout.fillHeight: true
                            }

                            ColumnLayout {
                                spacing: 6
                                Layout.fillWidth: true
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text {
                                        text: "Completed"
                                        color: Theme.colors.textSecondary
                                        font.pixelSize: 12
                                        Layout.fillWidth: true
                                    }
                                    Text {
                                        text: "65%"
                                        color: Theme.colors.success
                                        font.pixelSize: 12
                                        font.bold: true
                                    }
                                }
                                Rectangle {
                                    Layout.fillWidth: true
                                    height: 8
                                    radius: 4
                                    color: Theme.colors.surfaceActive
                                    Rectangle {
                                        height: parent.height
                                        radius: 4
                                        color: Theme.colors.success
                                        property real widthFactor: 0
                                        width: parent.width * 0.65 * widthFactor
                                        NumberAnimation on widthFactor {
                                            from: 0
                                            to: 1
                                            duration: 1500
                                            easing.type: Easing.OutCubic
                                            running: true
                                        }
                                    }
                                }
                            }

                            ColumnLayout {
                                spacing: 6
                                Layout.fillWidth: true
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text {
                                        text: "In Progress"
                                        color: Theme.colors.textSecondary
                                        font.pixelSize: 12
                                        Layout.fillWidth: true
                                    }
                                    Text {
                                        text: "25%"
                                        color: Theme.colors.primary
                                        font.pixelSize: 12
                                        font.bold: true
                                    }
                                }
                                Rectangle {
                                    Layout.fillWidth: true
                                    height: 8
                                    radius: 4
                                    color: Theme.colors.surfaceActive
                                    Rectangle {
                                        height: parent.height
                                        radius: 4
                                        color: Theme.colors.primary
                                        property real widthFactor: 0
                                        width: parent.width * 0.25 * widthFactor
                                        NumberAnimation on widthFactor {
                                            from: 0
                                            to: 1
                                            duration: 1500
                                            easing.type: Easing.OutCubic
                                            running: true
                                        }
                                    }
                                }
                            }

                            ColumnLayout {
                                spacing: 6
                                Layout.fillWidth: true
                                RowLayout {
                                    Layout.fillWidth: true
                                    Text {
                                        text: "Pending Review"
                                        color: Theme.colors.textSecondary
                                        font.pixelSize: 12
                                        Layout.fillWidth: true
                                    }
                                    Text {
                                        text: "10%"
                                        color: Theme.colors.warning
                                        font.pixelSize: 12
                                        font.bold: true
                                    }
                                }
                                Rectangle {
                                    Layout.fillWidth: true
                                    height: 8
                                    radius: 4
                                    color: Theme.colors.surfaceActive
                                    Rectangle {
                                        height: parent.height
                                        radius: 4
                                        color: Theme.colors.warning
                                        property real widthFactor: 0
                                        width: parent.width * 0.10 * widthFactor
                                        NumberAnimation on widthFactor {
                                            from: 0
                                            to: 1
                                            duration: 1500
                                            easing.type: Easing.OutCubic
                                            running: true
                                        }
                                    }
                                }
                            }

                            Item {
                                Layout.fillHeight: true
                            }
                        }
                    }
                }

                // Latest Project Insight Card
                Rectangle {
                    Layout.preferredWidth: 320
                    Layout.fillHeight: true
                    radius: Theme.radius.xl
                    color: Theme.colors.surface
                    border.color: Theme.colors.divider

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Theme.spacing.xl
                        spacing: Theme.spacing.lg

                        Text {
                            text: "LATEST ACTIVE PROJECT"
                            color: Theme.colors.textMuted
                            font.pixelSize: 11
                            font.letterSpacing: 1.5
                            font.bold: true
                        }

                        Item {
                            Layout.fillHeight: true
                        }

                        property var latestProject: {
                            var projects = ProjectsBackend.getActiveProjects();
                            return projects.length > 0 ? projects[0] : null;
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Theme.spacing.md
                            visible: parent.latestProject !== null

                            Rectangle {
                                width: 56
                                height: 56
                                radius: 28
                                color: Theme.colors.primary
                                opacity: 0.1
                                Layout.alignment: Qt.AlignHCenter

                                Text {
                                    anchors.centerIn: parent
                                    text: "🚀"
                                    font.pixelSize: 24
                                }
                            }

                            Text {
                                text: parent.parent.latestProject ? parent.parent.latestProject.title : ""
                                color: Theme.colors.text
                                font.pixelSize: 18
                                font.bold: true
                                Layout.alignment: Qt.AlignHCenter
                                elide: Text.ElideRight
                                Layout.maximumWidth: 240
                            }

                            Text {
                                text: parent.parent.latestProject ? (parent.parent.latestProject.client_name || "No Client") : ""
                                color: Theme.colors.textSecondary
                                font.pixelSize: 13
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Rectangle {
                                height: 24
                                width: statusText.implicitWidth + 20
                                radius: 12
                                color: Theme.colors.primary
                                opacity: 0.1
                                Layout.alignment: Qt.AlignHCenter
                                Text {
                                    id: statusText
                                    anchors.centerIn: parent
                                    text: "ACTIVE"
                                    color: Theme.colors.primary
                                    font.pixelSize: 10
                                    font.bold: true
                                }
                            }
                        }

                        Text {
                            visible: parent.latestProject === null
                            text: "No active projects.\nCreate one to get started!"
                            color: Theme.colors.textMuted
                            font.pixelSize: 13
                            horizontalAlignment: Text.AlignHCenter
                            Layout.fillWidth: true
                        }

                        Item {
                            Layout.fillHeight: true
                        }
                    }
                }
            }
            Item {
                Layout.preferredHeight: Theme.spacing.md
            }
        }
    }
}
