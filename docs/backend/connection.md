# Connection

<i>connection.py</i> - Takes care of connection from start to end. `except Exception` block triggers for every error and get raised so the <i>error_handling.py</i> captures it.

## Version - v1

- Models:
    - Each file has one to two tables where columns are mapped and given constrains. Letting the sqlalchemy to work instead of plain SQL