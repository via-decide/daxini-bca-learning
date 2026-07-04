## 🔌 API Design: Plan Before Coding

### 1. Adjust Stock
**POST `/api/inventory/adjust`**
- **Body**: `{ "product_id": "123", "change": -5, "reason": "Sale" }`
- **Logic**: Use a Database Transaction. 
  1. Insert into `inventory_transactions`.
  2. Update `products.current_stock = current_stock + change`.
  3. If `current_stock < 0`, Rollback and throw error!
  4. If `current_stock < low_stock_threshold`, queue an alert email.
