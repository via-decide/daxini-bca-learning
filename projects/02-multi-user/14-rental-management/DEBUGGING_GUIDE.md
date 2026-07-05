# 🏠 Property Rental Management System: Learn By Building

**"Build a multi-user API for a real estate agency where Landlords list properties, Tenants apply for leases, and the system tracks monthly rent payments and arrears."**

---

## 🧪 Testing Scenarios

### Scenario 1: The Transaction Rollback (Lease Approval)

```
1. Create a Property (is_available = true).
2. Create a pending Lease for that Property.
3. Call `PUT /api/leases/:id/approve`.
4. Inside your code, purposefully throw a Javascript Error *after* the Lease status is updated, but *before* the Property `is_available` is set to false.
5. Expected: Both changes should ROLLBACK. The DB must show Lease = 'pending' and Property = true. If they are out of sync, your transaction logic is broken.
```

### Scenario 2: The Double Application

```
1. Tenant A applies for Property 1. (Lease status: pending).
2. Tenant B applies for Property 1. (Lease status: pending).
3. Landlord approves Tenant A's lease. (Property is_available -> false).
4. Landlord attempts to approve Tenant B's lease.
5. Expected: Server MUST reject it (409 Conflict). You cannot approve a lease for a property that is no longer available.
```

### Scenario 3: The Partial Payment Ledger

```
1. System generates a $1000 invoice (`amount_due = 1000`, `amount_paid = 0`, `status = unpaid`).
2. Tenant pays $400.
3. Expected: `amount_paid` updates to 400. `status` updates to `partial`.
4. Tenant pays $600.
5. Expected: `amount_paid` updates to 1000. `status` updates to `paid`.
6. Tenant tries to pay $10.
7. Expected: Server MUST reject it (400 Bad Request). The `CHECK (amount_paid <= amount_due)` constraint in the DB should also catch this.
```

### Scenario 4: The Arrears Calculation

```
1. Create 3 rent invoices for a Tenant:
   - Month 1: Due $1000, Paid $1000 (status: paid)
   - Month 2: Due $1000, Paid $200 (status: partial)
   - Month 3: Due $1000, Paid $0 (status: unpaid)
2. Landlord calls `GET /api/reports/arrears`.
3. Expected calculation: (1000-1000) + (1000-200) + (1000-0) = 0 + 800 + 1000 = 1800.
4. Expected: The API must return `$1800` total owed for this tenant.
```

---
