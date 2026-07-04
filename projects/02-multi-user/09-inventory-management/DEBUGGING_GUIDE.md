## 🛠️ Debugging & Verification

**Test 1: Negative Stock Prevention**
- Set stock to 5.
- Try to adjust by -6. Should return `400 Bad Request: Insufficient Stock`.

**Test 2: Ledger Reconciliation**
- Adjust +10 (Restock).
- Adjust -2 (Sale).
- Adjust -1 (Damage).
- Query the ledger. Ensure the sum of `quantity_change` perfectly matches the `current_stock` column (7).
