from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from sqlalchemy.orm import selectinload

from app.auth import get_current_user
from app.database import get_db
from app.models.user import User, UserRole
from app.models.salon import Salon
from app.models.job import Job, JobStatus
from app.models.application import Application, ApplicationStatus
from app.models.hair_info import HairInfo
from app.schemas.application import (
    ApplicationCreate,
    ApplicationStatusUpdate,
    ApplicationResponse,
    ApplicantResponse,
    JobSummary,
    SalonInfo,
)

router = APIRouter(tags=["applications"])


def require_model(current_user: User = Depends(get_current_user)) -> User:
    if current_user.role != UserRole.model:
        raise HTTPException(status_code=403, detail="Only models can apply to jobs")
    return current_user


def require_stylist(current_user: User = Depends(get_current_user)) -> User:
    if current_user.role != UserRole.stylist:
        raise HTTPException(status_code=403, detail="Only stylists can manage applicants")
    return current_user


@router.post("/jobs/{job_id}/apply", response_model=ApplicationResponse, status_code=status.HTTP_201_CREATED)
async def apply_to_job(
    job_id: int,
    payload: ApplicationCreate,
    current_user: User = Depends(require_model),
    db: AsyncSession = Depends(get_db),
):
    # Check job exists and is open
    job_result = await db.execute(
        select(Job).options(selectinload(Job.salon)).where(Job.id == job_id)
    )
    job = job_result.scalar_one_or_none()
    if not job:
        raise HTTPException(status_code=404, detail="Job not found")
    if job.status != JobStatus.open:
        raise HTTPException(status_code=400, detail="Job is no longer accepting applications")

    # Check not already applied
    existing = await db.execute(
        select(Application).where(
            Application.job_id == job_id,
            Application.model_id == current_user.id,
        )
    )
    if existing.scalar_one_or_none():
        raise HTTPException(status_code=400, detail="You have already applied to this job")

    application = Application(
        job_id=job_id,
        model_id=current_user.id,
        message=payload.message,
    )
    db.add(application)
    await db.commit()
    await db.refresh(application)

    return ApplicationResponse(
        id=application.id,
        job_id=application.job_id,
        model_id=application.model_id,
        status=application.status,
        message=application.message,
        stylist_note=application.stylist_note,
        applied_at=application.applied_at,
        updated_at=application.updated_at,
        job=JobSummary.model_validate(job),
        salon=SalonInfo.model_validate(job.salon),
    )


@router.get("/applications/me", response_model=list[ApplicationResponse])
async def get_my_applications(
    current_user: User = Depends(require_model),
    db: AsyncSession = Depends(get_db),
):
    """Get all applications submitted by the current model."""
    result = await db.execute(
        select(Application)
        .options(
            selectinload(Application.job).selectinload(Job.salon)
        )
        .where(Application.model_id == current_user.id)
        .order_by(Application.applied_at.desc())
    )
    applications = result.scalars().all()

    responses = []
    for app in applications:
        responses.append(
            ApplicationResponse(
                id=app.id,
                job_id=app.job_id,
                model_id=app.model_id,
                status=app.status,
                message=app.message,
                stylist_note=app.stylist_note,
                applied_at=app.applied_at,
                updated_at=app.updated_at,
                job=JobSummary.model_validate(app.job) if app.job else None,
                salon=SalonInfo.model_validate(app.job.salon) if app.job and app.job.salon else None,
            )
        )
    return responses


@router.get("/jobs/{job_id}/applicants", response_model=list[ApplicantResponse])
async def list_applicants(
    job_id: int,
    current_user: User = Depends(require_stylist),
    db: AsyncSession = Depends(get_db),
):
    """Get all applicants for a specific job (stylist only)."""
    job_result = await db.execute(
        select(Job).options(selectinload(Job.salon)).where(Job.id == job_id)
    )
    job = job_result.scalar_one_or_none()
    if not job:
        raise HTTPException(status_code=404, detail="Job not found")
    if job.salon.stylist_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to view these applicants")

    result = await db.execute(
        select(Application)
        .options(
            selectinload(Application.model).selectinload(User.hair_info)
        )
        .where(Application.job_id == job_id)
        .order_by(Application.applied_at.asc())
    )
    return result.scalars().all()


@router.put("/applications/{application_id}/status", response_model=ApplicationResponse)
async def update_application_status(
    application_id: int,
    payload: ApplicationStatusUpdate,
    current_user: User = Depends(require_stylist),
    db: AsyncSession = Depends(get_db),
):
    """Approve or reject an application (stylist only)."""
    result = await db.execute(
        select(Application)
        .options(
            selectinload(Application.job).selectinload(Job.salon)
        )
        .where(Application.id == application_id)
    )
    application = result.scalar_one_or_none()
    if not application:
        raise HTTPException(status_code=404, detail="Application not found")
    if application.job.salon.stylist_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to update this application")

    application.status = payload.status
    if payload.stylist_note:
        application.stylist_note = payload.stylist_note
    await db.commit()
    await db.refresh(application)

    return ApplicationResponse(
        id=application.id,
        job_id=application.job_id,
        model_id=application.model_id,
        status=application.status,
        message=application.message,
        stylist_note=application.stylist_note,
        applied_at=application.applied_at,
        updated_at=application.updated_at,
        job=JobSummary.model_validate(application.job) if application.job else None,
        salon=SalonInfo.model_validate(application.job.salon) if application.job and application.job.salon else None,
    )
