## ⚠️ Common Mistakes

❌ **Mistake 1: Using FLOAT for Money**
Floating point math in computers is imprecise. `0.1 + 0.2 = 0.30000000000000004`. If you use FLOAT for a banking app, you will literally lose/invent pennies over time. Always use `DECIMAL(10,2)` or store values as Integer cents (e.g., $10.50 = 1050 cents).

❌ **Mistake 2: Missing Indexing**
If a user logs 5 expenses a day for 5 years, getting their monthly summary requires scanning 10,000 rows. You must add an Index on `(user_id, date)`.
