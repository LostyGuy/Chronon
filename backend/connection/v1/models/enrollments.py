from sqlalchemy import BigInteger, Boolean, Column, DateTime, String, func

from backend.connection.v1.connection import Base


class EnrollmentForm(Base):
    __tablename__ = "enrollment_form"

    enrollment_form_id = Column(
        BigInteger, 
        primary_key=True, 
        nullable=False, 
        autoincrement=True,
    )
    name = Column(
        String(120), 
        nullable=False,
    )
    email = Column(
        String(254), 
        nullable=False, 
        unique=True,
    )
    university = Column(
        String(160), 
        nullable=True,
    )
    marketing_box = Column(
        Boolean, 
        nullable=False, 
        server_default="false",
    )
    created_at = Column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )
