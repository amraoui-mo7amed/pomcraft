import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import ".."
import "../components"

Item {
    id: root

    Rectangle {
        anchors.fill: parent
        color: Theme.colors.background
    }

    ScrollView {
        anchors.fill: parent
        anchors.margins: Theme.spacing.xl
        clip: true

        ColumnLayout {
            width: root.width - (Theme.spacing.xl * 2)
            spacing: Theme.spacing.xxl

            Text {
                text: "Settings"
                color: Theme.colors.text
                font.pixelSize: Theme.typography.h3
                font.bold: true
                font.family: Theme.fontFamily
            }

            SettingsCard {
                title: "Timer"
                icon: "⏱"
                Layout.fillWidth: true

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing.md

                    SettingsSlider {
                        Layout.fillWidth: true
                        label: "Work Duration"
                        value: SettingsBackend.getWorkDuration()
                        from: 1
                        to: 60
                        suffix: " min"
                        onSliderValueChanged: function (newValue) {
                            SettingsBackend.setWorkDuration(newValue);
                        }
                    }

                    SettingsSlider {
                        Layout.fillWidth: true
                        label: "Short Break"
                        value: SettingsBackend.getShortBreakDuration()
                        from: 1
                        to: 30
                        suffix: " min"
                        onSliderValueChanged: function (newValue) {
                            SettingsBackend.setShortBreakDuration(newValue);
                        }
                    }

                    SettingsSlider {
                        Layout.fillWidth: true
                        label: "Long Break"
                        value: SettingsBackend.getLongBreakDuration()
                        from: 5
                        to: 60
                        suffix: " min"
                        onSliderValueChanged: function (newValue) {
                            SettingsBackend.setLongBreakDuration(newValue);
                        }
                    }
                }
            }

            SettingsCard {
                Layout.fillWidth: true
                title: "Gemini API"
                icon: "🤖"
                description: "Enter your Gemini API key to enable AI-powered task generation from Markdown files."

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing.md

                    Rectangle {
                        Layout.fillWidth: true
                        height: 48
                        radius: Theme.radius.md
                        color: Theme.colors.surface
                        border.color: apiKeyInput.activeFocus ? Theme.colors.primary : Theme.colors.divider
                        border.width: 1

                        Behavior on border.color {
                            ColorAnimation {
                                duration: Theme.animation.fast
                            }
                        }

                        TextInput {
                            id: apiKeyInput
                            anchors.fill: parent
                            anchors.margins: Theme.spacing.md
                            verticalAlignment: TextInput.AlignVCenter
                            text: SettingsBackend.getApiKey()
                            color: Theme.colors.text
                            font.pixelSize: Theme.typography.body
                            font.family: Theme.fontFamily
                            echoMode: TextInput.Password
                            selectByMouse: true

                            onTextChanged: SettingsBackend.setApiKey(text)
                        }
                    }

                    Text {
                        text: "The API key is stored locally and never sent to our servers."
                        color: Theme.colors.textMuted
                        font.pixelSize: Theme.typography.caption
                        font.family: Theme.fontFamily
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                }
            }

            SettingsCard {
                title: "Notifications"
                icon: "🔔"
                Layout.fillWidth: true

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing.md

                    SettingsToggle {
                        Layout.fillWidth: true
                        label: "Sound Effects"
                        description: "Play a sound when sessions complete"
                        checked: SettingsBackend.getNotificationSound()
                        onToggled: function (newChecked) {
                            SettingsBackend.setNotificationSound(newChecked);
                        }
                    }

                    SettingsToggle {
                        Layout.fillWidth: true
                        label: "Auto-start Breaks"
                        description: "Automatically start break timers"
                        checked: SettingsBackend.getAutoStartBreaks()
                        onToggled: function (newChecked) {
                            SettingsBackend.setAutoStartBreaks(newChecked);
                        }
                    }
                }
            }

            SettingsCard {
                title: "About"
                icon: "ℹ"
                Layout.fillWidth: true

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing.sm

                    Text {
                        text: "Pomcraft"
                        color: Theme.colors.text
                        font.pixelSize: Theme.typography.h4
                        font.bold: true
                        font.family: Theme.fontFamily
                    }

                    Text {
                        text: "Version 0.1.0"
                        color: Theme.colors.textSecondary
                        font.pixelSize: Theme.typography.bodySmall
                        font.family: Theme.fontFamily
                    }

                    Text {
                        text: "Craft your focus. An open-source Pomodoro timer with Markdown task support and AI-powered task generation."
                        color: Theme.colors.textMuted
                        font.pixelSize: Theme.typography.bodySmall
                        font.family: Theme.fontFamily
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                        Layout.topMargin: Theme.spacing.sm
                    }

                    Text {
                        text: "Built with Python, PySide6, and QML"
                        color: Theme.colors.textMuted
                        font.pixelSize: Theme.typography.caption
                        font.family: Theme.fontFamily
                        Layout.topMargin: Theme.spacing.sm
                    }
                }
            }
        }
    }
}
