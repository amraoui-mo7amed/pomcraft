"""Settings management backend."""

import json
from pathlib import Path
from typing import Any, Optional

from PySide6.QtCore import QObject, Signal, Slot, Property


class SettingsBackend(QObject):
    """Manages application settings."""

    settingsChanged = Signal()
    apiKeyChanged = Signal(str)

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

    @Slot(result=int)
    def getWorkDuration(self) -> int:
        return self._settings.get("work_duration", 25)

    @Slot(int)
    def setWorkDuration(self, minutes: int) -> None:
        self._settings["work_duration"] = minutes
        self._save_settings()
        self.settingsChanged.emit()

    @Slot(result=int)
    def getShortBreakDuration(self) -> int:
        return self._settings.get("short_break_duration", 5)

    @Slot(int)
    def setShortBreakDuration(self, minutes: int) -> None:
        self._settings["short_break_duration"] = minutes
        self._save_settings()
        self.settingsChanged.emit()

    @Slot(result=int)
    def getLongBreakDuration(self) -> int:
        return self._settings.get("long_break_duration", 15)

    @Slot(int)
    def setLongBreakDuration(self, minutes: int) -> None:
        self._settings["long_break_duration"] = minutes
        self._save_settings()
        self.settingsChanged.emit()

    @Slot(result=str)
    def getApiKey(self) -> str:
        return self._settings.get("gemini_api_key", "")

    @Slot(str)
    def setApiKey(self, key: str) -> None:
        self._settings["gemini_api_key"] = key
        self._save_settings()
        self.apiKeyChanged.emit(key)

    @Slot(result=bool)
    def getAutoStartBreaks(self) -> bool:
        return self._settings.get("auto_start_breaks", False)

    @Slot(bool)
    def setAutoStartBreaks(self, enabled: bool) -> None:
        self._settings["auto_start_breaks"] = enabled
        self._save_settings()
        self.settingsChanged.emit()

    @Slot(result=bool)
    def getNotificationSound(self) -> bool:
        return self._settings.get("notification_sound", True)

    @Slot(bool)
    def setNotificationSound(self, enabled: bool) -> None:
        self._settings["notification_sound"] = enabled
        self._save_settings()
        self.settingsChanged.emit()

    @Slot(result=str)
    def getTheme(self) -> str:
        return self._settings.get("theme", "dark")

    @Slot(str)
    def setTheme(self, theme: str) -> None:
        self._settings["theme"] = theme
        self._save_settings()
        self.settingsChanged.emit()
