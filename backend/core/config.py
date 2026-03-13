from pydantic_settings import BaseSettings
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent.parent


class Settings(BaseSettings):
    SUPABASE_URL: str
    SUPABASE_KEY: str

    API_NAME: str = "MoneyUp Model/AI API"

    class Config:
        env_file = BASE_DIR / ".env"


settings = Settings()