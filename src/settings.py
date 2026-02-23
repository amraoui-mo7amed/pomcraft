"""Settings management backend."""

import json
from pathlib import Path
from typing import Any, Optional

from PySide6.QtCore import QObject, Signal, Slot, Property


class SettingsBackend(QObject):
    """Manages application settings."""

    settingsChanged = Signal()
    workDurationChanged = Signal()
    shortBreakDurationChanged = Signal()
    longBreakDurationChanged = Signal()
    apiKeyChanged = Signal(str)
    autoStartBreaksChanged = Signal()
    notificationSoundChanged = Signal()
    themeChanged = Signal()

    def __init__(self, parent: Optional[QObject] = None) -> None:
        super().__init__(parent)
        self._settings: dict[str, Any] = {}
        self._settings_file = Path.home() / ".pomcraft" / "settings.json"
        self._load_settings()

    def _load_settings(self) -> None:
        if self._settings_file.exists():
            try:
                with open(self._settings_file, "r") as f:
                    self._settings = json.load(f)
            except json.JSONDecodeError:
                self._settings = self._default_settings()
        else:
            self._settings = self._default_settings()

    def _default_settings(self) -> dict[str, Any]:
        return {
            "work_duration": 25,
            "short_break_duration": 5,
            "long_break_duration": 15,
            "sessions_until_long_break": 4,
            "auto_start_breaks": False,
            "auto_start_pomodoros": False,
            "notification_sound": True,
            "gemini_api_key": "",
            "theme": "dark",
        }

    def _save_settings(self) -> None:
        self._settings_file.parent.mkdir(parents=True, exist_ok=True)
        with open(self._settings_file, "w") as f:
            json.dump(self._settings, f, indent=2)

    # Work Duration
    def get_work_duration(self) -> int:
        return self._settings.get("work_duration", 25)

    def set_work_duration(self, minutes: int) -> None:
        if self._settings.get("work_duration") != minutes:
            self._settings["work_duration"] = minutes
            self._save_settings()
            self.workDurationChanged.emit()
            self.settingsChanged.emit()

    workDuration = Property(
        int, get_work_duration, set_work_duration, notify=workDurationChanged
    )

    # Short Break Duration
    def get_short_break_duration(self) -> int:
        return self._settings.get("short_break_duration", 5)

    def set_short_break_duration(self, minutes: int) -> None:
        if self._settings.get("short_break_duration") != minutes:
            self._settings["short_break_duration"] = minutes
            self._save_settings()
            self.shortBreakDurationChanged.emit()
            self.settingsChanged.emit()

    shortBreakDuration = Property(
        int,
        get_short_break_duration,
        set_short_break_duration,
        notify=shortBreakDurationChanged,
    )

    # Long Break Duration
    def get_long_break_duration(self) -> int:
        return self._settings.get("long_break_duration", 15)

    def set_long_break_duration(self, minutes: int) -> None:
        if self._settings.get("long_break_duration") != minutes:
            self._settings["long_break_duration"] = minutes
            self._save_settings()
            self.longBreakDurationChanged.emit()
            self.settingsChanged.emit()

    longBreakDuration = Property(
        int,
        get_long_break_duration,
        set_long_break_duration,
        notify=longBreakDurationChanged,
    )

    # API Key
    def get_api_key(self) -> str:
        return self._settings.get("gemini_api_key", "")

    def set_api_key(self, key: str) -> None:
        if self._settings.get("gemini_api_key") != key:
            self._settings["gemini_api_key"] = key
            self._save_settings()
            self.apiKeyChanged.emit(key)

    apiKey = Property(str, get_api_key, set_api_key, notify=apiKeyChanged)

    # Auto Start Breaks
    def get_auto_start_breaks(self) -> bool:
        return self._settings.get("auto_start_breaks", False)

    def set_auto_start_breaks(self, enabled: bool) -> None:
        if self._settings.get("auto_start_breaks") != enabled:
            self._settings["auto_start_breaks"] = enabled
            self._save_settings()
            self.autoStartBreaksChanged.emit()
            self.settingsChanged.emit()

    autoStartBreaks = Property(
        bool,
        get_auto_start_breaks,
        set_auto_start_breaks,
        notify=autoStartBreaksChanged,
    )

    # Notification Sound
    def get_notification_sound(self) -> bool:
        return self._settings.get("notification_sound", True)

    def set_notification_sound(self, enabled: bool) -> None:
        if self._settings.get("notification_sound") != enabled:
            self._settings["notification_sound"] = enabled
            self._save_settings()
            self.notificationSoundChanged.emit()
            self.settingsChanged.emit()

    notificationSound = Property(
        bool,
        get_notification_sound,
        set_notification_sound,
        notify=notificationSoundChanged,
    )

    # Theme
    def get_theme(self) -> str:
        return self._settings.get("theme", "dark")

    def set_theme(self, theme: str) -> None:
        if self._settings.get("theme") != theme:
            self._settings["theme"] = theme
            self._save_settings()
            self.themeChanged.emit()
            self.settingsChanged.emit()

    theme = Property(str, get_theme, set_theme, notify=themeChanged)

    # Slots for backward compatibility
    @Slot(result=int)
    def getWorkDuration(self) -> int:
        return self.get_work_duration()

    @Slot(int)
    def setWorkDuration(self, v: int) -> None:
        self.set_work_duration(v)

    @Slot(result=int)
    def getShortBreakDuration(self) -> int:
        return self.get_short_break_duration()

    @Slot(int)
    def setShortBreakDuration(self, v: int) -> None:
        self.set_short_break_duration(v)

    @Slot(result=int)
    def getLongBreakDuration(self) -> int:
        return self.get_long_break_duration()

    @Slot(int)
    def setLongBreakDuration(self, v: int) -> None:
        self.set_long_break_duration(v)

    @Slot(result=str)
    def getApiKey(self) -> str:
        return self.get_api_key()

    @Slot(str)
    def setApiKey(self, v: str) -> None:
        self.set_api_key(v)

    @Slot(result=bool)
    def getAutoStartBreaks(self) -> bool:
        return self.get_auto_start_breaks()

    @Slot(bool)
    def setAutoStartBreaks(self, v: bool) -> None:
        self.set_auto_start_breaks(v)

    @Slot(result=bool)
    def getNotificationSound(self) -> bool:
        return self.get_notification_sound()

    @Slot(bool)
    def setNotificationSound(self, v: bool) -> None:
        self.set_notification_sound(v)

    @Slot(result=str)
    def getTheme(self) -> str:
        return self.get_theme()

    @Slot(str)
    def setTheme(self, v: str) -> None:
        self.set_theme(v)
