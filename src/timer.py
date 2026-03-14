"""Pomodoro timer backend."""

import subprocess
from pathlib import Path
from typing import Optional

from PySide6.QtCore import QObject, QTimer, Signal, Slot, Property


class TimerBackend(QObject):
    """Manages Pomodoro timer state and logic."""

    # Standard signals
    sessionCompleted = Signal(str)
    stateChanged = Signal(str)

    # Property change signals
    timeRemainingChanged = Signal()
    isRunningChanged = Signal()
    sessionTypeChanged = Signal()
    completedSessionsChanged = Signal()

    def __init__(self, parent: Optional[QObject] = None) -> None:
        super().__init__(parent)
        self._work_duration = 25 * 60
        self._short_break_duration = 5 * 60
        self._long_break_duration = 15 * 60
        self._sessions_until_long_break = 4

        self._remaining_seconds = self._work_duration
        self._total_seconds = self._work_duration
        self._is_running = False
        self._current_session = "work"
        self._completed_sessions = 0

        self._timer = QTimer(self)
        self._timer.timeout.connect(self._tick)

    def _tick(self) -> None:
        if self._remaining_seconds > 0:
            self._remaining_seconds -= 1
            self.timeRemainingChanged.emit()
        else:
            self._complete_session()

    def _complete_session(self) -> None:
        self._timer.stop()
        self._is_running = False
        self.isRunningChanged.emit()
        self.stateChanged.emit("stopped")

        # Desktop Notification
        try:
            msg = (
                f"{self._current_session.replace('_', ' ').title()} session completed!"
            )
            subprocess.run(["notify-send", "PomCraft", msg], check=False)
        except Exception:
            pass

        if self._current_session == "work":
            self._completed_sessions += 1
            self.completedSessionsChanged.emit()
            self.sessionCompleted.emit("work")
            if self._completed_sessions % self._sessions_until_long_break == 0:
                self._switch_to_session("long_break")
            else:
                self._switch_to_session("short_break")
        else:
            self.sessionCompleted.emit(self._current_session)
            self._switch_to_session("work")

    def _switch_to_session(self, session_type: str) -> None:
        self._current_session = session_type
        self.sessionTypeChanged.emit()

        if session_type == "work":
            self._total_seconds = self._work_duration
        elif session_type == "short_break":
            self._total_seconds = self._short_break_duration
        else:
            self._total_seconds = self._long_break_duration

        self._remaining_seconds = self._total_seconds
        self.timeRemainingChanged.emit()

    @Slot()
    def start(self) -> None:
        if not self._is_running:
            self._is_running = True
            self._timer.start(1000)
            self.isRunningChanged.emit()
            self.stateChanged.emit("running")

    @Slot()
    def pause(self) -> None:
        if self._is_running:
            self._is_running = False
            self._timer.stop()
            self.isRunningChanged.emit()
            self.stateChanged.emit("paused")

    @Slot()
    def reset(self) -> None:
        self._timer.stop()
        self._is_running = False
        self.isRunningChanged.emit()

        # Reset to full duration of current session type
        if self._current_session == "work":
            self._total_seconds = self._work_duration
        elif self._current_session == "short_break":
            self._total_seconds = self._short_break_duration
        else:
            self._total_seconds = self._long_break_duration

        self._remaining_seconds = self._total_seconds
        self.timeRemainingChanged.emit()
        self.stateChanged.emit("stopped")

    @Slot()
    def skip(self) -> None:
        self._complete_session()

    # --- Properties for QML ---

    def get_time_remaining(self) -> int:
        return self._remaining_seconds

    def get_is_running(self) -> bool:
        return self._is_running

    def get_session_type(self) -> str:
        return self._current_session

    def get_completed_sessions(self) -> int:
        return self._completed_sessions

    @Slot(int)
    def setWorkDuration(self, minutes: int) -> None:
        self._work_duration = minutes * 60
        # If we are in work session and NOT running, update remaining time immediately
        if self._current_session == "work" and not self._is_running:
            self._total_seconds = self._work_duration
            self._remaining_seconds = self._total_seconds
            self.timeRemainingChanged.emit()

    @Slot(int)
    def setShortBreakDuration(self, minutes: int) -> None:
        self._short_break_duration = minutes * 60
        if self._current_session == "short_break" and not self._is_running:
            self._total_seconds = self._short_break_duration
            self._remaining_seconds = self._total_seconds
            self.timeRemainingChanged.emit()

    @Slot(int)
    def setLongBreakDuration(self, minutes: int) -> None:
        self._long_break_duration = minutes * 60
        if self._current_session == "long_break" and not self._is_running:
            self._total_seconds = self._long_break_duration
            self._remaining_seconds = self._total_seconds
            self.timeRemainingChanged.emit()

    timeRemaining = Property(int, get_time_remaining, notify=timeRemainingChanged)
    isRunning = Property(bool, get_is_running, notify=isRunningChanged)
    sessionType = Property(str, get_session_type, notify=sessionTypeChanged)
    completedSessions = Property(
        int, get_completed_sessions, notify=completedSessionsChanged
    )
