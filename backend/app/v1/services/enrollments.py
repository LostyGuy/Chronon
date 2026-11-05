from sqlalchemy import insert
from sqlalchemy.orm import Session

import backend.connection.v1.models as models


def form_request(name: str, email: str, university: str | None, marketing_box: bool, db_session: Session) -> bool:
    
    enrollment_input = {
        "name": name,
        "email": email.strip().lower(),
        "university": university.strip() if university and university.strip() else None,
        "marketing_emails": marketing_box,
    }

    result = db_session.execute(
        insert(
            models.EnrollmentForm
        ).values(
            **enrollment_input
        )
    )
    db_session.commit()
    
    return True