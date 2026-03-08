"""Database models using SQLAlchemy."""

from datetime import datetime
from typing import Optional

from sqlalchemy import create_engine, Column, String, DateTime, Text, JSON
from sqlalchemy.orm import declarative_base, sessionmaker, Session
from pathlib import Path

Base = declarative_base()


class Project(Base):
    """Project model for storing project data."""

    __tablename__ = "projects"

    id = Column(String, primary_key=True)
    title = Column(String(255), nullable=False)
    headline = Column(String(255), default="")
    client_name = Column(String(255), default="")
    start_date = Column(DateTime, nullable=True)
    deadline = Column(DateTime, nullable=True)
    status = Column(String(50), default="active")
    tags = Column(JSON, default=list)

    # New markdown fields
    details_markdown = Column(Text, default="")
    tasks_markdown = Column(Text, default="")

    created_at = Column(DateTime, default=datetime.now)
    updated_at = Column(DateTime, default=datetime.now, onupdate=datetime.now)

    def to_dict(self) -> dict:
        return {
            "id": self.id,
            "title": self.title,
            "headline": self.headline,
            "client_name": self.client_name,
            "start_date": self.start_date.isoformat()
            if self.start_date is not None
            else None,
            "deadline": self.deadline.isoformat()
            if self.deadline is not None
            else None,
            "status": self.status,
            "tags": self.tags or [],
            "details_markdown": self.details_markdown or "",
            "tasks_markdown": self.tasks_markdown or "",
            "created_at": self.created_at.isoformat()
            if self.created_at is not None
            else None,
            "updated_at": self.updated_at.isoformat()
            if self.updated_at is not None
            else None,
        }


class Database:
    """Database manager for SQLAlchemy."""

    _instance: Optional["Database"] = None

    def __init__(self) -> None:
        self.db_path = Path.home() / ".pomcraft" / "pomcraft.db"
        self.db_path.parent.mkdir(parents=True, exist_ok=True)
        self.engine = create_engine(f"sqlite:///{self.db_path}")
        Base.metadata.create_all(self.engine)
        self.SessionLocal = sessionmaker(bind=self.engine)

    @classmethod
    def get_instance(cls) -> "Database":
        if cls._instance is None:
            cls._instance = cls()
        return cls._instance

    def get_session(self) -> Session:
        return self.SessionLocal()
