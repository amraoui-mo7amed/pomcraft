"""Tasks management backend."""

import json
from dataclasses import asdict, dataclass
from datetime import datetime
from pathlib import Path
from typing import Any, Optional

from PySide6.QtCore import QObject, Signal, Slot, Property


@dataclass
class Task:
    id: str
    title: str
    description: str
    completed: bool
    created_at: str
    pomodoros_completed: int

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> "Task":
        return cls(**data)


class TasksBackend(QObject):
    """Manages tasks storage and operations."""

    tasksChanged = Signal()
    taskAdded = Signal(str)
    taskCompleted = Signal(str)
    taskDeleted = Signal(str)
    errorOccurred = Signal(str)

    def __init__(self, parent: Optional[QObject] = None) -> None:
        super().__init__(parent)
        self._tasks: list[Task] = []
        self._data_file = Path.home() / ".pomcraft" / "tasks.json"
        self._load_tasks()

    def _load_tasks(self) -> None:
        if self._data_file.exists():
            try:
                with open(self._data_file, "r") as f:
                    data = json.load(f)
                    self._tasks = [Task.from_dict(t) for t in data]
            except (json.JSONDecodeError, KeyError):
                self._tasks = []

    def _save_tasks(self) -> None:
        self._data_file.parent.mkdir(parents=True, exist_ok=True)
        with open(self._data_file, "w") as f:
            json.dump([t.to_dict() for t in self._tasks], f, indent=2)

    @Slot(str, str)
    def addTask(self, title: str, description: str = "") -> None:
        task_id = datetime.now().strftime("%Y%m%d%H%M%S%f")
        task = Task(
            id=task_id,
            title=title,
            description=description,
            completed=False,
            created_at=datetime.now().isoformat(),
            pomodoros_completed=0,
        )
        self._tasks.insert(0, task)
        self._save_tasks()
        self.tasksChanged.emit()
        self.taskAdded.emit(task_id)

    @Slot(str)
    def toggleTask(self, task_id: str) -> None:
        for task in self._tasks:
            if task.id == task_id:
                task.completed = not task.completed
                self._save_tasks()
                self.tasksChanged.emit()
                if task.completed:
                    self.taskCompleted.emit(task_id)
                break

    @Slot(str)
    def deleteTask(self, task_id: str) -> None:
        self._tasks = [t for t in self._tasks if t.id != task_id]
        self._save_tasks()
        self.tasksChanged.emit()
        self.taskDeleted.emit(task_id)

    @Slot(str)
    def incrementPomodoro(self, task_id: str) -> None:
        for task in self._tasks:
            if task.id == task_id:
                task.pomodoros_completed += 1
                self._save_tasks()
                self.tasksChanged.emit()
                break

    @Slot(result="QVariantList")
    def getTasks(self) -> list[dict[str, Any]]:
        return [t.to_dict() for t in self._tasks]

    @Slot(result=int)
    def getTaskCount(self) -> int:
        return len(self._tasks)

    @Slot(result=int)
    def getCompletedCount(self) -> int:
        return sum(1 for t in self._tasks if t.completed)

    @Slot(str, str, str)
    def updateTask(self, task_id: str, title: str, description: str) -> None:
        for task in self._tasks:
            if task.id == task_id:
                task.title = title
                task.description = description
                self._save_tasks()
                self.tasksChanged.emit()
                break

    @Slot("QVariantList")
    def setTasksFromAI(self, tasks_data: list[dict[str, Any]]) -> None:
        for task_data in tasks_data:
            self.addTask(
                title=task_data.get("title", ""),
                description=task_data.get("description", ""),
            )
