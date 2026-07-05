# 📦 Inventory Management System: Learn By Building

**"Build a multi-user inventory API where warehouse staff receive stock, cashiers deduct stock via sales, and managers view real-time low-stock alerts, using database transactions to prevent negative inventory."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Database Transactions (ACID)** - Grouping multiple queries (updating stock + inserting a log) into a single, unbreakable operation.  
✅ **Race Conditions & Atomic Updates** - Why `stock = stock - 1` is safe, and `read stock -> subtract 1 in Javascript -> save stock` is dangerous.  
✅ **Event Sourcing (Audit Logs)** - Designing systems where the current state (`current_stock`) is backed by a permanent, immutable ledger of events (`inventory_movements`).  
✅ **Strict Database Constraints** - Using `CHECK (current_stock >= 0)` to guarantee physical impossibility of negative inventory at the lowest level.

---

## 📋 Project Overview

### The Problem

If an e-commerce store tells a customer an item is "In Stock," lets them pay, and then emails them a day later saying "Sorry, we actually ran out," that company loses a customer forever. 

Inventory systems must be mathematically perfect. This is incredibly difficult because you have multiple cashiers selling items, and multiple warehouse workers adding items, all hitting the server at the exact same time.

Furthermore, physical goods represent money. If stock goes missing, management needs an exact, immutable timeline of every single change made to the stock, and the ID of the user who made it.

**Your job:** Build an inventory engine that is immune to race conditions and maintains a strict audit trail.

### Who Uses It

```
Warehouse Worker:
├─ POST /api/inventory/receive (Truck arrived, +50 items)

Cashier:
├─ POST /api/inventory/sell (Customer bought item, -1 item)

Manager:
├─ POST /api/products (Adds a new item to the system)
└─ GET /api/products/low-stock (Dashboard view of what needs reordering)
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. The Core Transaction (Selling Stock)

This must be a Database Transaction. If either the UPDATE or the INSERT fails, the whole thing rolls back.

```pseudocode
POST /api/inventory/sell:
  middlewares: [authenticateUser, requireRole(['cashier', 'manager'])]
  
  req_prod_id = request.body.product_id
  req_qty = request.body.quantity
  req_reason = request.body.reason
  
  // 1. Start the Transaction
  db.execute("BEGIN TRANSACTION")
  
  try:
    // 2. Atomic Update
    // If req_qty is 5, but current_stock is only 3, the database CHECK(current_stock >= 0) 
    // constraint will TRIGGER AN ERROR here!
    db.query(`
      UPDATE products 
      SET current_stock = current_stock - ? 
      WHERE id = ?
    `, [req_qty, req_prod_id])
    
    // 3. Create the Audit Log
    db.query(`
      INSERT INTO inventory_movements (id, product_id, user_id, type, quantity, reason)
      VALUES (UUID(), ?, ?, 'out', ?, ?)
    `, [req_prod_id, req.user.id, req_qty, req_reason])
    
    // 4. Commit (Save it permanently)
    db.execute("COMMIT")
    return 200 "Sale recorded"
    
  catch (error):
    // 5. Rollback (Undo everything if the stock went below zero, or any other error)
    db.execute("ROLLBACK")
    
    // Check if the error was our CHECK constraint
    if error.message.includes('CHECK constraint failed'):
      return 409 "Insufficient stock"
    else:
      return 500 "Internal Server Error"
```

*(Note: Receiving stock (`/api/inventory/receive`) is the exact same logic, but with `current_stock + ?` and type `in`).*

### 2. Low Stock Alerts (Manager Dashboard)

This query is very simple, but crucial for business operations.

```pseudocode
GET /api/products/low-stock:
  middlewares: [authenticateUser, requireRole(['manager'])]
  
  // Compare the two columns directly in SQL
  products = db.query(`
    SELECT id, sku, name, current_stock, low_stock_threshold 
    FROM products 
    WHERE current_stock <= low_stock_threshold
    ORDER BY current_stock ASC
  `)
  
  return 200 {
    alerts_count: products.length,
    products: products
  }
```

### 3. Fetching the Audit Trail

```pseudocode
GET /api/products/:id/movements:
  middlewares: [authenticateUser, requireRole(['manager'])]
  
  // Join the users table so we know WHO made the change
  movements = db.query(`
    SELECT m.type, m.quantity, m.reason, m.created_at, u.full_name
    FROM inventory_movements m
    JOIN users u ON m.user_id = u.id
    WHERE m.product_id = ?
    ORDER BY m.created_at DESC
  `, request.params.id)
  
  return 200 movements
```

---

## ✅ Before Submission

- [ ] System uses RBAC to separate Manager, Warehouse, and Cashier roles.
- [ ] Database schema strictly enforces `CHECK (current_stock >= 0)`.
- [ ] Receiving and Selling stock is wrapped in a SQL `BEGIN TRANSACTION` block.
- [ ] Every change to stock automatically inserts a row into `inventory_movements`.
- [ ] Managers can view a list of products that have fallen below their restock threshold.
- [ ] Code is on GitHub.

**Success:** You have built a transaction-safe inventory engine!
