import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import ".."

Rectangle {
    id: root
    Layout.fillWidth: true
    height: 160
    radius: 7
    color: Theme.colors.surface
    border.color: Theme.getSessionColor(TimerBackend.sessionType)
    border.width: 1

    property bool isRunning: TimerBackend.isRunning
    property int timeRemaining: TimerBackend.timeRemaining
    property string sessionType: TimerBackend.sessionType

    DragHandler {
        id: dragHandler
        target: root
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.SizeAllCursor
        acceptedButtons: Qt.NoButton
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.spacing.md
        spacing: Theme.spacing.sm

        RowLayout {
            Layout.fillWidth: true

            Rectangle {
                width: 8
                height: 8
                radius: 4
                color: root.isRunning ? Theme.getSessionColor(root.sessionType) : Theme.colors.textMuted

                SequentialAnimation on opacity {
                    running: root.isRunning
                    loops: Animation.Infinite
                    NumberAnimation {
                        from: 1.0
                        to: 0.3
                        duration: 800
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        from: 0.3
                        to: 1.0
                        duration: 800
                        easing.type: Easing.InOutQuad
                    }
                }
            }

            Text {
                text: Theme.getSessionLabel(root.sessionType).toUpperCase()
                color: Theme.colors.textSecondary
                font.pixelSize: 10
                font.bold: true
                font.letterSpacing: 1.5
                font.family: Theme.fontFamily
            }

            Item {
                Layout.fillWidth: true
            }

            Text {
                text: "#" + (TimerBackend.getCompletedSessions() + 1)
                color: Theme.colors.textMuted
                font.pixelSize: 10
                font.family: Theme.fontFamily
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: Theme.formatTime(root.timeRemaining)
            color: Theme.colors.text
            font.pixelSize: 42
            font.bold: true
            font.family: Theme.fontFamily
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: Theme.spacing.lg

            Rectangle {
                width: 32
                height: 32
                radius: 7
                color: resetMouse.containsMouse ? Theme.colors.surfaceHover : "transparent"
                Text {
                    anchors.centerIn: parent
                    text: Theme.icons.reset
                    font.family: Theme.iconFontFamily
                    color: Theme.colors.textSecondary
                    font.pixelSize: 14
                }
                MouseArea {
                    id: resetMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: TimerBackend.reset()
                }
            }

            Rectangle {
                width: 44
                height: 44
                radius: 7
                color: Theme.colors.primary

                Text {
                    anchors.centerIn: parent
                    text: root.isRunning ? Theme.icons.pause : Theme.icons.play
                    font.family: Theme.iconFontFamily
                    color: "white"
                    font.pixelSize: 18
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (root.isRunning)
                            TimerBackend.pause();
                        else
                            TimerBackend.start();
                    }
                }
            }

            Rectangle {
                width: 32
                height: 32
                radius: 7
                color: skipMouse.containsMouse ? Theme.colors.surfaceHover : "transparent"
                Text {
                    anchors.centerIn: parent
                    text: Theme.icons.skip
                    font.family: Theme.iconFontFamily
                    color: Theme.colors.textSecondary
                    font.pixelSize: 14
                }
                MouseArea {
                    id: skipMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: TimerBackend.skip()
                }
            }
        }
    }
}
