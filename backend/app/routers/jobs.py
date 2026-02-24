from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from sqlalchemy.orm import selectinload

from app.auth import get_current_user
from app.database import get_db
from app.models.user import User, UserRole
from app.models.salon import Salon
from app.models.job import Job, JobStatus
from app.models.application import Application
from app.schemas.job import JobCreate, JobUpdate, JobResponse, JobListResponse, StylistDashboardStats

router = APIRouter(prefix="/jobs", tags=["jobs"])


def require_stylist(current_user: User = Depends(get_current_user)) -> User:
    if current_user.role != UserRole.stylist:
        raise HTTPException(status_code=403, detail="Only stylists can manage jobs")
    return current_user


async def _build_job_response(job: Job, db: AsyncSession) -> JobResponse:
    count_result = await db.execute(
        select(func.count()).where(Application.job_id == job.id)
    )
    applicant_count = count_result.scalar() or 0
    data = JobResponse.model_validate(job)
    data.applicant_count = applicant_count
    return data


@router.get("", response_model=JobListResponse)
async def list_jobs(
    area: str | None = Query(None),
    menu: str | None = Query(None),
    status: JobStatus | None = Query(None),
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=100),
    db: AsyncSession = Depends(get_db),
):
    """List all open jobs with optional filters (for models to browse)."""
    query = (
        select(Job)
        .options(selectinload(Job.salon))
        .where(Job.status == JobStatus.open)
        .order_by(Job.job_date.asc())
    )
    if area:
        query = query.where(Job.area == area)
    if menu:
        query = query.where(Job.menu.ilike(f"%{menu}%"))
    if status:
        query = query.where(Job.status == status)

    count_result = await db.execute(select(func.count()).select_from(query.subquery()))
    total = count_result.scalar() or 0

    result = await db.execute(query.offset(skip).limit(limit))
    jobs = result.scalars().all()

    job_responses = [await _build_job_response(job, db) for job in jobs]
    return JobListResponse(total=total, jobs=job_responses)


@router.get("/mine", response_model=JobListResponse)
async def list_my_jobs(
    status: JobStatus | None = Query(None),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_stylist),
):
    """Get the stylist's own job postings."""
    salon_result = await db.execute(select(Salon).where(Salon.stylist_id == current_user.id))
    salon = salon_result.scalar_one_or_none()
    if not salon:
        return JobListResponse(total=0, jobs=[])

    query = (
        select(Job)
        .options(selectinload(Job.salon))
        .where(Job.salon_id == salon.id)
        .order_by(Job.job_date.desc())
    )
    if status:
        query = query.where(Job.status == status)

    result = await db.execute(query)
    jobs = result.scalars().all()
    job_responses = [await _build_job_response(job, db) for job in jobs]
    return JobListResponse(total=len(job_responses), jobs=job_responses)


@router.get("/mine/stats", response_model=StylistDashboardStats)
async def get_dashboard_stats(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_stylist),
):
    """Get dashboard stats for the stylist."""
    salon_result = await db.execute(select(Salon).where(Salon.stylist_id == current_user.id))
    salon = salon_result.scalar_one_or_none()
    if not salon:
        return StylistDashboardStats(open_count=0, closed_count=0, completed_count=0)

    async def count_jobs(job_status: JobStatus) -> int:
        r = await db.execute(
            select(func.count()).where(Job.salon_id == salon.id, Job.status == job_status)
        )
        return r.scalar() or 0

    return StylistDashboardStats(
        open_count=await count_jobs(JobStatus.open),
        closed_count=await count_jobs(JobStatus.closed),
        completed_count=await count_jobs(JobStatus.completed),
    )


@router.get("/{job_id}", response_model=JobResponse)
async def get_job(job_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(Job).options(selectinload(Job.salon)).where(Job.id == job_id)
    )
    job = result.scalar_one_or_none()
    if not job:
        raise HTTPException(status_code=404, detail="Job not found")
    return await _build_job_response(job, db)


@router.post("", response_model=JobResponse, status_code=status.HTTP_201_CREATED)
async def create_job(
    payload: JobCreate,
    current_user: User = Depends(require_stylist),
    db: AsyncSession = Depends(get_db),
):
    salon_result = await db.execute(select(Salon).where(Salon.stylist_id == current_user.id))
    salon = salon_result.scalar_one_or_none()
    if not salon:
        raise HTTPException(status_code=400, detail="You must create a salon profile first")

    job = Job(salon_id=salon.id, **payload.model_dump())
    db.add(job)
    await db.commit()

    result = await db.execute(
        select(Job).options(selectinload(Job.salon)).where(Job.id == job.id)
    )
    job = result.scalar_one()
    return await _build_job_response(job, db)


@router.put("/{job_id}", response_model=JobResponse)
async def update_job(
    job_id: int,
    payload: JobUpdate,
    current_user: User = Depends(require_stylist),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(Job).options(selectinload(Job.salon)).where(Job.id == job_id)
    )
    job = result.scalar_one_or_none()
    if not job:
        raise HTTPException(status_code=404, detail="Job not found")
    if job.salon.stylist_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to update this job")

    for field, value in payload.model_dump(exclude_none=True).items():
        setattr(job, field, value)
    await db.commit()
    await db.refresh(job)

    result = await db.execute(
        select(Job).options(selectinload(Job.salon)).where(Job.id == job.id)
    )
    job = result.scalar_one()
    return await _build_job_response(job, db)


@router.delete("/{job_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_job(
    job_id: int,
    current_user: User = Depends(require_stylist),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(Job).options(selectinload(Job.salon)).where(Job.id == job_id)
    )
    job = result.scalar_one_or_none()
    if not job:
        raise HTTPException(status_code=404, detail="Job not found")
    if job.salon.stylist_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to delete this job")

    await db.delete(job)
    await db.commit()
