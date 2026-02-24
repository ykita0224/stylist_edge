import enum
from datetime import datetime, date, time

from sqlalchemy import String, Integer, Date, Time, DateTime, Enum as SAEnum, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.sql import func

from app.database import Base


class JobStatus(str, enum.Enum):
    open = "open"          # 募集中
    closed = "closed"      # 募集完了
    completed = "completed"  # 締切決定


class ModelType(str, enum.Enum):
    trainee = "trainee"     # 研修生用
    experienced = "experienced"  # 実績用


class PriceType(str, enum.Enum):
    income = "income"      # 収入 (model gets paid)
    deduction = "deduction"  # 天引き (model pays discounted price)


class Job(Base):
    __tablename__ = "jobs"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    salon_id: Mapped[int] = mapped_column(Integer, ForeignKey("salons.id"))
    menu: Mapped[str] = mapped_column(String(200))       # e.g. フリーカット, カラーモデル
    area: Mapped[str] = mapped_column(String(100))        # e.g. 渋谷区
    job_date: Mapped[date] = mapped_column(Date)
    start_time: Mapped[time] = mapped_column(Time)
    end_time: Mapped[time] = mapped_column(Time)
    model_type: Mapped[ModelType | None] = mapped_column(SAEnum(ModelType), nullable=True)
    price: Mapped[int] = mapped_column(Integer, default=0)  # Amount in yen
    price_type: Mapped[PriceType] = mapped_column(SAEnum(PriceType), default=PriceType.income)
    description: Mapped[str | None] = mapped_column(String(1000), nullable=True)
    status: Mapped[JobStatus] = mapped_column(SAEnum(JobStatus), default=JobStatus.open)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now()
    )

    # Relationships
    salon: Mapped["Salon"] = relationship("Salon", back_populates="jobs")
    applications: Mapped[list["Application"]] = relationship("Application", back_populates="job")
