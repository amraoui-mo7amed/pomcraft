import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import ".."

Rectangle {
    id: root

    signal taskAdded(string title, string description)

    width: 480
    height: 320
    radius: Theme.radius.xl
    color: Theme.colors.surface
    border.color: Theme.colors.divider
    border.width: 1
    visible: false
    z: 1000

    property bool isOpen: false

    onIsOpenChanged: {
        if (isOpen) {
            visible = true
            openAnimation.start()
            titleInput.forceActiveFocus()
        } else {
            closeAnimation.start()
        }
    }

    ParallelAnimation {
        id: openAnimation
        NumberAnimation { target: root; property: "opacity"; from: 0; to: 1; duration: Theme.animation.normal }
        NumberAnimation { target: root; property: "scale"; from: 0.9; to: 1.0; duration: Theme.animation.normal; easing.type: Easing.OutCubic }
    }

    SequentialAnimation {
        id: closeAnimation
        ParallelAnimation {
            NumberAnimation { target: root; property: "opacity"; to: 0; duration: Theme.animation.fast }
            NumberAnimation { target: root; property: "scale"; to: 0.9; duration: Theme.animation.fast }
        }
        PropertyAction { target: root; property: "visible"; value: false }
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        MouseArea {
            anchors.fill: parent
            onClicked: {}
        }
    }

    Rectangle {
        id: backdrop
        anchors.fill: parent
        anchors.margins: -1
        color: Theme.colors.background
        opacity: 0.5
        visible: false
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.spacing.lg
        spacing: Theme.spacing.md

        RowLayout {
            Layout.fillWidth: true

            Text {
                text: "Add New Task"
                color: Theme.colors.text
                font.pixelSize: Theme.typography.h4
                font.bold: true
                font.family: Theme.fontFamily
            }

            Item { Layout.fillWidth: true }

            Rectangle {
                width: 32
                height: 32
                radius: Theme.radius.full
                color: closeBtn.containsMouse ? Theme.colors.surfaceHover : "transparent"

                Text {
                    anchors.centerIn: parent
                    text: "×"
                    color: Theme.colors.textSecondary
                    font.pixelSize: 20
                    font.family: Theme.fontFamily
                }

                MouseArea {
                    id: closeBtn
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.close()
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing.md

            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing.xs

                Text {
                    text: "Title"
                    color: Theme.colors.textSecondary
                    font.pixelSize: Theme.typography.caption
                    font.family: Theme.fontFamily
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 44
                    radius: Theme.radius.md
                    color: Theme.colors.background
                    border.color: titleInput.activeFocus ? Theme.colors.primary : Theme.colors.divider
                    border.width: 1

                    Behavior on border.color {
                        ColorAnimation { duration: Theme.animation.fast }
                    }

                    TextInput {
                        id: titleInput
                        anchors.fill: parent
                        anchors.margins: Theme.spacing.md
                        verticalAlignment: TextInput.AlignVCenter
                        color: Theme.colors.text
                        font.pixelSize: Theme.typography.body
                        font.family: Theme.fontFamily
                        selectByMouse: true
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing.xs

                Text {
                    text: "Description (optional)"
                    color: Theme.colors.textSecondary
                    font.pixelSize: Theme.typography.caption
                    font.family: Theme.fontFamily
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 80
                    radius: Theme.radius.md
                    color: Theme.colors.background
                    border.color: descInput.activeFocus ? Theme.colors.primary : Theme.colors.divider
                    border.width: 1

                    Behavior on border.color {
                        ColorAnimation { duration: Theme.animation.fast }
                    }

                    ScrollView {
                        anchors.fill: parent
                        anchors.margins: Theme.spacing.md
                        clip: true

                        TextArea {
                            id: descInput
                            color: Theme.colors.text
                            font.pixelSize: Theme.typography.body
                            font.family: Theme.fontFamily
                            wrapMode: TextArea.Wrap
                            selectByMouse: true
                            background: null
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing.md

            Item { Layout.fillWidth: true }

            Rectangle {
                width: 100
                height: 40
                radius: Theme.radius.md
                color: Theme.colors.surfaceActive

                Text {
                    anchors.centerIn: parent
                    text: "Cancel"
                    color: Theme.colors.textSecondary
                    font.pixelSize: Theme.typography.body
                    font.family: Theme.fontFamily
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.close()
                }
            }

            Rectangle {
                width: 100
                height: 40
                radius: Theme.radius.md
                color: addBtnArea.containsMouse ? Theme.colors.primaryHover : Theme.colors.primary

                Text {
                    anchors.centerIn: parent
                    text: "Add Task"
                    color: "white"
                    font.pixelSize: Theme.typography.body
                    font.weight: Font.Medium
                    font.family: Theme.fontFamily
                }

                MouseArea {
                    id: addBtnArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (titleInput.text.trim()) {
                            root.taskAdded(titleInput.text.trim(), descInput.text.trim())
                            titleInput.text = ""
                            descInput.text = ""
                            root.close()
                        }
                    }
                }
            }
        }
    }

    function open() {
        isOpen = true
    }

    function close() {
        isOpen = false
    }
}
