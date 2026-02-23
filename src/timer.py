"""Pomodoro timer backend."""

from pathlib import Path
from typing import Optional

from PySide6.QtCore import QObject, QTimer, Signal, Slot, Property


class TimerBackend(QObject):
    """Manages Pomodoro timer state and logic."""

    timeChanged = Signal(str)
    progressChanged = Signal(float)
    sessionChanged = Signal(str)
    sessionCompleted = Signal(str)
    stateChanged = Signal(str)

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
            self._update_display()
        else:
            self._complete_session()

    def _update_display(self) -> None:
        minutes = self._remaining_seconds // 60
        seconds = self._remaining_seconds % 60
        self.timeChanged.emit(f"{minutes:02d}:{seconds:02d}")
        progress = 1.0 - (self._remaining_seconds / self._total_seconds)
        self.progressChanged.emit(progress)

    def _complete_session(self) -> None:
        self._timer.stop()
        self._is_running = False
        self.stateChanged.emit("stopped")

        if self._current_session == "work":
            self._completed_sessions += 1
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
        self.sessionChanged.emit(session_type)

        if session_type == "work":
            self._total_seconds = self._work_duration
        elif session_type == "short_break":
            self._total_seconds = self._short_break_duration
        else:
            self._total_seconds = self._long_break_duration

        self._remaining_seconds = self._total_seconds
        self._update_display()

    @Slot()
    def start(self) -> None:
        if not self._is_running:
            self._is_running = True
            self._timer.start(1000)
            self.stateChanged.emit("running")

    @Slot()
    def pause(self) -> None:
        if self._is_running:
            self._is_running = False
            self._timer.stop()
            self.stateChanged.emit("paused")

    @Slot()
    def reset(self) -> None:
        self._timer.stop()
        self._is_running = False
        self._remaining_seconds = self._total_seconds
        self._update_display()
        self.stateChanged.emit("stopped")

    @Slot()
    def skip(self) -> None:
        self._complete_session()

    @Slot(result=str)
    def getTime(self) -> str:
        minutes = self._remaining_seconds // 60
        seconds = self._remaining_seconds % 60
        return f"{minutes:02d}:{seconds:02d}"

    @Slot(result=float)
    def getProgress(self) -> float:
        return 1.0 - (self._remaining_seconds / self._total_seconds)

    @Slot(result=str)
    def getSession(self) -> str:
        return self._current_session

    @Slot(result=str)
    def getState(self) -> str:
        if self._is_running:
            return "running"
        return "paused" if self._remaining_seconds < self._total_seconds else "stopped"

    @Slot(result=int)
    def getCompletedSessions(self) -> int:
        return self._completed_sessions

    @Slot(int)
    def setWorkDuration(self, minutes: int) -> None:
        self._work_duration = minutes * 60
        if self._current_session == "work" and not self._is_running:
            self._total_seconds = self._work_duration
            self._remaining_seconds = self._total_seconds
            self._update_display()

    @Slot(int)
    def setShortBreakDuration(self, minutes: int) -> None:
        self._short_break_duration = minutes * 60

    @Slot(int)
    def setLongBreakDuration(self, minutes: int) -> None:
        self._long_break_duration = minutes * 60
