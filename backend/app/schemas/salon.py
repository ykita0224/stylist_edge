from datetime import datetime
from pydantic import BaseModel


class SalonBase(BaseModel):
    name: str
    area: str
    address: str | None = None
    phone: str | None = None
    description: str | None = None


class SalonCreate(SalonBase):
    pass


class SalonUpdate(BaseModel):
    name: str | None = None
    area: str | None = None
    address: str | None = None
    phone: str | None = None
    description: str | None = None


class SalonResponse(SalonBase):
    id: int
    stylist_id: int
    created_at: datetime

    model_config = {"from_attributes": True}
