# 📦 Inventory Management System: Learn By Building

**"Build a multi-user inventory API where warehouse staff receive stock, cashiers deduct stock via sales, and managers view real-time low-stock alerts, using database transactions to prevent negative inventory."**

---

## 🧪 Testing Scenarios

### Scenario 1: The Race Condition (Negative Stock Test)

```
1. Create a Product with exactly `2` stock.
2. Have two separate Postman instances ready (or write a quick Javascript `Promise.all` script).
3. Send two `POST /api/inventory/sell` requests for a quantity of `2`, at the exact same millisecond.
4. Expected: ONE request should succeed (200 OK). The OTHER request MUST fail with a 409 Conflict (or 500 DB error).
5. Verify: Check the database. The `current_stock` MUST be `0`. If it is `-2`, your system has failed.
```

### Scenario 2: The Audit Log Integrity Test

```
1. Get the current stock of a Product (e.g., 50).
2. Count the sum of its movements in the DB: `SELECT SUM(CASE WHEN type='in' THEN quantity WHEN type='out' THEN -quantity ELSE 0 END) FROM inventory_movements WHERE product_id = ?`.
3. Expected: The calculation MUST exactly equal `50`.
4. Run a `sell` transaction for `5` items.
5. Expected: The new `current_stock` is `45`. The sum of movements MUST also exactly equal `45`.
```

### Scenario 3: Role-Based Access Control (RBAC)

```
1. Login as a Cashier. Copy JWT.
2. Attempt to `POST /api/products` to create a new Product.
3. Expected: Server MUST reject with 403 Forbidden. Only Managers can create products.
4. Attempt to `POST /api/inventory/receive` to add stock.
5. Expected: Server MUST reject with 403 Forbidden. Cashiers can only sell stock, not receive it.
```

### Scenario 4: The Low Stock Alert

```
1. Create a Product with `current_stock: 15` and `low_stock_threshold: 10`.
2. GET `/api/products/low-stock`.
3. Expected: The product MUST NOT appear in the list.
4. Sell 6 items (Stock drops to 9).
5. GET `/api/products/low-stock`.
6. Expected: The product MUST appear in the list.
```

---
