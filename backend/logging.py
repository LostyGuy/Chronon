import os
import sys
import logging as log
import inspect
from fastapi import Request

handlers: list[log.Handler] = [log.StreamHandler(sys.stdout)]

if not os.getenv("VERCEL"):
    try:
        handlers.append(log.FileHandler("logs.txt", mode="a"))
    except OSError:
        pass

log.basicConfig(
    handlers=handlers,
    level=log.INFO,
    force=True,
)

def log_info(*message) -> None:
    log.info(20*'-')
    log.info(message)
    log.info(20*'-')

def log_error(*message) -> None:
    log.error(20*'-')
    log.error(message)
    log.error(20*'-')
    
def log_sql_handler_error(title: str, original_message, sql_statement, sql_parameters, request: Request) -> None:
    log.info(20*'-')
    log.info(f"{title} Error at {request.method} {request.url.path} \n")
    log.info(f"-> Details:      {original_message}\n")
    log.info(f"-> Statement:    {sql_statement}\n")
    log.info(f"-> Parameters:   {sql_parameters}\n")
    log.info(20*'-')
    
current_function = inspect.currentframe().f_code.co_name
