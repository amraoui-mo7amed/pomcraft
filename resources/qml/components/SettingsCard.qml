import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import ".."

Rectangle {
    id: root

    property string title: ""
    property string icon: ""
    property string description: ""

    default property alias content: contentContainer.children

    Layout.fillWidth: true
    implicitHeight: contentContainer.implicitHeight + headerContainer.height + Theme.spacing.lg * 2 + 15
    radius: Theme.radius.lg
    color: Theme.colors.surface
    border.color: Theme.colors.divider
    border.width: 1

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.margins: Theme.spacing.lg
        spacing: Theme.spacing.md

        RowLayout {
            id: headerContainer
            Layout.fillWidth: true
            spacing: Theme.spacing.md

            Rectangle {
                width: 40
                height: 40
                radius: Theme.radius.md
                color: Theme.colors.surfaceActive

                Text {
                    anchors.centerIn: parent
                    text: root.icon
                    font.pixelSize: 20
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing.xs

                Text {
                    text: root.title
                    color: Theme.colors.text
                    font.pixelSize: Theme.typography.body
                    font.weight: Font.Medium
                    font.family: Theme.fontFamily
                }

                Text {
                    text: root.description
                    color: Theme.colors.textMuted
                    font.pixelSize: Theme.typography.caption
                    font.family: Theme.fontFamily
                    visible: text.length > 0
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }
            }
        }

        ColumnLayout {
            id: contentContainer
            Layout.fillWidth: true
            spacing: Theme.spacing.md
        }
    }
}
