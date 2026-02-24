import enum
from datetime import datetime

from sqlalchemy import String, Integer, DateTime, Enum as SAEnum, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.sql import func

from app.database import Base


class HairType(str, enum.Enum):
    normal = "normal"      # 普通毛
    fine = "fine"          # 軟毛
    thick = "thick"        # 硬毛
    curly = "curly"        # 癖毛


class HairLength(str, enum.Enum):
    short = "short"        # ショート
    medium = "medium"      # ミディアム
    long = "long"          # ロング
    very_long = "very_long"  # スーパーロング


class BleachHistory(str, enum.Enum):
    none = "none"           # なし
    once = "once"           # 1回
    multiple = "multiple"   # 複数回


class StraightHistory(str, enum.Enum):
    none = "none"                   # なし
    within_one_year = "within_one_year"  # 1年以内
    over_one_year = "over_one_year"      # 1年以上前


class HairInfo(Base):
    __tablename__ = "hair_info"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    user_id: Mapped[int] = mapped_column(Integer, ForeignKey("users.id"), unique=True)
    hair_type: Mapped[HairType | None] = mapped_column(SAEnum(HairType), nullable=True)
    hair_length: Mapped[HairLength | None] = mapped_column(SAEnum(HairLength), nullable=True)
    bleach_history: Mapped[BleachHistory | None] = mapped_column(SAEnum(BleachHistory), nullable=True)
    straight_history: Mapped[StraightHistory | None] = mapped_column(SAEnum(StraightHistory), nullable=True)
    notes: Mapped[str | None] = mapped_column(String(500), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now()
    )

    # Relationships
    user: Mapped["User"] = relationship("User", back_populates="hair_info")
