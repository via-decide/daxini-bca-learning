# 📦 Inventory Management System: Learn By Building

**"Build a multi-user inventory API where warehouse staff receive stock, cashiers deduct stock via sales, and managers view real-time low-stock alerts, using database transactions to prevent negative inventory."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. A Manager creates a new product: "Wireless Mouse" with a reorder threshold of 10.
2. A Warehouse Worker receives a shipment of 50 mice.
3. A Cashier sells 2 mice to a customer.
4. The system calculates there are 48 mice left.

**What data do you need for each?**

After thinking, here's the data model:

```
Table: Users (Warehouse, Cashier, Manager)
├─ id (UUID)
├─ email (String)
├─ password_hash (String)
└─ role (Enum: 'manager', 'warehouse', 'cashier')

Table: Products
├─ id (UUID)
├─ name (String)
├─ sku (String - Unique Barcode)
├─ price (Decimal)
├─ current_stock (Integer)
└─ low_stock_threshold (Integer)

Table: Inventory_Movements (The Audit Log)
├─ id (UUID)
├─ product_id (Foreign Key -> Products)
├─ user_id (Foreign Key -> Users) -- Who did this?
├─ type (Enum: 'in', 'out', 'adjustment')
├─ quantity (Integer)
├─ reason (String - e.g., 'Sold to customer', 'Damaged')
└─ created_at (DateTime)
```

---

### Step 2: The Audit Log Pattern (Event Sourcing)

**Question: If `current_stock` is 48, how do you know *why* it's 48?**

**Bad Idea:** Just having a `Products` table where `current_stock` goes up and down. If a cashier steals 5 mice and simply updates `current_stock = 43`, you have no idea what happened or who did it.

**Good Idea:** Never change `current_stock` without simultaneously recording a row in the `Inventory_Movements` table. This is an **Audit Log**. Every single addition or subtraction must be permanently recorded, along with the ID of the user who performed it.

*(In highly advanced systems, `current_stock` isn't even stored. It is calculated on-the-fly by summing up all the movements! For this project, we will store `current_stock` but enforce that it can only be changed via a movement).*

---

### Step 3: Concurrency and Race Conditions

**Question: A cashier tries to sell the last 2 mice. At the exact same millisecond, another cashier tries to sell the last 2 mice. How do you prevent selling 4 mice when you only have 2?**

**Bad Idea (The Read-Modify-Write pattern):**
```javascript
// Cashier 1 reads: stock is 2
// Cashier 2 reads: stock is 2
const product = await db.query("SELECT current_stock FROM products WHERE id = 1");

if (product.current_stock >= 2) {
  // Both cashiers execute this update!
  await db.query("UPDATE products SET current_stock = current_stock - 2");
}
// Final stock is -2. You sold ghosts.
```

**Good Idea (Database Constraints & Atomic Updates):**
You must tell the database to NEVER allow stock to drop below zero.

1. **Schema Constraint:** Add `CHECK (current_stock >= 0)` to your SQL table.
2. **Atomic Update:** The database will instantly reject the second cashier's query if it would result in negative stock.

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Point of Sale (Cashier)              │  │
│  │ Receiving Dock (Warehouse)           │  │
│  │ Low Stock Dashboard (Manager)        │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP requests with JWT (RBAC)
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. RBAC (Manager vs Cashier)         │  │
│  │ 2. Stock Movement Engine (Atomic)    │  │
│  │ 3. Reporting Engine                  │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
┌────────────────────────────────────────────┐
│        Database (PostgreSQL/MySQL)         │
│  - products table (CHECK stock >= 0)       │
│  - inventory_movements table (Audit log)   │
└────────────────────────────────────────────┘
```
