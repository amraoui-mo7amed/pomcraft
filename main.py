"""Pomcraft - Pomodoro timer with Markdown task support."""

import sys
from pathlib import Path

from PySide6.QtCore import QUrl
from PySide6.QtGui import QGuiApplication, QIcon
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtQuickControls2 import QQuickStyle

from src.backend import TimerBackend, TasksBackend, SettingsBackend


def main() -> int:
    app = QGuiApplication(sys.argv)
    app.setApplicationName("Pomcraft")
    app.setApplicationDisplayName("Pomcraft")
    app.setOrganizationName("Pomcraft")

    QQuickStyle.setStyle("Fusion")

    engine = QQmlApplicationEngine()
    engine.addImportPath(str(Path(__file__).parent / "resources" / "qml"))

    timer_backend = TimerBackend()
    tasks_backend = TasksBackend()
    settings_backend = SettingsBackend()

    timer_backend.setWorkDuration(settings_backend.getWorkDuration())
    timer_backend.setShortBreakDuration(settings_backend.getShortBreakDuration())
    timer_backend.setLongBreakDuration(settings_backend.getLongBreakDuration())

    engine.rootContext().setContextProperty("TimerBackend", timer_backend)
    engine.rootContext().setContextProperty("TasksBackend", tasks_backend)
    engine.rootContext().setContextProperty("SettingsBackend", settings_backend)

    qml_file = Path(__file__).parent / "resources" / "qml" / "Main.qml"
    engine.load(QUrl.fromLocalFile(qml_file))

    if not engine.rootObjects():
        return 1

    return app.exec()


if __name__ == "__main__":
    main()
