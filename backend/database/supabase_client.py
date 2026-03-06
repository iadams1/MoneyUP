from supabase import create_client, Client

from core.config import settings

supabase: Client | None = None

def init_supabase():

    global supabase

    supabase = create_client(
        settings.SUPABASE_URL,
        settings.SUPABASE_KEY
    )

def get_supabase() -> Client:

    if supabase is None:
        raise RuntimeError("Supabase client not initialized")

    return supabase