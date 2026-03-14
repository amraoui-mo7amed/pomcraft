"""Project-specific tasks management."""

import json
from dataclasses import asdict, dataclass
from datetime import datetime
from pathlib import Path
from typing import Any, Optional

from PySide6.QtCore import QObject, Signal, Slot, Property


@dataclass
class ProjectTask:
    id: str
    project_id: str
    title: str
    completed: bool
    created_at: str

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> "ProjectTask":
        return cls(**data)


class ProjectTasksBackend(QObject):
    """Manages project-specific tasks."""

    projectTasksChanged = Signal(str)  # project_id

    def __init__(self, parent: Optional[QObject] = None) -> None:
        super().__init__(parent)
        self._tasks: list[ProjectTask] = []
        self._data_file = Path.home() / ".pomcraft" / "project_tasks.json"
        self._load_tasks()

    def _load_tasks(self) -> None:
        if self._data_file.exists():
            try:
                with open(self._data_file, "r") as f:
                    data = json.load(f)
                    self._tasks = [ProjectTask.from_dict(t) for t in data]
            except (json.JSONDecodeError, KeyError):
                self._tasks = []

    def _save_tasks(self) -> None:
        self._data_file.parent.mkdir(parents=True, exist_ok=True)
        with open(self._data_file, "w") as f:
            json.dump([t.to_dict() for t in self._tasks], f, indent=2)

    @Slot(str, str)
    def addTask(self, project_id: str, title: str) -> None:
        task_id = f"{project_id}_{datetime.now().strftime('%Y%m%d%H%M%S%f')}"
        task = ProjectTask(
            id=task_id,
            project_id=project_id,
            title=title,
            completed=False,
            created_at=datetime.now().isoformat(),
        )
        self._tasks.insert(0, task)
        self._save_tasks()
        self.projectTasksChanged.emit(project_id)

    @Slot(str)
    def toggleTask(self, task_id: str) -> None:
        for task in self._tasks:
            if task.id == task_id:
                task.completed = not task.completed
                self._save_tasks()
                self.projectTasksChanged.emit(task.project_id)
                break

    @Slot(str)
    def deleteTask(self, task_id: str) -> None:
        task = next((t for t in self._tasks if t.id == task_id), None)
        if task:
            project_id = task.project_id
            self._tasks = [t for t in self._tasks if t.id != task_id]
            self._save_tasks()
            self.projectTasksChanged.emit(project_id)

    @Slot(str, result="QVariantList")
    def getProjectTasks(self, project_id: str) -> list[dict[str, Any]]:
        tasks = [t.to_dict() for t in self._tasks if t.project_id == project_id]
        return tasks

    @Slot(str, result=int)
    def getProjectTaskCount(self, project_id: str) -> int:
        return sum(1 for t in self._tasks if t.project_id == project_id)

    @Slot(str, result=int)
    def getCompletedTaskCount(self, project_id: str) -> int:
        return sum(1 for t in self._tasks if t.project_id == project_id and t.completed)
