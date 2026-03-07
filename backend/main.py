
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# Lifespan
from core.lifespan import lifespan

# from middleware 

# API route groups
from api.routes import health, categories, debug, prediction

# Initialize FastAPI
app = FastAPI(
    title="Budget Prediction API",
    version="2.0.0",
    lifespan=lifespan
)

# Add CORS for Flutter
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Add Router Groups
app.include_router(health.router)
app.include_router(categories.router)
app.include_router(debug.router)
app.include_router(prediction.router)

