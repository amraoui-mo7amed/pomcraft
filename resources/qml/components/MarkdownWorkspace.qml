import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import ".."

Item {
    id: root

    property string text: ""
    property string placeholder: "No content yet. Click Edit to start writing..."
    signal contentUpdated(string newText)
    
    property string mode: "preview" // "preview" or "edit"

    Rectangle {
        anchors.fill: parent
        radius: 7
        color: Theme.colors.background
        border.width: 1
        border.color: Theme.colors.divider

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // New Modern Toolbar
            Rectangle {
                Layout.fillWidth: true
                height: 50
                color: Theme.colors.surfaceActive
                radius: 7
                Rectangle { height: 20; anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; color: parent.color }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Theme.spacing.lg
                    anchors.rightMargin: Theme.spacing.lg
                    spacing: Theme.spacing.md

                    // Current Mode Label
                    Text {
                        text: (root.mode === "preview" ? Theme.icons.eye : Theme.icons.edit) + "  " + root.mode.toUpperCase()
                        font.family: Theme.iconFontFamily
                        color: Theme.colors.primary
                        font.pixelSize: 11
                        font.bold: true
                        font.letterSpacing: 1.2
                    }

                    Item { Layout.fillWidth: true }

                    // Action Buttons Row
                    RowLayout {
                        spacing: Theme.spacing.sm

                        // 1. Preview Toggle
                        ActionIcon {
                            icon: Theme.icons.eye
                            label: "Preview"
                            active: root.mode === "preview"
                            onClicked: root.mode = "preview"
                        }

                        // 2. Edit Toggle
                        ActionIcon {
                            icon: Theme.icons.edit
                            label: "Edit"
                            active: root.mode === "edit"
                            onClicked: root.mode = "edit"
                        }

                        // 3. Generate (AI)
                        ActionIcon {
                            icon: Theme.icons.magic
                            label: "Generate"
                            onClicked: console.log("AI Generation triggered...")
                        }

                        // 4. Copy
                        ActionIcon {
                            icon: Theme.icons.copy
                            label: "Copy"
                            onClicked: {
                                if (typeof Clipboard !== 'undefined') {
                                    Clipboard.setText(root.text)
                                }
                            }
                        }
                    }
                }
            }

            // Content Area
            StackLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: root.mode === "preview" ? 0 : 1

                // Preview View
                ScrollView {
                    clip: true
                    Text {
                        width: parent.width
                        text: root.text !== "" ? root.text : "*" + root.placeholder + "*"
                        color: root.text !== "" ? Theme.colors.text : Theme.colors.textMuted
                        font.family: Theme.fontFamily
                        font.pixelSize: 15
                        wrapMode: Text.WordWrap
                        textFormat: Text.MarkdownText
                        leftPadding: Theme.spacing.xl
                        rightPadding: Theme.spacing.xl
                        topPadding: Theme.spacing.xl
                        bottomPadding: Theme.spacing.xl
                        onLinkActivated: (link) => Qt.openUrlExternally(link)
                    }
                }

                // Edit View
                ScrollView {
                    clip: true
                    TextArea {
                        id: editorArea
                        text: root.text
                        color: Theme.colors.text
                        font.family: "Inter"
                        font.pixelSize: 15
                        wrapMode: TextEdit.Wrap
                        selectByMouse: true
                        textFormat: TextEdit.PlainText
                        
                        leftPadding: Theme.spacing.xl
                        rightPadding: Theme.spacing.xl
                        topPadding: Theme.spacing.xl
                        bottomPadding: Theme.spacing.xl

                        placeholderText: root.placeholder
                        
                        Component.onCompleted: {
                            if (typeof Highlighter !== 'undefined') {
                                Highlighter.apply(editorArea)
                            }
                        }

                        onTextChanged: {
                            if (root.text !== text) {
                                root.text = text
                                root.contentUpdated(text)
                            }
                        }
                    }
                }
            }
        }
    }

    // External text sync
    onTextChanged: {
        if (editorArea.text !== text) {
            editorArea.text = text
        }
    }

    // Inline Component for Toolbar Buttons
    component ActionIcon : Rectangle {
        id: actionButton
        property string icon: ""
        property string label: ""
        property bool active: false
        signal clicked()

        width: 36
        height: 36
        radius: 7
        color: active ? Theme.colors.primary : (ma.containsMouse ? Theme.colors.surfaceHover : "transparent")
        
        Behavior on color { ColorAnimation { duration: 200 } }

        Text {
            anchors.centerIn: parent
            text: actionButton.icon
            font.family: Theme.iconFontFamily
            font.pixelSize: 14
            color: active ? "white" : Theme.colors.textSecondary
        }

        ToolTip.visible: ma.containsMouse
        ToolTip.text: actionButton.label
        ToolTip.delay: 500

        MouseArea {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: actionButton.clicked()
        }
    }
}
