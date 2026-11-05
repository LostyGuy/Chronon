from fastapi import FastAPI
from fastapi.responses import JSONResponse, RedirectResponse, HTMLResponse, FileResponse
from fastapi.templating import Jinja2Templates as J2T
from fastapi.staticfiles import StaticFiles
from dotenv import load_dotenv
from pathlib import Path

from backend.app.v1.api.routers import router
from backend.app.v1.error_handling import capture_errors
load_dotenv()

app = FastAPI()
app.include_router(router)
capture_errors(app)

flutter_web_path = Path(__file__).resolve().parent.parent.parent / "frontend" / "build" / "web"
if flutter_web_path.exists():
    app.mount("/assets", StaticFiles(directory=flutter_web_path / "assets"), name="assets")
    # 

#----For Web----
@app.get("/", response_class=HTMLResponse)
async def main_page():
    """
    Return a greeting message from the root endpoint.
    
    Returns:
        dict: Dictionary containing the greeting {"Hello": "Hello World"}
    """
    app.mount("/", StaticFiles(directory=flutter_web_path, html=True), name="flutter-web")
    index_page = flutter_web_path /"index.html" 
    
    return FileResponse(
        path=index_page, 
        status_code=200
    )
#----End For Web----
