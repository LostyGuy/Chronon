insert into users (
    username,
    name,
    surname,
    email,
    hashed_password,
    role_id,
    policy_agreement
) values ( -- Make sure how boolean values are written to DB as text or int
    'John', 'Doe', 'Havent seen anything', 'johndoe@mail.com', '', 2, 'True'
),(
    'Tom', 'Prince', 'tom', 'tomprince@mail.com', '', 2, 'True'
)
