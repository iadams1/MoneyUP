from contextlib import asynccontextmanager
from fastapi import FastAPI

from database.supabase_client import init_supabase
from services.ml_services import load_models


@asynccontextmanager
async def lifespan(app: FastAPI):
    print("Starting API...")

    # startup
    init_supabase() # Creating Supabase Client

    load_models()

    yield

    # shutdown
    print("Shutting down API...")