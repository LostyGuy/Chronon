import pytest
from sqlalchemy import select
import secrets

from datetime import timedelta
import jwt

import backend.connection.v1.models as models
import backend.app.v1.services.auth_tokens as token
from backend.security.v1.hashing import hash_string
from backend.logging import log_error
from backend.testing.v1.conftest import EXISTING_USERS
from backend.timestamps import current_time
from backend.config import get_environmental_variables


def test_create_refresh_token(db_session):
    
    try:
        user_id = db_session.execute(
            select(
                models.User.user_id
            ).where(
                models.User.email == EXISTING_USERS[0]["email"],
            )
        ).scalar_one()
    except Exception as e:
        log_error("Test_Create_Refresh_Token: ", e)
        assert True == False #-- Force error --
    
    raw_token = token.create_refresh_token(
        user_id = user_id,
        device_name= EXISTING_USERS[0]["device_name"],
        ip_address= EXISTING_USERS[0]["ip_address"],
        db_session=db_session,
    )
    
    assert raw_token != None
    
    
def test_update_refresh_token(db_session):
    
    old_raw_token: str = secrets.token_urlsafe(64)
    token_hash: str = hash_string(old_raw_token)
    
    Toms_id = db_session.execute(
        select(
            models.User.user_id
        ).where(
            models.User.email == EXISTING_USERS[0]["email"]
        )
    ).scalar_one()
    
    # place hashed token in DB
    try:
        dummy_token = models.RefreshToken(
            user_id = Toms_id,
            token_hash = token_hash,
            expire_at = current_time() + token.REFRESH_LIFESPAN,
            ip_address = "10.10.10.10",
        )
        db_session.add(dummy_token)
        db_session.commit()

    except Exception as e:
        log_error("Test Update Refresh Token ", e)
    
    new_raw_token = token.update_refresh_token(
        raw_token=old_raw_token,
        db_session=db_session,
    )
    is_Tom_an_owner = db_session.execute(
        select(
            models.RefreshToken.user_id
        ).where(
            models.RefreshToken.token_hash == hash_string(new_raw_token),
            models.RefreshToken.ip_address == "10.10.10.10",
        )
    ).scalar_one()
    
    old_refresh_token = db_session.execute(
        select(
            models.RefreshToken.is_revoked
        ).where(
            models.RefreshToken.token_hash == hash_string(old_raw_token)
        )
    ).scalar_one()
    
    assert Toms_id == is_Tom_an_owner
    assert old_refresh_token == True
    assert old_raw_token != new_raw_token    
    

def test_revoke_refresh_token(db_session):

    #---- Add Ref. Token Manually ----
    raw_token: str = secrets.token_urlsafe(64)
    token_hash: str = hash_string(raw_token)

    Toms_id = db_session.execute(
            select(
                models.User.user_id
            ).where(
                models.User.email == EXISTING_USERS[0]["email"]
            )
        ).scalar_one()
    try:
        new_token = models.RefreshToken(
                user_id = Toms_id,
                token_hash = token_hash,
                expire_at = current_time() + token.REFRESH_LIFESPAN,
                device_name = "device_name",
                ip_address = "ip_address",
            )
        db_session.add(new_token)
        db_session.commit()
        
    except Exception as e:
        log_error("Test Revoke Refresh Token: ", e)

    token.revoke_refresh_token(
        raw_token= raw_token,
        db_session= db_session
        )

    #---- Assertion ----

    is_revoked = db_session.execute(
        select(
            models.RefreshToken.is_revoked
        ).where(
            models.RefreshToken.user_id == Toms_id,
            models.RefreshToken.token_hash == token_hash
        )
    ).scalar_one_or_none()

    assert is_revoked == True


def test_revoke_all_refresh_tokens(db_session):

    max_iter: int = 4
 
    for iter in range(0, max_iter + 1):
    #---- Add Ref. Token Manually ----
        raw_token: str = secrets.token_urlsafe(64)
        token_hash: str = hash_string(raw_token)
        
        Toms_id = db_session.execute(
            select(
                models.User.user_id
            ).where(
                models.User.email == EXISTING_USERS[0]["email"]
            )
        ).scalar_one()
        try:
            new_token = models.RefreshToken(
                    user_id = Toms_id,
                    token_hash = token_hash,
                    expire_at = current_time() + token.REFRESH_LIFESPAN,
                    device_name = "device_name",
                    ip_address = "ip_address",
            )
            db_session.add(new_token)
            db_session.commit()
            
        except Exception as e:
            log_error("Test Revoke Refresh Token: ", e)

    #---- Execution ----
    
    token.revoke_all_refresh_tokens(
        user_id= Toms_id,
        db_session= db_session
    )
    
    #---- Assertion ----

    are_revoked = db_session.execute(
        select(
            models.RefreshToken.is_revoked,
        ).where(
            models.RefreshToken.user_id == Toms_id,
        )
    ).scalars().all()

    for entry in are_revoked:
        assert entry == True


def test_create_access_token(db_session):

    SECRET_KEY = get_environmental_variables("SECRET_KEY")
    ALGORITHM = get_environmental_variables("ALGORITHM")

    Toms_id = db_session.execute(
        select(
            models.User.user_id
        ).where(
            models.User.email == EXISTING_USERS[0]["email"]
        )
    ).scalar_one()

    assert Toms_id is not None
    
    access_token = token.create_access_token(user_id= Toms_id)

    payload = jwt.decode(
        jwt= access_token,
        key= SECRET_KEY,
        algorithms= [ALGORITHM],
    )

    assert payload is not None
    assert type(payload['iat']) is int 
    assert type(payload['exp']) is int 

