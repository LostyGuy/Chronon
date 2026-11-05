from typing import Annotated

from pydantic import BaseModel, EmailStr, StringConstraints

class EnrollmentSubmission(BaseModel):
    name: Annotated[
        str, 
        StringConstraints(
            strip_whitespace=True, 
            min_length=1, 
            max_length=120
        )
    ]
    email: EmailStr
    university: Annotated[
        str, 
        StringConstraints(
            max_length=160
        )
    ] | None = None
    marketing_emails: bool