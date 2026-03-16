from fastapi import APIRouter, HTTPException
from database.supabase_client import get_supabase

from supabase import Client

router = APIRouter(prefix="/debug")

supabase: Client = get_supabase()


@router.get("/budget/{budget_id}")
async def debug_budget(budget_id: int):
    """
    Debug endpoint to see what your budget table returns
    Use this to verify column names match
    """
    try:
        budget = supabase.table("ml_budgets").select("*").eq("id", budget_id).execute()
        transactions = supabase.table("ml_transactions").select("*").eq("budget_id", budget_id).execute()
        
        return {
            "budget": budget.data,
            "transactions": transactions.data,
            "budget_columns": list(budget.data[0].keys()) if budget.data else [],
            "transaction_columns": list(transactions.data[0].keys()) if transactions.data else []
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))