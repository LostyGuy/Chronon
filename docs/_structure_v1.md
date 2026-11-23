# Structure of the app

### Table of Contents
| [Backend](#backend) | [DevLog](#devlog) | [Frontend](#frontend) | [Supabase](#supabase) |


## Backend

-  There are 4 main sections:
   - App
   - Connection
   - Security
   - Testing

Each one has versions inside e.g. v1

- App:
    - Version (v1):
        - API - Contains routers.py which assigns route e.g. <i>'/login'</i> to a specific endpoint
        - Routers - Contains these endpoints which are categoried e.g. <i>events.py</i>
        - Schemas - Protects in/out data. Sets boudaries on what data can pass the gates and which aren't allowed. Same categorization and Routers
        - Services - Functions made specifically for endpoints. Also categorized
        - <i>error_handling.py</i> - Centralized error handling to get rid of repeating `try/except` blocks. 
- Connection:
    - Version (v1):
        - Models - Contains tables that are in my database
        - <i>connection.py</i> - This file creates a connection to database and handles the most primal errors while executing than connection
- Security:
    - Version (v1):
        - <i>hashing.py</i> - contains logic than encrypts user input
- Testing:
    - Version (v1):
        - Integration - Contains tests to check if some longer process like full registration goes without any issues
        - Unit - Contains tests 1:1 with Services
        - <i>conftest.py</i> - Sets an environment for testing purposes, like database mocked connection, preparing user data
- <i>config.py</i> - Broadly used functions
- <i>logging.py</i> - Logging the errors to a file for debuging
- <i>timestamps.py</i> - Creating a unified timestamps

For more information read dedicated:
 - [App README](./backend/app.md)
 - [Connection README](./backend/connection.md)
 - [Security README](./backend/security.md)
 - [Testing README](./backend/testing.md)

## DevLog

This section work as a tool for me to mention crucial events in <i>readme.md</i> without me writing everything by hand each time.

For more information check: [Devlog README](devlog/readme.md)

## Frontend

- Changes are to be made in <b><i>lib</i></b> folder and than 
`flutter web build` - for web update
  - main.dart - Main page
  - enrolment.dart - Contains form
  - chronon_colors.dart - Stores prefered color scheme

## Supabase

This folder is from supabase CLI tool, more information available at [Supabase CLI]()

What I use:
- Migrations - Stores each version of database scheme
- Seed - Adds data to tables without additional python code. Pure SQL
- <i>config.toml</i> - Things I changed are as follow:
    - Path to seed files
    - Connection port for local development