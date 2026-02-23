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
        


        // Decorative background elements
        Rectangle {
            width: 400; height: 400
            
            radius: 200
            x: -100; y: -100
            color: Theme.colors.primary
            opacity: 0.03
        }
        
        Rectangle {
            width: 300; height: 300
            radius: 150
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: -50
            anchors.bottomMargin: -50
            color: Theme.colors.secondary
            opacity: 0.03
        }
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent
        contentWidth: availableWidth
        anchors.margins: Theme.spacing.xl

        clip: true

        ColumnLayout {
            id: mainColumn
            width: scrollView.availableWidth
            anchors.margins: Theme.spacing.xl
            spacing: Theme.spacing.xxl
            

            // Header Section
            Item {
                Layout.fillWidth: true
                implicitHeight: headerColumn.implicitHeight
                
                ColumnLayout {
                    id: headerColumn
                    anchors.fill: parent
                    spacing: Theme.spacing.xs
                    
                    Text {
                        text: "Focus Dashboard"
                        color: Theme.colors.text
                        font.pixelSize: Theme.typography.h2
                        font.bold: true
                        font.family: Theme.fontFamily
                    }
                    
                    Text {
                        text: "Welcome back! You've been productive today."
                        color: Theme.colors.textSecondary
                        font.pixelSize: Theme.typography.body
                        font.family: Theme.fontFamily
                    }
                }

                opacity: 0
                NumberAnimation on opacity {
                    to: 1
                    duration: 800
                    easing.type: Easing.OutCubic
                }
            }

            // Stats Grid
            GridLayout {
                Layout.fillWidth: true
                columns: 2
                columnSpacing: Theme.spacing.lg
                rowSpacing: Theme.spacing.lg

                // Main Stat Card
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 180
                    radius: Theme.radius.xl
                    color: Theme.colors.surface
                    border.color: Theme.colors.divider
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Theme.spacing.xl
                        spacing: Theme.spacing.xl

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Theme.spacing.xs
                            
                            Text {
                                text: "DAILY GOAL"
                                color: Theme.colors.textMuted
                                font.pixelSize: 12
                                font.letterSpacing: 1.5
                                font.bold: true
                                font.family: Theme.fontFamily
                            }

                            Text {
                                text: TimerBackend.getCompletedSessions() + " / 8"
                                color: Theme.colors.text
                                font.pixelSize: 42
                                font.bold: true
                                font.family: Theme.fontFamily
                            }
                            
                            Text {
                                text: "Sessions Completed"
                                color: Theme.colors.textSecondary
                                font.pixelSize: Theme.typography.bodySmall
                                font.family: Theme.fontFamily
                            }
                        }

                        // Progress Circle
                        Item {
                            width: 100
                            height: 100
                            
                            Rectangle {
                                anchors.fill: parent
                                radius: 50
                                color: "transparent"
                                border.color: Theme.colors.surfaceActive
                                border.width: 8
                            }
                            
                            // This is a visual representation of progress
                            Rectangle {
                                anchors.fill: parent
                                radius: 50
                                color: "transparent"
                                border.color: Theme.colors.primary
                                border.width: 8
                                // Simplified progress arc using a clipper for a creative look
                                Rectangle {
                                    width: 100; height: 50
                                    color: Theme.colors.surface
                                    anchors.bottom: parent.bottom
                                    visible: TimerBackend.getCompletedSessions() < 4
                                }
                            }
                            
                            Text {
                                anchors.centerIn: parent
                                text: Math.round((TimerBackend.getCompletedSessions() / 8) * 100) + "%"
                                color: Theme.colors.primary
                                font.pixelSize: 18
                                font.bold: true
                            }
                        }
                    }
                }

                // Tasks Overview Card
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 180
                    radius: Theme.radius.xl
                    color: Theme.colors.surface
                    border.color: Theme.colors.divider
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Theme.spacing.xl
                        spacing: Theme.spacing.lg

                        Text {
                            text: "TASK COMPLETION"
                            color: Theme.colors.textMuted
                            font.pixelSize: 12
                            font.letterSpacing: 1.5
                            font.bold: true
                            font.family: Theme.fontFamily
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Theme.spacing.xxl
                            
                            ColumnLayout {
                                Text {
                                    text: TasksBackend.getCompletedCount()
                                    color: Theme.colors.success
                                    font.pixelSize: 42
                                    font.bold: true
                                    font.family: Theme.fontFamily
                                }
                                Text {
                                    text: "Finished"
                                    color: Theme.colors.textSecondary
                                    font.pixelSize: Theme.typography.bodySmall
                                }
                            }

                            ColumnLayout {
                                Text {
                                    text: TasksBackend.getTaskCount() - TasksBackend.getCompletedCount()
                                    color: Theme.colors.warning
                                    font.pixelSize: 42
                                    font.bold: true
                                    font.family: Theme.fontFamily
                                }
                                Text {
                                    text: "Remaining"
                                    color: Theme.colors.textSecondary
                                    font.pixelSize: Theme.typography.bodySmall
                                }
                            }
                            
                            Item { Layout.fillWidth: true }
                        }
                    }
                }
            }

            // Focus Distribution Section
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 340
                radius: Theme.radius.xl
                color: Theme.colors.surface
                border.color: Theme.colors.divider
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.spacing.xl
                    spacing: Theme.spacing.xl

                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: "WEEKLY ACTIVITY"
                            color: Theme.colors.textMuted
                            font.pixelSize: 12
                            font.letterSpacing: 1.5
                            font.bold: true
                            font.family: Theme.fontFamily
                        }
                        Item { Layout.fillWidth: true }
                        Text {
                            text: "Total: 12h 45m"
                            color: Theme.colors.primary
                            font.pixelSize: 12
                            font.bold: true
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: Theme.spacing.lg

                        Repeater {
                            model: [
                                {day: "Mon", val: 0.4},
                                {day: "Tue", val: 0.7},
                                {day: "Wed", val: 0.5},
                                {day: "Thu", val: 0.9},
                                {day: "Fri", val: 0.6},
                                {day: "Sat", val: 0.3},
                                {day: "Sun", val: 0.2}
                            ]
                            
                            ColumnLayout {
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignBottom
                                spacing: Theme.spacing.sm
                                
                                Rectangle {
                                    id: barContainer
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    color: "transparent"
                                    
                                    Rectangle {
                                        id: bar
                                        anchors.bottom: parent.bottom
                                        width: parent.width * 0.6
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        radius: Theme.radius.sm
                                        color: modelData.val > 0.8 ? Theme.colors.primary : Theme.colors.surfaceActive
                                        
                                        // Visual highlight on top
                                        Rectangle {
                                            width: parent.width; height: 4
                                            radius: 2
                                            color: "white"; opacity: 0.2
                                            anchors.top: parent.top
                                        }

                                        height: 0
                                        NumberAnimation on height {
                                            from: 0
                                            to: barContainer.height * modelData.val
                                            duration: 1200
                                            easing.type: Easing.OutElastic
                                            easing.amplitude: 0.5
                                            easing.period: 0.6
                                        }
                                    }
                                }
                                
                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: modelData.day
                                    color: Theme.colors.textMuted
                                    font.pixelSize: 11
                                    font.family: Theme.fontFamily
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
