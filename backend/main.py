
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# from middleware 

# API route groups
# from api.routes import health

# Initialize FastAPI
app = FastAPI(
    title="Budget Prediction API",
    version="2.0.0")

# Add CORS for Flutter
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Add Router Groups
# app.include_router(health.router)

