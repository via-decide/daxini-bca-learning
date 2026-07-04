# Rental Management (Landlord App)

## 🏗️ Architecture: Design Before Coding

**The Problem:**
A landlord owns 10 properties. Tenants pay rent monthly. Sometimes they pay late. The landlord needs to know exactly who owes what, and maintain a history of payments.

**The Solution:**
A `Leases` table connects Tenants to Properties. A `Rent_Invoices` table is generated monthly (usually by a cron job), and a `Payments` table tracks when the tenant actually paid the invoice.

**Database Architecture:**
```text
Properties
├─ id
├─ address
└─ monthly_rent (DECIMAL)

Leases
├─ id
├─ property_id
├─ tenant_id
├─ start_date
└─ end_date

Invoices (Generated monthly)
├─ id
├─ lease_id
├─ due_date
├─ amount_due
└─ status (ENUM: Unpaid, Paid, Overdue)

Payments
├─ id
├─ invoice_id
├─ amount_paid
└─ payment_date
```
