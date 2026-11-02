from sqlalchemy import select, update, delete

import backend.app.v1.services as services
import backend.connection.v1.models as models


def create_schedule(name: str, description: str, created_by: int, db_session) -> bool:

    user_id = db_session.execute(
        select(
            models.User.user_id
        ).where(
            models.User.user_id == created_by
        )
    ).scalar()
    
    if not user_id:
        return False
    
    group_id: str = services.create_group(name= name, db_session= db_session)

    new_schedule = models.Schedule(
        name = name,
        description = description,
        status = "active",
        group_id = group_id,
        created_by = user_id,
    )

    db_session.add(new_schedule)
    db_session.commit()
    return True

def update_schedule(new_name: str | None, new_description: str | None, request_from_user: int, schedule_id: int, db_session) -> bool:
    
    update_values: dict[str, str] = {}
    if new_name is not None:
        update_values["name"] = new_name
    if new_description is not None:
        update_values["description"] = new_description
        
    if update_values == {}:
        return True
    
    user_id = db_session.execute(
        select(
            models.User.user_id
        ).where(
            models.User.user_id == request_from_user
        )
    ).scalar()
    
    if not user_id:
        return False
    
    #---- Values that can be changed: name, desc ----

    result = db_session.execute(
        update(
            models.Schedule
        ).where(
            models.Schedule.schedule_id == schedule_id,
            models.Schedule.created_by == user_id
        ).values(
            **update_values
        )
    )
    db_session.commit()
    
    return result.rowcount > 0

def delete_schedule(schedule_id: int, created_by: int, db_session) -> bool:

    user_id = db_session.execute(
            select(
                models.User.user_id
            ).where(
                models.User.user_id == created_by
            )
        ).scalar()
        
    if not user_id:
        return False
    
    result = db_session.execute(
        delete(models.Schedule).where(
            models.Schedule.created_by == created_by,
            models.Schedule.schedule_id == schedule_id,
        )
    )
    db_session.commit()
    
    return result.rowcount > 0