# 💸 Expense Tracker API: Learn By Building

**"Build a multi-user finance API where users can log daily expenses, categorize them, and generate monthly budget reports."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Relying on the Frontend for Business Logic

**Wrong:**
```javascript
// Backend just returns raw data
app.get('/api/expenses', async (req, res) => {
  const expenses = await db.query("SELECT * FROM expenses WHERE user_id = ?", req.user.id);
  res.json(expenses);
});

/* Frontend Javascript (React) doing the math:
   let spent = 0;
   expenses.forEach(e => {
     if (e.date.startsWith('2026-10') && e.category_id === '123') {
       spent += e.amount;
     }
   });
*/
```
*Why it's bad:* If a user has 5 years of daily expenses (1,800 rows), the backend sends all 1,800 rows across the network (slow) just so the frontend can add up 30 of them. Also, if you build an iOS app later, you have to rewrite the same math logic in Swift.

**Right:**
The backend does the heavy math using SQL `SUM()` and date grouping, and sends the exact final numbers to the frontend.

### ❌ Mistake 2: Missing Data Isolation (`user_id` checks)

**Wrong:**
```javascript
app.delete('/api/expenses/:id', async (req, res) => {
  // Deleting based purely on the ID provided in the URL
  await db.query("DELETE FROM expenses WHERE id = ?", req.params.id);
  res.send("Deleted");
});
```
*Why it's bad:* A hacker can write a script that loops from `id=1` to `id=99999` and deletes every expense in the entire database, because you didn't check if they *own* the expense.

**Right:**
Always include the `user_id` from the secure JWT token in your `WHERE` clause.
```javascript
app.delete('/api/expenses/:id', async (req, res) => {
  await db.query("DELETE FROM expenses WHERE id = ? AND user_id = ?", [req.params.id, req.user.id]);
});
```

### ❌ Mistake 3: Storing Money as Floats

**Wrong:**
```sql
CREATE TABLE expenses ( amount FLOAT );
```
*Why it's bad:* Standard computers cannot perfectly represent decimals in binary. Try typing `0.1 + 0.2` in a Node.js console. You will get `0.30000000000000004`. If you sum thousands of float expenses, your budget will be off by several dollars.

**Right:**
Use strict decimals: `DECIMAL(10,2)`. Or better yet, store cents as an Integer (e.g., $5.00 is `500`).

---
