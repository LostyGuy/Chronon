from sqlalchemy import Column, BigInteger, String, DateTime, ForeignKey, Text, func, Boolean

from backend.connection.v1.connection import Base


class Schedule(Base):
    __tablename__ = 'schedules'
    schedule_id = Column(
        BigInteger,
        primary_key= True,
        nullable= False,
        autoincrement= True,
    )
    name = Column(
        String,
        nullable= False,
    )
    description = Column(
        String,
        nullable= True,
    )
    status = Column(
        String,
        nullable= False,
    )
    group_id = Column(
        String,
        ForeignKey("groups.unique_uuid"),
        nullable= True,
    )
    created_by = Column(
        BigInteger,
        ForeignKey("users.user_id"),
        nullable= False,
    )
    created_at = Column(
        DateTime(timezone= True),
        nullable= False,
        server_default= func.now(),
    )
    updated_at = Column(
        DateTime(timezone= True),
        nullable= True,
        server_default= func.now(),
    )


class Event(Base):
    __tablename__ = 'events'
    event_id = Column(
        BigInteger,
        primary_key= True,
        nullable= False,
        autoincrement= True,
    )
    schedule_id = Column(
        BigInteger,
        ForeignKey("schedules.schedule_id"),
        nullable= False,
    )
    title = Column(
        String,
        nullable= False,
    )
    description = Column(
        Text,
        nullable= True,
    )
    start_at = Column(
        DateTime(timezone= True),
        nullable= False,
    )
    end_at = Column(
        DateTime(timezone= True),
        nullable= False,
    )
    color_id = Column(
        BigInteger,
        ForeignKey("colors.color_id"),
        nullable= False,
    )
    is_repeating = Column(
        Boolean,
        nullable= False,
        default= False,
    )
    repeat_pattern = Column(
        String,
        nullable= True,
    )
    status = Column(
        String,
        nullable= False,
        default= 'active',
    )
    created_by = Column(
        BigInteger,
        ForeignKey("users.user_id"),
        nullable= False,
    )
    created_at = Column(
        DateTime(timezone= True),
        nullable= False,
        server_default= func.now(),
    )
    updated_at = Column(
        DateTime(timezone= True),
        nullable= True,
    )