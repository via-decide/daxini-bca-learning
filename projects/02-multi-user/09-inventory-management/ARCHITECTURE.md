# Inventory Management System

## 🏗️ Architecture: Design Before Coding

**The Problem:**
A warehouse has 50 laptops in stock. A salesman sells 5. A manager adjusts the count because 2 were broken. We need an absolute source of truth for stock levels, and a complete audit trail of WHO changed WHAT.

**The Solution:**
Never just update the `stock_count` row directly. Always append to a ledger (Audit Log). The current stock is simply the sum of all transactions (+50, -5, -2 = 43).

**Database Architecture:**
```text
Products
├─ id
├─ sku
├─ name
└─ low_stock_threshold (INT)

Inventory_Transactions (The Ledger)
├─ id
├─ product_id
├─ user_id (Who made the change)
├─ quantity_change (INT: +50 or -5)
├─ reason (ENUM: 'Sale', 'Restock', 'Damage')
└─ timestamp
```
