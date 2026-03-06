from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    SUPABASE_URL: str
    SUPABASE_KEY: str

    API_NAME: str = "MoneyUp Model/AI API"

    class Config:
        env_file = ".env"


settings = Settings()