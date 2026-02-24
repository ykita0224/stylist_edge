from datetime import datetime
from pydantic import BaseModel

from app.models.hair_info import HairType, HairLength, BleachHistory, StraightHistory


class HairInfoBase(BaseModel):
    hair_type: HairType | None = None
    hair_length: HairLength | None = None
    bleach_history: BleachHistory | None = None
    straight_history: StraightHistory | None = None
    notes: str | None = None


class HairInfoCreate(HairInfoBase):
    pass


class HairInfoUpdate(HairInfoBase):
    pass


class HairInfoResponse(HairInfoBase):
    id: int
    user_id: int
    updated_at: datetime

    model_config = {"from_attributes": True}
