## 🛠️ Debugging & Verification

**Test 1: Weekend Math**
- Pass a start date of Thursday and end date of Tuesday. The `days_requested` should be calculated as 4, not 6.

**Test 2: Overdraft Prevention**
- Balance is 5 days.
- Request 6 days. Must fail.
- Request 4 days. Succeeds (Pending).
- Request 2 days. Must fail (because 4 pending + 2 requested > 5 remaining).
