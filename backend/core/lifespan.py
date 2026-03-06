from contextlib import asynccontextmanager
from fastapi import FastAPI

from database.supabase_client import init_supabase


@asynccontextmanager
async def lifespan(app: FastAPI):

    # startup
    init_supabase()

    yield

    # shutdown