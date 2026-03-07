from fastapi import APIRouter, HTTPException
from database.supabase_client import get_supabase

router = APIRouter()

supabase = get_supabase()

@router.get("/categories")
def get_categories():
    """Get all categories from category_table"""
    try:
        response = supabase.table("ml_categories").select("*").execute()
        return {
            "success": True,
            "categories": response.data
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))