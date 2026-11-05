from fastapi import FastAPI
from fastapi.responses import JSONResponse, RedirectResponse, HTMLResponse, FileResponse
from fastapi import FastAPI, HTTPException
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

flutter_web_path = (
    Path(__file__).resolve().parent.parent.parent
    / "frontend"
    / "build"
    / "web"
)

@app.get("/")
async def main_page():
    index_page = flutter_web_path / "index.html"
    if not index_page.is_file():
        raise HTTPException(
            status_code=503,
            detail="Flutter web build is not available",
        )
    return FileResponse(index_page)

if flutter_web_path.is_dir():
    app.mount(
        "/",
        StaticFiles(directory=flutter_web_path, html=True),
        name="flutter-web",
    )