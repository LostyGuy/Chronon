from fastapi import APIRouter, Depends
from fastapi.responses import JSONResponse, HTMLResponse

router = APIRouter()

@router.put("/", response_class=HTMLResponse)
async def changes_from_calendars():
    """
    Retrieve calendar update changes.
    """
    
    
    raise NotImplementedError