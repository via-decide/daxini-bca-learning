# 🏠 Property Rental Management System: Learn By Building

**"Build a multi-user API for a real estate agency where Landlords list properties, Tenants apply for leases, and the system tracks monthly rent payments and arrears."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Not using Database Transactions

**Wrong:**
```javascript
app.put('/api/leases/:id/approve', async (req, res) => {
  // 1. Update the lease
  await db.query("UPDATE leases SET status = 'active' WHERE id = ?", req.params.id);
  
  // What if the server crashes right here?
  
  // 2. Make the property unavailable
  await db.query("UPDATE properties SET is_available = 0 WHERE id = ?", propertyId);
});
```
*Why it's bad:* If the server crashes between step 1 and 2, you have an active tenant, but the property still says it's available. Another tenant can apply and get approved. You just rented one apartment to two different people.

**Right:**
Wrap both queries in a `BEGIN TRANSACTION` and `COMMIT`. If anything fails, it rolls back automatically.

### ❌ Mistake 2: Missing the Ledger Table

**Wrong:**
```sql
CREATE TABLE leases (
  id TEXT,
  total_rent_owed DECIMAL,
  total_rent_paid DECIMAL
);
```
*Why it's bad:* The landlord asks, "Did Tom pay his rent in January?" You have no idea. You only have a single running total.

**Right:**
Use a ledger table (`rent_payments`). Every single month, a new invoice row is generated. Every time a payment is made, that specific row is updated. This creates an unchangeable financial history.

### ❌ Mistake 3: Storing Money as Floats

**Wrong:**
```sql
CREATE TABLE rent_payments ( amount_due FLOAT );
```
*Why it's bad:* Standard computers cannot perfectly represent decimals in binary. Try typing `0.1 + 0.2` in a Node.js console. You will get `0.30000000000000004`. If you sum thousands of float transactions, your accounting will be off, which is illegal in many jurisdictions.

**Right:**
Use strict decimals: `DECIMAL(10,2)`. Or better yet, store cents as an Integer (e.g., $1500.00 is `150000`).

---
