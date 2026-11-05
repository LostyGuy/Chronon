from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from pydantic import EmailStr

from backend.connection.v1.connection import get_db
import backend.app.v1.services.enrollments as enrollment
from backend.app.v1.schemas.enrollments import EnrollmentSubmission



router = APIRouter()


@router.post("/form", status_code=status.HTTP_201_CREATED)
async def enrollment_form(form: EnrollmentSubmission, db_session: Session = Depends(get_db)) -> dict[str, str]:
    
    
    name: str = form.name
    email: EmailStr = form.email
    university: str | None = form.university
    marketing_box: bool = form.marketing_emails
    
    enrollment.form_request(
        name= name,
        email= email,
        university= university,
        marketing_emails= marketing_box,
        db_session=db_session,
    )
    
    return {"message": "Your tester registration has been saved."}
