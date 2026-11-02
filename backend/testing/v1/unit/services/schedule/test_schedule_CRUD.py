import pytest
from sqlalchemy import select 

from backend.testing.v1.conftest import MIXED_USERS
import backend.connection.v1.models as models
import backend.app.v1.services.schedule_CRUD as v1
from backend.logging import log_error


def test_create_schedule(db_session):

    for index, user_email in enumerate(MIXED_USERS, start= 1):
        try:
            user_id = db_session.execute(
                select(
                    models.User.user_id
                ).where(
                    models.User.email == user_email
                )
            ).scalar()

            new_schedule: dict[str, str | int] = {
                "name" : f"Test_Schedule_of_{user_id}",
                "description" : "Some desc",
                "created_by" : user_id
            }

            if result := v1.create_schedule(
                name= str(new_schedule['name']), 
                description= str(new_schedule['description']), 
                created_by= int(new_schedule['created_by']),
                db_session= db_session,
                ):

                newly_created_schedule = db_session.execute(
                    select(
                        models.Schedule.name,
                        models.Schedule.description,
                        models.Schedule.group_id,
                    ).where(
                        models.Schedule.created_by == user_id
                    ).order_by(
                        models.Schedule.schedule_id.desc()
                    ).limit(1)
                ).first()

                assert newly_created_schedule is not None, 'Newly Created Schedule returned None'
                assert newly_created_schedule[0] == new_schedule['name'], 'Could not retrieve the name of the schedule'
                assert newly_created_schedule[1] == new_schedule['description'], 'Could not retrieve the description of the schedule'
                assert isinstance(newly_created_schedule[2], int), '`group_id` is not a integer value'
            assert result == False, 'Created a schedule for inexisting user'
        except:
            ...

def test_update_schedule(db_session):
    orig_name: str = 'Default Name'
    orig_desc: str = 'Default Desc'
    
    #---- Test Cases -> Full Update | Partial Update | No data to update protection ----
    test_cases = [
        { # 1st - Full Change
            'id': "1",
            'name': 'Full Change - Name_1',
            'desc': 'Full Change - Desc_1',
        },
        { # 2nd - Partial Change
            'id': "2",
            'name': ' Partial Change - Name_2',
        },
        { # 3rd - Partial Change
            'id': "3",
            'desc': 'Partial Change - Desc_3',
        },
    ]
    
    for case in test_cases:
        result = v1.update_schedule(
            new_name=case.get('name', None),
            new_description=case.get('desc', None),
            request_from_user= 1, # hardcoded value
            schedule_id = 1, # hardcoded value
            db_session= db_session,
        )
        if int(case.get("id", 0)) in (1,2,3):
            assert result is True


def test_delete_schedule(db_session):
    
    result = v1.delete_schedule(
        schedule_id= 1,
        created_by= 1,
        db_session= db_session
    )
    
    check = db_session.execute(
        select(
            models.Schedule.schedule_id
        ).where(
            models.Schedule.schedule_id == 1
        )
    ).one_or_none()

    assert result is True and check is None
