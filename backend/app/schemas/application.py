from datetime import datetime
from pydantic import BaseModel

from app.models.application import ApplicationStatus
from app.models.job import ModelType, PriceType, JobStatus
from app.schemas.hair_info import HairInfoResponse


class ApplicationCreate(BaseModel):
    message: str | None = None


class ApplicationStatusUpdate(BaseModel):
    status: ApplicationStatus
    stylist_note: str | None = None


class JobSummary(BaseModel):
    id: int
    menu: str
    area: str
    job_date: datetime
    start_time: str
    end_time: str
    model_type: ModelType | None = None
    price: int
    price_type: PriceType
    status: JobStatus

    model_config = {"from_attributes": True}


class SalonInfo(BaseModel):
    id: int
    name: str
    area: str
    phone: str | None = None

    model_config = {"from_attributes": True}


class ModelSummary(BaseModel):
    id: int
    name: str
    email: str
    phone: str | None = None
    hair_info: HairInfoResponse | None = None

    model_config = {"from_attributes": True}


class ApplicationResponse(BaseModel):
    id: int
    job_id: int
    model_id: int
    status: ApplicationStatus
    message: str | None = None
    stylist_note: str | None = None
    applied_at: datetime
    updated_at: datetime
    job: JobSummary | None = None
    salon: SalonInfo | None = None

    model_config = {"from_attributes": True}


class ApplicantResponse(BaseModel):
    id: int
    status: ApplicationStatus
    message: str | None = None
    stylist_note: str | None = None
    applied_at: datetime
    model: ModelSummary

    model_config = {"from_attributes": True}
