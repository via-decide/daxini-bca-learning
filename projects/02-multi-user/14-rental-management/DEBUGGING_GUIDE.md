## 🛠️ Debugging & Verification

**Test 1: Partial Payments**
- Generate a $1000 invoice.
- Log a $400 payment. Invoice status should remain `unpaid` (or `partial`).
- Log a $600 payment. Invoice status MUST flip to `paid`.

**Test 2: Overdue Status**
- Write a cron script (or an API endpoint that simulates it) that runs daily, checks all `unpaid` invoices where `due_date` is in the past, and flips them to `overdue`.
