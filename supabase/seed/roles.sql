insert into roles (
    name,
    description,
    can_manage_events,
    can_invite_members
) values (
    'owner',
    'none',
    'True',
    'True'
), (
    'user',
    'none',
    'False',
    'False'
)