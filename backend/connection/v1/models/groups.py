from sqlalchemy import Column, BigInteger, String, DateTime, ForeignKey, func

from backend.connection.v1.connection import Base


class Group(Base):
    __tablename__ = 'groups'
    group_id = Column(
        BigInteger,
        primary_key= True,
        nullable= False,
        autoincrement= True,
    )
    name = Column(
        String,
        nullable= False,
    )
    unique_uuid = Column(
        String,
        nullable= False,
        unique= True,
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


class GroupMember(Base):
    __tablename__ = 'group_members'
    group_member_id = Column(
        BigInteger,
        primary_key= True,
        nullable= False,
        autoincrement= True,
    )
    user_id = Column(
        BigInteger,
        ForeignKey("users.user_id"),
        nullable= False,
    )
    group_id = Column(
        BigInteger,
        ForeignKey("groups.group_id"),
        nullable= False,
    )
    role_id = Column(
        BigInteger,
        ForeignKey("roles.role_id"),
        nullable= False,
    )
    joined_at = Column(
        DateTime(timezone= True),
        nullable= False,
        server_default= func.now(),
    )
    left_at = Column(
        DateTime(timezone= True),
        nullable= True,
    )
    created_at = Column(
        DateTime(timezone= True),
        nullable= False,
        server_default= func.now(),
    )