# 🏠 Property Rental Management System: API Design

**"Build a multi-user API for a real estate agency where Landlords list properties, Tenants apply for leases, and the system tracks monthly rent payments and arrears."**

---

## 🔗 API Endpoints

*(All routes require Authentication via JWT)*

**Landlord Operations (Requires 'landlord' role):**
```
POST   /api/properties         → List a new property
GET    /api/properties/me      → View my properties and their status
PUT    /api/leases/:id/approve → Approve a tenant's lease application
GET    /api/reports/arrears    → View all tenants who owe money
```

**Tenant Operations (Requires 'tenant' role):**
```
GET    /api/properties         → Browse available properties
POST   /api/leases             → Apply for a property
GET    /api/leases/me          → View my active lease
POST   /api/payments/:id       → Pay a specific rent invoice
```

---

## 📦 Request/Response Examples

### 1. Apply for a Lease (Tenant)

**Request:**
```json
POST /api/leases
{
  "property_id": "prop-123",
  "start_date": "2026-11-01",
  "duration_months": 12
}
```

**Response (201):**
```json
{
  "message": "Lease application submitted to landlord",
  "lease": {
    "id": "lease-999",
    "status": "pending"
  }
}
```

### 2. Pay Rent (Tenant)

**Request:**
```json
POST /api/payments/pay-777
{
  "amount": 1500.00
}
```

**Response (200):**
```json
{
  "message": "Payment recorded successfully",
  "payment": {
    "id": "pay-777",
    "amount_due": 1500.00,
    "amount_paid": 1500.00,
    "status": "paid"
  }
}
```

### 3. Generate Arrears Report (Landlord)

The backend calculates exactly who owes what by summing the ledger.

**Request:**
```http
GET /api/reports/arrears HTTP/1.1
```

**Response (200):**
```json
{
  "total_outstanding": 2500.00,
  "tenants_in_arrears": [
    {
      "tenant_name": "Tom Smith",
      "property_address": "123 Main St, Apt 4B",
      "total_owed": 1500.00,
      "unpaid_months": 1
    },
    {
      "tenant_name": "Alice Johnson",
      "property_address": "456 Oak Rd",
      "total_owed": 1000.00,
      "unpaid_months": 2
    }
  ]
}
```

---

## ⚠️ Error Responses

```json
// 409 Conflict (Tenant applies for a property that already has an 'active' lease)
{ "error": "This property is no longer available." }

// 400 Bad Request (Tenant tries to pay $2000 on a $1500 invoice)
{ "error": "Payment amount exceeds the amount due." }

// 403 Forbidden (Landlord tries to approve a lease for a property they don't own)
{ "error": "You do not have permission to manage this property." }
```
