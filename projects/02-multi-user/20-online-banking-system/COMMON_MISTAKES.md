## ⚠️ Common Mistakes

❌ **Mistake 1: The Double Spend Problem**
If a user has $100, and they fire two API requests to transfer $100 to a friend at the exact same millisecond, a poorly written system will read $100 for both requests, pass the check for both, deduct it twice (balance is now -$100), and the friend gets $200. You MUST lock the row using `FOR UPDATE` so the second request waits for the first to finish.

❌ **Mistake 2: Missing the Ledger**
You must always create a record in `Transactions`. If you only `UPDATE` the balance, the bank has no history of where the money went.
