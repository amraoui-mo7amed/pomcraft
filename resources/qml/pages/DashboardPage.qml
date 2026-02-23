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
            width: parent.width * 0.8; height: width
            radius: width / 2
            x: -width * 0.3; y: -height * 0.3
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
                            if (hour < 12) return "GOOD MORNING";
                            if (hour < 18) return "GOOD AFTERNOON";
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
                Item { Layout.fillWidth: true }
                
                Rectangle {
                    height: 44
                    width: dateText.implicitWidth + 40
                    radius: Theme.radius.full
                    color: Theme.colors.surface
                    border.color: Theme.colors.divider
                    Text {
                        id: dateText
                        anchors.centerIn: parent
                        text: new Date().toLocaleDateString(undefined, { weekday: 'long', month: 'short', day: 'numeric' })
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

                // Stat: Focus Time
                Rectangle {
                    Layout.fillWidth: true; height: 160
                    radius: Theme.radius.xl; color: Theme.colors.surface; border.color: Theme.colors.divider
                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 8
                        Text {
                            property int totalMins: TimerBackend.getCompletedSessions() * 25
                            text: Math.floor(totalMins / 60) + "h " + (totalMins % 60) + "m"
                            color: Theme.colors.text; font.pixelSize: 32; font.bold: true
                        }
                        Text { text: "Total Focus"; color: Theme.colors.textMuted; font.pixelSize: 12 }
                    }
                }

                // Stat: Completion Rate
                Rectangle {
                    Layout.fillWidth: true; height: 160
                    radius: Theme.radius.xl; color: Theme.colors.surface; border.color: Theme.colors.divider
                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 8
                        Text {
                            property real rate: TasksBackend.getTaskCount() > 0 ? (TasksBackend.getCompletedCount() / TasksBackend.getTaskCount()) * 100 : 0
                            text: Math.round(rate) + "%"
                            color: Theme.colors.success; font.pixelSize: 32; font.bold: true
                        }
                        Text { text: "Completion Rate"; color: Theme.colors.textMuted; font.pixelSize: 12 }
                    }
                }

                // Stat: Streak
                Rectangle {
                    Layout.fillWidth: true; height: 160
                    radius: Theme.radius.xl; color: Theme.colors.surface; border.color: Theme.colors.divider
                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 8
                        Text {
                            text: "🔥 " + (TimerBackend.getCompletedSessions() > 0 ? TimerBackend.getCompletedSessions() : 0)
                            color: Theme.colors.warning; font.pixelSize: 32; font.bold: true
                        }
                        Text { text: "Session Streak"; color: Theme.colors.textMuted; font.pixelSize: 12 }
                    }
                }
            }

            // 3. Creative Insights Row
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 380
                spacing: Theme.spacing.lg

                // Weekly Chart (Visual)
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: Theme.radius.xl
                    color: Theme.colors.surface
                    border.color: Theme.colors.divider

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Theme.spacing.xl
                        
                        Text {
                            text: "WEEKLY ACTIVITY"
                            color: Theme.colors.textMuted
                            font.pixelSize: 11
                            font.letterSpacing: 1.5
                            font.bold: true
                        }
                        
                        Item { Layout.fillHeight: true }
                        
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 180
                            spacing: 15

                            Repeater {
                                model: [0.4, 0.7, 0.5, 0.9, 0.6, 0.4, 0.3]
                                
                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    
                                    Rectangle {
                                        id: chartBar
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        width: parent.width * 0.6
                                        radius: 6
                                        color: index === 3 ? Theme.colors.primary : Theme.colors.surfaceActive
                                        opacity: index === 3 ? 1.0 : 0.5
                                        
                                        property real targetHeight: parent.height * modelData
                                        
                                        NumberAnimation on height {
                                            from: 0
                                            to: chartBar.targetHeight
                                            duration: 1500
                                            easing.type: Easing.OutElastic
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
                }

                // Top Task Insight Card
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
                            text: "TOP FOCUS TASK"
                            color: Theme.colors.textMuted
                            font.pixelSize: 11
                            font.letterSpacing: 1.5
                            font.bold: true
                        }

                        Item { Layout.fillHeight: true }
                        
                        property var topTask: {
                            var tasks = TasksBackend.getTasks()
                            if (tasks.length === 0) return null
                            var top = tasks[0]
                            for (var i = 1; i < tasks.length; i++) {
                                if (tasks[i].pomodoros_completed > top.pomodoros_completed) {
                                    top = tasks[i]
                                }
                            }
                            return top.pomodoros_completed > 0 ? top : null
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Theme.spacing.md
                            visible: parent.topTask !== null

                            Rectangle {
                                width: 56
                                height: 56
                                radius: 28
                                color: Theme.colors.primary
                                opacity: 0.1
                                Layout.alignment: Qt.AlignHCenter
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "⭐"
                                    font.pixelSize: 24
                                }
                            }

                            Text {
                                text: parent.parent.topTask ? parent.parent.topTask.title : ""
                                color: Theme.colors.text
                                font.pixelSize: 18
                                font.bold: true
                                Layout.alignment: Qt.AlignHCenter
                                elide: Text.ElideRight
                                Layout.maximumWidth: 200
                            }

                            Text {
                                text: parent.parent.topTask ? parent.parent.topTask.pomodoros_completed + " Pomodoros" : ""
                                color: Theme.colors.primary
                                font.pixelSize: 13
                                font.bold: true
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                        
                        Text {
                            visible: parent.topTask === null
                            text: "No focus data yet.\nComplete pomodoros to see insights!"
                            color: Theme.colors.textMuted
                            font.pixelSize: 13
                            horizontalAlignment: Text.AlignHCenter
                            Layout.fillWidth: true
                        }

                        Item { Layout.fillHeight: true }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacing.md }
        }
    }
}
