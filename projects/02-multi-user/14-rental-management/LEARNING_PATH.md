# 🏠 Property Rental Management System: Learn By Building

**"Build a multi-user API for a real estate agency where Landlords list properties, Tenants apply for leases, and the system tracks monthly rent payments and arrears."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Database Transactions** - Guaranteeing that two related actions (Approve Lease + Mark Property Unavailable) happen together or not at all.  
✅ **Financial Ledgers** - Tracking state over time (`unpaid` -> `partial` -> `paid`) rather than just overwriting a single number.  
✅ **Cron Jobs (Background Workers)** - Writing scripts that run automatically based on time (e.g., generating invoices on the 1st of the month) without requiring a user request.  
✅ **Advanced SQL Aggregation** - Using `SUM()` with math (`SUM(due) - SUM(paid)`) across joined tables to generate financial reports.

---

## 📋 Project Overview

### The Problem

A rental platform is essentially a contract and financial ledger system. 

When a contract (Lease) is signed, multiple things must happen simultaneously: The tenant gets the lease, and the property must instantly be removed from the market. If this is not done atomically, you risk double-renting a property.

Furthermore, rent isn't a one-time payment. It's a recurring obligation. The system must automatically "wake up" every month and bill the tenant. Finally, Landlords need a way to instantly see exactly who is behind on rent without manually doing math.

**Your job:** Build a transactional API that safely manages leases and uses background workers and SQL aggregation to handle finances.

### Who Uses It

```
Landlord:
├─ POST /api/properties (Lists an apartment)
├─ PUT /api/leases/:id/approve (Approves a tenant)
└─ GET /api/reports/arrears (Sees who owes money)

Tenant:
├─ POST /api/leases (Applies for an apartment)
└─ POST /api/payments/:id (Pays their monthly invoice)
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. The Transaction (Approving a Lease)

```pseudocode
PUT /api/leases/:id/approve:
  middlewares: [authenticateUser, requireRole(['landlord'])]
  lease_id = request.params.id
  
  // 1. Start the Transaction
  db.execute("BEGIN TRANSACTION")
  
  try:
    // 2. Verify ownership and state
    lease = db.query(`
      SELECT l.property_id, p.is_available 
      FROM leases l JOIN properties p ON l.property_id = p.id
      WHERE l.id = ? AND p.landlord_id = ?
    `, [lease_id, req.user.id])
    
    if !lease: throw Error("Not found or unauthorized")
    if !lease.is_available: throw Error("Property already rented")
    
    // 3. Mark the Lease as Active
    db.query("UPDATE leases SET status = 'active' WHERE id = ?", lease_id)
    
    // 4. Mark the Property as Unavailable
    db.query("UPDATE properties SET is_available = 0 WHERE id = ?", lease.property_id)
    
    // 5. Commit! Both queries succeeded.
    db.execute("COMMIT")
    return 200 "Lease approved"
    
  catch (error):
    db.execute("ROLLBACK")
    return 400 error.message
```

### 2. The Auto-Invoicing Cron Job

This is a separate script (often run using a library like `node-cron`) that runs once a day. It DOES NOT rely on a user HTTP request.

```pseudocode
// Runs every day at 00:01 AM
function generateMonthlyInvoices() {
  // Find all active leases
  leases = db.query("SELECT * FROM leases WHERE status = 'active'")
  
  for lease in leases:
    // Is today the day they need to pay? (Simplified logic)
    if isAnniversaryDay(lease.start_date, today()):
      
      // Get the rent amount from the property
      property = db.query("SELECT monthly_rent FROM properties WHERE id = ?", lease.property_id)
      
      // Generate the invoice!
      db.query(`
        INSERT INTO rent_payments (id, lease_id, amount_due, due_date)
        VALUES (UUID(), ?, ?, CURRENT_DATE)
      `, [lease.id, property.monthly_rent])
}
```

### 3. The Arrears Report (SQL Math)

The Landlord wants to know who owes them money. Let the database do the work.

```pseudocode
GET /api/reports/arrears:
  middlewares: [authenticateUser, requireRole(['landlord'])]
  
  // We want to sum the difference between amount_due and amount_paid
  // We join Payments -> Leases -> Properties -> Users (Tenants)
  report = db.query(`
    SELECT 
      u.full_name as tenant_name,
      p.address,
      SUM(rp.amount_due) - SUM(rp.amount_paid) as total_owed,
      COUNT(rp.id) as unpaid_months
    FROM rent_payments rp
    JOIN leases l ON rp.lease_id = l.id
    JOIN properties p ON l.property_id = p.id
    JOIN users u ON l.tenant_id = u.id
    WHERE p.landlord_id = ? 
      AND rp.status != 'paid'
    GROUP BY u.id, p.id
    HAVING total_owed > 0
  `, req.user.id)
  
  // Calculate total outstanding across all properties
  total_outstanding = report.reduce((sum, row) => sum + row.total_owed, 0)
  
  return 200 { total_outstanding, tenants_in_arrears: report }
```

---

## ✅ Before Submission

- [ ] System supports Landlord and Tenant roles.
- [ ] Approving a lease is a Database Transaction that also marks the property as unavailable.
- [ ] Financial data uses precise Decimals or Integers, not Floats.
- [ ] The `rent_payments` table tracks partial payments accurately with DB `CHECK` constraints.
- [ ] The Arrears report uses SQL aggregation (`SUM`, `GROUP BY`) to calculate debts dynamically.
- [ ] Code is on GitHub.

**Success:** You have built a transactional financial system!
