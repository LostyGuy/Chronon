import pytest
from sqlalchemy import select

import backend.app.v1.services as services
import backend.connection.v1.models as models


#----Group Permission----
@pytest.mark.skip
def test_grant_editing_on_group_schedule():
    raise NotImplementedError

@pytest.mark.skip
def test_revoke_editing_on_group_schedule():
    raise NotImplementedError