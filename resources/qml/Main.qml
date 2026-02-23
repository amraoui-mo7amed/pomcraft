import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import "pages"

ApplicationWindow {
    id: root
    visible: true
    width: 920
    height: 720
    minimumWidth: 900
    minimumHeight: 600
    title: "Pomcraft"
    color: Theme.colors.background

    flags: Qt.Window | Qt.FramelessWindowHint

    property int currentPage: 0
    property string currentSession: "work"
    property bool isMaximized: false

    Rectangle {
        id: titleBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 48
        color: Theme.colors.surface
        z: 100

        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: Theme.colors.divider
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: Theme.spacing.lg
            anchors.rightMargin: Theme.spacing.md
            spacing: Theme.spacing.md

            RowLayout {
                spacing: Theme.spacing.sm

                Rectangle {
                    width: 32
                    height: 32
                    radius: Theme.radius.full
                    color: Theme.colors.primary

                    Text {
                        anchors.centerIn: parent
                        text: "P"
                        color: "white"
                        font.pixelSize: 16
                        font.bold: true
                        font.family: Theme.fontFamily
                    }
                }

                Text {
                    text: "Pomcraft"
                    color: Theme.colors.text
                    font.pixelSize: 18
                    font.bold: true
                    font.family: Theme.fontFamily
                }
            }

            Item { Layout.fillWidth: true }

            RowLayout {
                spacing: Theme.spacing.xs

                Rectangle {
                    width: 36
                    height: 36
                    radius: Theme.radius.sm
                    color: minimizeBtn.containsMouse ? Theme.colors.surfaceHover : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "−"
                        color: Theme.colors.textSecondary
                        font.pixelSize: 20
                        font.family: Theme.fontFamily
                    }

                    MouseArea {
                        id: minimizeBtn
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.showMinimized()
                    }
                }

                Rectangle {
                    width: 36
                    height: 36
                    radius: Theme.radius.sm
                    color: maximizeBtn.containsMouse ? Theme.colors.surfaceHover : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: root.isMaximized ? "❐" : "□"
                        color: Theme.colors.textSecondary
                        font.pixelSize: 18
                        font.family: Theme.fontFamily
                    }

                    MouseArea {
                        id: maximizeBtn
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (root.isMaximized) {
                                root.showNormal()
                            } else {
                                root.showMaximized()
                            }
                            root.isMaximized = !root.isMaximized
                        }
                    }
                }

                Rectangle {
                    width: 36
                    height: 36
                    radius: Theme.radius.sm
                    color: closeBtn.containsMouse ? Theme.colors.error : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "×"
                        color: closeBtn.containsMouse ? "white" : Theme.colors.textSecondary
                        font.pixelSize: 22
                        font.family: Theme.fontFamily
                    }

                    MouseArea {
                        id: closeBtn
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Qt.quit()
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            z: -1
            property point lastMousePos: Qt.point(0, 0)
            onPressed: function(mouse) { lastMousePos = Qt.point(mouse.x, mouse.y) }
            onPositionChanged: function(mouse) {
                if (pressed) {
                    root.x += mouse.x - lastMousePos.x
                    root.y += mouse.y - lastMousePos.y
                }
            }
            onDoubleClicked: {
                if (root.isMaximized) {
                    root.showNormal()
                } else {
                    root.showMaximized()
                }
                root.isMaximized = !root.isMaximized
            }
        }
    }

    RowLayout {
        anchors.top: titleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        spacing: 0

        Rectangle {
            id: sidebar
            implicitWidth: 220
            Layout.fillHeight: true
            color: Theme.colors.surface

            Rectangle {
                anchors.right: parent.right
                width: 1
                height: parent.height
                color: Theme.colors.divider
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Theme.spacing.md
                spacing: Theme.spacing.sm

                Repeater {
                    model: [
                        { name: "Home", icon: "🏠", page: 0 },
                        { name: "Timer", icon: "⏱", page: 1 },
                        { name: "Tasks", icon: "✓", page: 2 },
                        { name: "Settings", icon: "⚙", page: 3 }
                    ]

                    Rectangle {
                        Layout.fillWidth: true
                        height: 48
                        radius: Theme.radius.md
                        color: currentPage === modelData.page ? Theme.colors.primary : (navBtn.containsMouse ? Theme.colors.surfaceHover : "transparent")

                        Behavior on color {
                            ColorAnimation { duration: Theme.animation.fast }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: Theme.spacing.md
                            anchors.rightMargin: Theme.spacing.md
                            spacing: Theme.spacing.md

                            Text {
                                text: modelData.icon
                                color: currentPage === modelData.page ? "white" : Theme.colors.textSecondary
                                font.pixelSize: 20
                                font.family: Theme.fontFamily
                            }

                            Text {
                                text: modelData.name
                                color: currentPage === modelData.page ? "white" : Theme.colors.text
                                font.pixelSize: 15
                                font.weight: Font.Medium
                                font.family: Theme.fontFamily
                            }

                            Item { Layout.fillWidth: true }
                        }

                        MouseArea {
                            id: navBtn
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: currentPage = modelData.page
                        }
                    }
                }

                Item { Layout.fillHeight: true }

                Rectangle {
                    Layout.fillWidth: true
                    height: 80
                    radius: Theme.radius.md
                    color: Theme.colors.card
                    border.color: Theme.colors.cardBorder
                    border.width: 1

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Theme.spacing.xs

                        Text {
                            text: TimerBackend.getCompletedSessions().toString()
                            color: Theme.colors.primary
                            font.pixelSize: 28
                            font.bold: true
                            font.family: Theme.fontFamily
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Text {
                            text: "Sessions Today"
                            color: Theme.colors.textSecondary
                            font.pixelSize: Theme.typography.caption
                            font.family: Theme.fontFamily
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }
        }

        StackLayout {
            currentIndex: currentPage
            Layout.fillWidth: true
            Layout.fillHeight: true

            DashboardPage {}

            TimerPage {
                onSessionChanged: function(session) {
                    root.currentSession = session
                }
            }

            TasksPage {}

            SettingsPage {}
        }
    }

    Connections {
        target: TimerBackend
        function onSessionChanged(session) {
            root.currentSession = session
        }
    }
}
