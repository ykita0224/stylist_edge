from datetime import datetime, date, time
from pydantic import BaseModel

from app.models.job import JobStatus, ModelType, PriceType


class JobBase(BaseModel):
    menu: str
    area: str
    job_date: date
    start_time: time
    end_time: time
    model_type: ModelType | None = None
    price: int = 0
    price_type: PriceType = PriceType.income
    description: str | None = None


class JobCreate(JobBase):
    pass


class JobUpdate(BaseModel):
    menu: str | None = None
    area: str | None = None
    job_date: date | None = None
    start_time: time | None = None
    end_time: time | None = None
    model_type: ModelType | None = None
    price: int | None = None
    price_type: PriceType | None = None
    description: str | None = None
    status: JobStatus | None = None


class SalonSummary(BaseModel):
    id: int
    name: str
    area: str
    phone: str | None = None

    model_config = {"from_attributes": True}


class JobResponse(JobBase):
    id: int
    salon_id: int
    status: JobStatus
    created_at: datetime
    salon: SalonSummary
    applicant_count: int = 0

    model_config = {"from_attributes": True}


class JobListResponse(BaseModel):
    total: int
    jobs: list[JobResponse]


class StylistDashboardStats(BaseModel):
    open_count: int       # 募集中
    closed_count: int     # 募集完了
    completed_count: int  # 締切決定
