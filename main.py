import sys
import os
from pathlib import Path

from PySide6.QtCore import QUrl, QObject, Slot
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtQuickControls2 import QQuickStyle

from src.backend import TimerBackend, TasksBackend, SettingsBackend, ProjectsBackend
from src.project_tasks import ProjectTasksBackend
from src.highlighter import MarkdownHighlighter
from src.markdown_renderer import MarkdownRenderer


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
    projects_backend = ProjectsBackend()
    project_tasks_backend = ProjectTasksBackend()
    markdown_renderer = MarkdownRenderer()

    # Initial sync
    timer_backend.setWorkDuration(settings_backend.workDuration)
    timer_backend.setShortBreakDuration(settings_backend.shortBreakDuration)
    timer_backend.setLongBreakDuration(settings_backend.longBreakDuration)

    # Reactive sync
    settings_backend.workDurationChanged.connect(
        lambda: timer_backend.setWorkDuration(settings_backend.workDuration)
    )
    settings_backend.shortBreakDurationChanged.connect(
        lambda: timer_backend.setShortBreakDuration(settings_backend.shortBreakDuration)
    )
    settings_backend.longBreakDurationChanged.connect(
        lambda: timer_backend.setLongBreakDuration(settings_backend.longBreakDuration)
    )

    engine.rootContext().setContextProperty("TimerBackend", timer_backend)
    engine.rootContext().setContextProperty("TasksBackend", tasks_backend)
    engine.rootContext().setContextProperty("SettingsBackend", settings_backend)
    engine.rootContext().setContextProperty("ProjectsBackend", projects_backend)
    engine.rootContext().setContextProperty(
        "ProjectTasksBackend", project_tasks_backend
    )
    engine.rootContext().setContextProperty("MarkdownRenderer", markdown_renderer)

    class HighlighterBridge(QObject):
        def __init__(self):
            super().__init__()
            self._highlighters = []

        @Slot(QObject)
        def apply(self, text_area):
            if not text_area:
                return
            quick_doc = text_area.property("textDocument")
            if quick_doc:
                doc = quick_doc.textDocument()
                highlighter = MarkdownHighlighter(doc)
                self._highlighters.append(highlighter)

    class ClipboardHelper(QObject):
        @Slot(str)
        def setText(self, text):
            QGuiApplication.clipboard().setText(text)

    bridge = HighlighterBridge()
    clipboard = ClipboardHelper()

    engine.rootContext().setContextProperty("Highlighter", bridge)
    engine.rootContext().setContextProperty("Clipboard", clipboard)

    qml_file = Path(__file__).parent / "resources" / "qml" / "Main.qml"
    engine.load(QUrl.fromLocalFile(qml_file))

    if not engine.rootObjects():
        return 1

    return app.exec()


if __name__ == "__main__":
    main()
