from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.auth import get_current_user
from app.database import get_db
from app.models.user import User
from app.models.hair_info import HairInfo
from app.schemas.user import UserResponse, UserUpdate
from app.schemas.hair_info import HairInfoResponse, HairInfoCreate, HairInfoUpdate

router = APIRouter(prefix="/users", tags=["users"])


@router.get("/me", response_model=UserResponse)
async def get_me(current_user: User = Depends(get_current_user)):
    return current_user


@router.put("/me", response_model=UserResponse)
async def update_me(
    payload: UserUpdate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    for field, value in payload.model_dump(exclude_none=True).items():
        setattr(current_user, field, value)
    await db.commit()
    await db.refresh(current_user)
    return current_user


@router.get("/me/hair-info", response_model=HairInfoResponse)
async def get_hair_info(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(select(HairInfo).where(HairInfo.user_id == current_user.id))
    hair_info = result.scalar_one_or_none()
    if not hair_info:
        raise HTTPException(status_code=404, detail="Hair info not found")
    return hair_info


@router.put("/me/hair-info", response_model=HairInfoResponse)
async def upsert_hair_info(
    payload: HairInfoCreate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(select(HairInfo).where(HairInfo.user_id == current_user.id))
    hair_info = result.scalar_one_or_none()

    if hair_info:
        for field, value in payload.model_dump(exclude_none=True).items():
            setattr(hair_info, field, value)
    else:
        hair_info = HairInfo(user_id=current_user.id, **payload.model_dump())
        db.add(hair_info)

    await db.commit()
    await db.refresh(hair_info)
    return hair_info
