from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.auth import get_current_user
from app.database import get_db
from app.models.user import User, UserRole
from app.models.salon import Salon
from app.schemas.salon import SalonCreate, SalonUpdate, SalonResponse

router = APIRouter(prefix="/salons", tags=["salons"])


def require_stylist(current_user: User = Depends(get_current_user)) -> User:
    if current_user.role != UserRole.stylist:
        raise HTTPException(status_code=403, detail="Only stylists can manage salons")
    return current_user


@router.get("/me", response_model=SalonResponse)
async def get_my_salon(
    current_user: User = Depends(require_stylist),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(select(Salon).where(Salon.stylist_id == current_user.id))
    salon = result.scalar_one_or_none()
    if not salon:
        raise HTTPException(status_code=404, detail="Salon not found")
    return salon


@router.post("/me", response_model=SalonResponse, status_code=status.HTTP_201_CREATED)
async def create_salon(
    payload: SalonCreate,
    current_user: User = Depends(require_stylist),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(select(Salon).where(Salon.stylist_id == current_user.id))
    if result.scalar_one_or_none():
        raise HTTPException(status_code=400, detail="Salon already exists for this stylist")

    salon = Salon(stylist_id=current_user.id, **payload.model_dump())
    db.add(salon)
    await db.commit()
    await db.refresh(salon)
    return salon


@router.put("/me", response_model=SalonResponse)
async def update_salon(
    payload: SalonUpdate,
    current_user: User = Depends(require_stylist),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(select(Salon).where(Salon.stylist_id == current_user.id))
    salon = result.scalar_one_or_none()
    if not salon:
        raise HTTPException(status_code=404, detail="Salon not found")

    for field, value in payload.model_dump(exclude_none=True).items():
        setattr(salon, field, value)
    await db.commit()
    await db.refresh(salon)
    return salon


@router.get("/{salon_id}", response_model=SalonResponse)
async def get_salon(salon_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Salon).where(Salon.id == salon_id))
    salon = result.scalar_one_or_none()
    if not salon:
        raise HTTPException(status_code=404, detail="Salon not found")
    return salon
