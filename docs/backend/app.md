# App


- <i>main.py</i> - Starting connection with routers and web folder from flutter. Middleware is for successful connection with frontend as I host backend and frontend separatelly on vercel.

## Version - v1

- API
    - <i>routers.py</i> 
    `router = APIRouter(prefix="/api/v1")` binds included routers to this specific prefix.
    `router.include_router(auth_login.router, prefix="/auth/session")` That is how you add a router to the prefix. First argument is a router from Routers folder. They are binded to `router` variable via `router = APIRouter()` at the beggining of file (after imports)
- Routers
    - Each file contains endpoints which are categoried e.g. `enrollments.py`:
        - `/form` - calls function from Services folder and passes the output from them to frontend
- Schemas
    - Prevents unwanted data from comming in and out
    - Each Router file has exactly one scheme file
    - With `pydantic` library we create a class, that has wanted variables and their constrains 
    ```
    class EnrollmentSubmission(BaseModel):
    name: Annotated[
        str, 
        StringConstraints(
            strip_whitespace=True, 
            min_length=1, 
            max_length=120
        )
    ]
    email: EmailStr
    university: Annotated[
        str, 
        StringConstraints(
            max_length=160
        )
    ] | None = None
    marketing_box: bool
    ```
- Services
    - These files contains logic called by endpoints directly e.g. <i>user_CRUD.py</i>. It is the core of an app, every decision is made there.
    ```
    def user_register(name: str, surname: str, username: str, email: str, password: str, db_session, policy_agreement: bool = False, role_id: int = 1) -> bool:

    if policy_agreement:
        new_user = models.User(
            username = username,
            name = name,
            surname = surname,
            email = email,
            hashed_password = hash_string(password),
            role_id = role_id,
            policy_agreement = policy_agreement,
        )
        db_session.add(new_user)
        db_session.commit()

        return True
    else:
        return False
    ```
- <i>error_handling.py</i> - Captures error from the app and based on the type of an Error different decorator e.g. `@app.exception_handler(IntegrityError)` steps into action storing the error in the logs and returning the error code to frontend.