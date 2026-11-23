# Testing

## Version - v1

- Integration: (Currently suspended)
    - Routers
    - Services
- Unit:
    - Services:
        - Categorized folders (as should be in the `./app/services/`) with test files for every operation available on `./app/services/`
        - The goal of test is to make a working function and be able to tell whether next changes passes the test meaning the backend is working properly.
        - Each test is working on a local database on docker container and using sessions so no changes to make to the database in the end, as if nothing happend.