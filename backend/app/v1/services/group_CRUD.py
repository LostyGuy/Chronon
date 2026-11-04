from sqlalchemy import select, update, delete
from uuid import uuid4

import backend.app.v1.services as services
import backend.connection.v1.models as models

def create_group(name: str, created_by:int , db_session) -> str:

    uuid: str = str(uuid4())
    new_group = models.Group(
        name = name,
        unique_uuid = uuid,
        created_by = created_by, #hardcoded value
    )
    db_session.add(new_group)
    db_session.commit()
    
    return uuid

def update_group(new_name:str, group_uuid:int, created_by:int,  db_session) -> bool:
    
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
        update(models.Group).where(
            models.Group.unique_uuid == group_uuid,
            models.Group.created_by == user_id
        ).values(
            name = new_name
        )
    )
    
    return result.row_counter > 0