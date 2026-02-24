import enum
from datetime import datetime

from sqlalchemy import String, Integer, DateTime, Enum as SAEnum, ForeignKey, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.sql import func

from app.database import Base


class ApplicationStatus(str, enum.Enum):
    pending = "pending"      # 審査中
    approved = "approved"    # 承認
    rejected = "rejected"    # 不採用
    completed = "completed"  # 完了


class Application(Base):
    __tablename__ = "applications"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    job_id: Mapped[int] = mapped_column(Integer, ForeignKey("jobs.id"))
    model_id: Mapped[int] = mapped_column(Integer, ForeignKey("users.id"))
    status: Mapped[ApplicationStatus] = mapped_column(
        SAEnum(ApplicationStatus), default=ApplicationStatus.pending
    )
    message: Mapped[str | None] = mapped_column(Text, nullable=True)  # Model's message to stylist
    stylist_note: Mapped[str | None] = mapped_column(Text, nullable=True)  # Stylist's response note
    applied_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now()
    )

    # Relationships
    job: Mapped["Job"] = relationship("Job", back_populates="applications")
    model: Mapped["User"] = relationship("User", back_populates="applications")
