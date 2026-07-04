## ⚠️ Common Mistakes

❌ **Mistake 1: Race Conditions in Stock Updates**
If Product A has 1 item left, and Salesman X and Salesman Y hit the "Sell" button at the exact same millisecond, they might both read "Stock=1", both subtract 1, and the system saves Stock=-1.
**Fix:** You must lock the row during the transaction (`SELECT current_stock FROM products WHERE id=X FOR UPDATE`).

❌ **Mistake 2: Missing the Ledger**
If you just run `UPDATE products SET stock = 40`, and tomorrow the manager asks "Where did the other 10 go?", you have no answer. The ledger is mandatory.
