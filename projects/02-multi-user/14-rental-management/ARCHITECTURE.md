# 🏠 Property Rental Management System: Learn By Building

**"Build a multi-user API for a real estate agency where Landlords list properties, Tenants apply for leases, and the system tracks monthly rent payments and arrears."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. Landlord Lisa lists an apartment for $1500/month.
2. Tenant Tom applies for it. Lisa approves the lease starting Oct 1st.
3. On Oct 1st, a rent invoice of $1500 is generated.
4. On Oct 5th, Tom pays $1500.
5. On Nov 1st, a new rent invoice is generated. Tom hasn't paid yet. The system shows him in arrears.

**What data do you need for each?**

After thinking, here's the data model:

```
Table: Users (Landlords & Tenants)
├─ id (UUID)
├─ email (String)
├─ password_hash (String)
└─ role (Enum: 'landlord', 'tenant')

Table: Properties
├─ id (UUID)
├─ landlord_id (Foreign Key -> Users)
├─ address (String)
├─ monthly_rent (Decimal)
└─ is_available (Boolean)

Table: Leases
├─ id (UUID)
├─ property_id (Foreign Key -> Properties)
├─ tenant_id (Foreign Key -> Users)
├─ start_date (Date)
├─ end_date (Date)
└─ status (Enum: 'pending', 'active', 'terminated')

Table: Rent_Payments (The Ledger)
├─ id (UUID)
├─ lease_id (Foreign Key -> Leases)
├─ amount_due (Decimal)
├─ amount_paid (Decimal - Default 0)
├─ due_date (Date)
└─ status (Enum: 'unpaid', 'partial', 'paid')
```

---

### Step 2: The "Monthly Invoice" Problem

**Question: How do you know Tom owes $1500 on November 1st?**

**Bad Idea:** Hoping the landlord remembers to log in and click "Send Invoice" every single month.

**Good Idea:** A Background Worker (Cron Job).
A script runs on the server every day at midnight. It looks for all `active` leases where today is the anniversary of their `start_date` (e.g., the 1st of the month), and automatically inserts a new row into the `Rent_Payments` table.

---

### Step 3: Complex Aggregation (Calculating Arrears)

When a landlord looks at their dashboard, they want to know exactly how much money a tenant owes them in total.

**Bad Idea:** Fetching all 24 months of payment history into Node.js and running a `for` loop.

**Good Idea:** Use SQL to calculate the exact difference between what was due and what was paid.

```sql
SELECT 
  SUM(amount_due) - SUM(amount_paid) as total_arrears
FROM rent_payments
WHERE lease_id = 'lease-123' AND status != 'paid';
```

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Tenant Portal (Pay Rent, Apply)      │  │
│  │ Landlord Dashboard (Arrears Report)  │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP requests with JWT (RBAC)
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. Lease State Machine               │  │
│  │ 2. Payment Ledger Validation         │  │
│  │ 3. Cron Job Worker (Auto-Invoicing)  │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
┌────────────────────────────────────────────┐
│        Database (PostgreSQL/MySQL)         │
│  - users, properties, leases, payments     │
└────────────────────────────────────────────┘
```
