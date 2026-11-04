import pytest
from sqlalchemy import select

import backend.app.v1.services as services
import backend.connection.v1.models as models
#!----Tests----

#----Groups----

def test_create_group(db_session):

    try:
        services.create_group(
            name= "some name",
            db_session= db_session,
        )

        id_in_database: str = db_session.execute(
            select(
                models.Group.unique_uuid,
            ).where(
                models.Group.name == "some name",
            ).order_by(
                models.Group.group_id.desc()
            )
        ).scalar()
    except:
        raise

    assert id_in_database is not None
    assert isinstance(id_in_database, str)

@pytest.mark.skip
def test_update_group():
    raise NotImplementedError

@pytest.mark.skip
def test_remove_group():
    raise NotImplementedError
