# 📦 Inventory Management System: API Design

**"Build a multi-user inventory API where warehouse staff receive stock, cashiers deduct stock via sales, and managers view real-time low-stock alerts, using database transactions to prevent negative inventory."**

---

## 🔗 API Endpoints

*(All routes require Authentication via JWT)*

**Product Management (Requires 'manager' role):**
```
POST   /api/products           → Create a new product in the catalog
PUT    /api/products/:id       → Update product details (price, threshold)
```

**Inventory Movements (The Core Logic):**
```
POST   /api/inventory/receive  → Add stock (Requires 'warehouse' or 'manager')
POST   /api/inventory/sell     → Deduct stock (Requires 'cashier' or 'manager')
```

**Analytics & Reporting (Read-Only):**
```
GET    /api/products                 → List all products with current stock
GET    /api/products/low-stock       → List only products where stock <= threshold
GET    /api/products/:id/movements   → View the audit log for a specific product
```

---

## 📦 Request/Response Examples

### 1. Receive Stock (Warehouse)

**Request:**
```json
POST /api/inventory/receive
{
  "product_id": "prod-123",
  "quantity": 50,
  "reason": "Restock from Supplier A"
}
```

**Response (200):**
```json
{
  "message": "Stock received successfully",
  "product": {
    "id": "prod-123",
    "name": "Wireless Mouse",
    "previous_stock": 2,
    "new_stock": 52
  }
}
```

### 2. Sell Stock (Cashier)

**Request:**
```json
POST /api/inventory/sell
{
  "product_id": "prod-123",
  "quantity": 2,
  "reason": "Retail Sale - Invoice #998"
}
```

**Response (200):**
```json
{
  "message": "Sale recorded successfully",
  "product": {
    "id": "prod-123",
    "new_stock": 50
  }
}
```

### 3. Fetch Low Stock Alerts (Manager)

**Request:**
```http
GET /api/products/low-stock HTTP/1.1
```

**Response (200):**
```json
{
  "alerts_count": 2,
  "products": [
    {
      "id": "prod-888",
      "sku": "KB-MCH-01",
      "name": "Mechanical Keyboard",
      "current_stock": 4,
      "low_stock_threshold": 10
    },
    {
      "id": "prod-999",
      "sku": "MON-4K-27",
      "name": "27-inch 4K Monitor",
      "current_stock": 0,
      "low_stock_threshold": 5
    }
  ]
}
```

---

## ⚠️ Error Responses

```json
// 403 Forbidden (A cashier tries to receive stock or create a product)
{ "error": "You do not have permission to perform this action." }

// 409 Conflict (A cashier tries to sell 5 items, but only 3 are left)
{ "error": "Insufficient stock. Only 3 items available." }

// 400 Bad Request (Validation failure)
{ "error": "Quantity must be a positive integer greater than zero." }
```
