# 📦 Inventory Management System: Learn By Building

**"Build a multi-user inventory API where warehouse staff receive stock, cashiers deduct stock via sales, and managers view real-time low-stock alerts, using database transactions to prevent negative inventory."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Read-Modify-Write without Locks

**Wrong:**
```javascript
app.post('/api/sell', async (req, res) => {
  // 1. Read the current stock
  const product = await db.query("SELECT current_stock FROM products WHERE id=?", req.body.product_id);
  
  if (product.current_stock >= req.body.quantity) {
    // 2. Modify and Write the new stock
    const newStock = product.current_stock - req.body.quantity;
    await db.query("UPDATE products SET current_stock = ? WHERE id = ?", [newStock, req.body.product_id]);
  }
});
```
*Why it's bad:* This is a classic Race Condition. If two API calls run this exact code at the same time, they both read "10", they both subtract "5", they both calculate "5", and they both save "5". You sold 10 items, but the stock only went down by 5.

**Right:**
Let the database do the math atomically.
```javascript
// The database handles the math safely, regardless of how many requests hit it at once.
await db.query("UPDATE products SET current_stock = current_stock - ? WHERE id = ?", [quantity, id]);
```

### ❌ Mistake 2: Missing the Audit Log

**Wrong:**
```javascript
// Just changing the number
await db.query("UPDATE products SET current_stock = 150 WHERE id = 1");
```
*Why it's bad:* In six months, the accountant will ask "Why did stock jump from 100 to 150?". You will have no answer, because you overwrote the history. 

**Right:**
Always wrap the stock update AND the audit log insert in a Transaction.
```javascript
BEGIN TRANSACTION;
  UPDATE products SET current_stock = current_stock + 50 WHERE id = 1;
  INSERT INTO inventory_movements (product_id, type, quantity, reason) VALUES (1, 'in', 50, 'Restock');
COMMIT;
```

### ❌ Mistake 3: Soft Deletions and Foreign Keys

**Wrong:**
Allowing a manager to `DELETE FROM products WHERE id = 1`.
*Why it's bad:* If you configured your DB with `ON DELETE CASCADE`, this will automatically delete thousands of `inventory_movements` rows associated with that product. You just erased the financial history of the company!

**Right:**
Use `ON DELETE RESTRICT` (The database blocks the deletion if there is history), or use **Soft Deletes** (add an `is_archived` boolean to the Products table instead of physically deleting the row).

---
