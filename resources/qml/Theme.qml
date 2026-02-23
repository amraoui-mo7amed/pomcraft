import QtQuick 2.15

pragma Singleton
import QtQuick 2.15

QtObject {
    readonly property string appName: "Pomcraft"

    readonly property string fontFamily: "Inter"

    readonly property var colors: QtObject {
        readonly property color primary: "#6366F1"
        readonly property color primaryHover: "#4F46E5"
        readonly property color primaryPressed: "#4338CA"

        readonly property color secondary: "#8B5CF6"
        readonly property color accent: "#EC4899"

        readonly property color background: "#0F0F23"
        readonly property color surface: "#1A1A2E"
        readonly property color surfaceHover: "#252542"
        readonly property color surfaceActive: "#2D2D4A"

        readonly property color card: "#16213E"
        readonly property color cardBorder: "#1E3A5F"

        readonly property color text: "#E2E8F0"
        readonly property color textSecondary: "#94A3B8"
        readonly property color textMuted: "#64748B"

        readonly property color success: "#10B981"
        readonly property color warning: "#F59E0B"
        readonly property color error: "#EF4444"
        readonly property color info: "#3B82F6"

        readonly property color work: "#6366F1"
        readonly property color shortBreak: "#10B981"
        readonly property color longBreak: "#8B5CF6"

        readonly property color divider: "#14FFFFFF"
    }

    readonly property var spacing: QtObject {
        readonly property int xs: 4
        readonly property int sm: 8
        readonly property int md: 16
        readonly property int lg: 24
        readonly property int xl: 32
        readonly property int xxl: 48
    }

    readonly property var radius: QtObject {
        readonly property int sm: 6
        readonly property int md: 12
        readonly property int lg: 16
        readonly property int xl: 24
        readonly property int full: 9999
    }

    readonly property var typography: QtObject {
        readonly property int h1: 48
        readonly property int h2: 36
        readonly property int h3: 28
        readonly property int h4: 24
        readonly property int body: 16
        readonly property int bodySmall: 14
        readonly property int caption: 12
        readonly property int tiny: 10
    }

    readonly property var animation: QtObject {
        readonly property int fast: 150
        readonly property int normal: 250
        readonly property int slow: 400
        readonly property string easing: "easeOutCubic"
    }

    function formatTime(seconds) {
        const mins = Math.floor(seconds / 60)
        const secs = seconds % 60
        return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`
    }

    function getSessionColor(session) {
        switch (session) {
            case "work": return colors.work
            case "short_break": return colors.shortBreak
            case "long_break": return colors.longBreak
            default: return colors.primary
        }
    }

    function getSessionLabel(session) {
        switch (session) {
            case "work": return "Focus"
            case "short_break": return "Short Break"
            case "long_break": return "Long Break"
            default: return "Focus"
        }
    }
}
