"""Projects management backend."""

import uuid
from datetime import datetime
from typing import Any, Optional

from PySide6.QtCore import QObject, Signal, Slot, Property

from .database import Database, Project


class ProjectsBackend(QObject):
    """Manages projects storage and operations."""

    projectsChanged = Signal()
    projectAdded = Signal(str)
    projectUpdated = Signal(str)
    projectDeleted = Signal(str)
    errorOccurred = Signal(str)

    def __init__(self, parent: Optional[QObject] = None) -> None:
        super().__init__(parent)
        self._db = Database.get_instance()

    @Slot(result="QVariantList")
    def getProjects(self) -> list[dict[str, Any]]:
        """Get all projects."""
        session = self._db.get_session()
        try:
            projects = session.query(Project).order_by(Project.updated_at.desc()).all()
            return [p.to_dict() for p in projects]
        finally:
            session.close()

    @Slot(str, result="QVariant")
    def getProject(self, project_id: str) -> dict[str, Any]:
        """Get a single project by ID."""
        session = self._db.get_session()
        try:
            project = session.query(Project).filter(Project.id == project_id).first()
            return project.to_dict() if project else {}
        finally:
            session.close()

    @Slot(str, str, str, str, str, str, "QVariantList")
    def createProject(
        self,
        title: str,
        headline: str = "",
        client_name: str = "",
        start_date: str = "",
        deadline: str = "",
        status: str = "active",
        tags: Optional[list[str]] = None,
    ) -> str:
        """Create a new project."""
        session = self._db.get_session()
        try:
            project = Project(
                id=str(uuid.uuid4()),
                title=title,  # type: ignore
                headline=headline,  # type: ignore
                client_name=client_name,  # type: ignore
                start_date=datetime.fromisoformat(start_date) if start_date else None,  # type: ignore
                deadline=datetime.fromisoformat(deadline) if deadline else None,  # type: ignore
                status=status,  # type: ignore
                tags=tags or [],  # type: ignore
                details_markdown="",  # type: ignore
                tasks_markdown="",  # type: ignore
            )
            session.add(project)
            session.commit()
            self.projectsChanged.emit()
            self.projectAdded.emit(project.id)  # type: ignore
            return project.id  # type: ignore
        except Exception as e:
            session.rollback()
            self.errorOccurred.emit(str(e))
            return ""
        finally:
            session.close()

    @Slot(str, str, str, str, str, str, str, "QVariantList")
    def updateProject(
        self,
        project_id: str,
        title: str,
        headline: str,
        client_name: str,
        start_date: str,
        deadline: str,
        status: str,
        tags: list[str],
    ) -> bool:
        """Update an existing project's metadata."""
        session = self._db.get_session()
        try:
            project = session.query(Project).filter(Project.id == project_id).first()
            if project:
                project.title = title  # type: ignore
                project.headline = headline  # type: ignore
                project.client_name = client_name  # type: ignore
                project.start_date = (  # type: ignore
                    datetime.fromisoformat(start_date) if start_date else None
                )
                project.deadline = (  # type: ignore
                    datetime.fromisoformat(deadline) if deadline else None
                )
                project.status = status  # type: ignore
                project.tags = tags or []  # type: ignore
                session.commit()
                self.projectsChanged.emit()
                self.projectUpdated.emit(project_id)
                return True
            return False
        except Exception as e:
            session.rollback()
            self.errorOccurred.emit(str(e))
            return False
        finally:
            session.close()

    @Slot(str, str, str, result=bool)
    def updateProjectMarkdown(self, project_id: str, field: str, content: str) -> bool:
        """Update either details_markdown or tasks_markdown."""
        session = self._db.get_session()
        try:
            project = session.query(Project).filter(Project.id == project_id).first()
            if project:
                if field == "details":
                    project.details_markdown = content  # type: ignore
                elif field == "tasks":
                    project.tasks_markdown = content  # type: ignore
                session.commit()
                # Don't emit projectsChanged for every keystroke to avoid UI lag,
                # but emit specific update signal
                self.projectUpdated.emit(project_id)
                return True
            return False
        except Exception as e:
            session.rollback()
            return False
        finally:
            session.close()

    @Slot(str, result=bool)
    def deleteProject(self, project_id: str) -> bool:
        """Delete a project."""
        session = self._db.get_session()
        try:
            project = session.query(Project).filter(Project.id == project_id).first()
            if project:
                session.delete(project)
                session.commit()
                self.projectsChanged.emit()
                self.projectDeleted.emit(project_id)
                return True
            return False
        except Exception as e:
            session.rollback()
            self.errorOccurred.emit(str(e))
            return False
        finally:
            session.close()

    @Slot(result=int)
    def getProjectCount(self) -> int:
        """Get total project count."""
        session = self._db.get_session()
        try:
            return session.query(Project).count()
        finally:
            session.close()

    def _get_total_count(self) -> int:
        return self.getProjectCount()

    totalCount = Property(int, _get_total_count, notify=projectsChanged)

    @Slot(str, result=int)
    def getProjectCountByStatus(self, status: str) -> int:
        """Get project count by status."""
        session = self._db.get_session()
        try:
            return session.query(Project).filter(Project.status == status).count()
        finally:
            session.close()

    def _get_active_count(self) -> int:
        return self.getProjectCountByStatus("active")

    activeCount = Property(int, _get_active_count, notify=projectsChanged)

    def _get_completed_count(self) -> int:
        return self.getProjectCountByStatus("completed")

    completedCount = Property(int, _get_completed_count, notify=projectsChanged)

    @Slot(result="QVariantList")
    def getActiveProjects(self) -> list[dict[str, Any]]:
        """Get all active projects."""
        session = self._db.get_session()
        try:
            projects = (
                session.query(Project)
                .filter(Project.status == "active")
                .order_by(Project.updated_at.desc())
                .all()
            )
            return [p.to_dict() for p in projects]
        finally:
            session.close()
