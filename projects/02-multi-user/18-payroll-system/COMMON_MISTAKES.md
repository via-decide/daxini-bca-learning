# 💰 Payroll System API: Learn By Building

**"Build a multi-user API where Admins define salary structures, Employees log daily hours, and the system automatically generates monthly payslips calculating gross pay, tax deductions, and net pay."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Relying on Dates instead of State

**Wrong:**
```javascript
// To find unpaid hours, fetching everything from the previous month
const unpaidTimesheets = await db.query(
  "SELECT * FROM timesheets WHERE work_date >= '2026-10-01' AND work_date <= '2026-10-31'"
);
```
*Why it's bad:* What if the employee worked on Oct 31st, but forgot to log it until Nov 2nd? When you ran payroll on Nov 1st, those hours were missed. When you run payroll on Dec 1st (for November), the Oct 31st hours will be ignored because they fall outside the November date range. The employee just lost a day of pay.

**Right:**
Use a State Machine (`status = 'pending'`). Just grab ALL pending timesheets, regardless of their date, up to the cutoff point.

### ❌ Mistake 2: Dynamic Calculation of Past Data

**Wrong:**
```javascript
// Fetching a past payslip and calculating the total on the fly
app.get('/api/payslips/:id', async (req, res) => {
  const user = await db.query("SELECT hourly_rate FROM salary_configs WHERE user_id = ?", req.user.id);
  const payslip = await db.query("SELECT total_hours FROM payslips WHERE id = ?", req.params.id);
  
  // Calculating gross pay RIGHT NOW
  res.send({ gross_pay: payslip.total_hours * user.hourly_rate }); 
});
```
*Why it's bad:* If the user got a raise in December, their October payslip will suddenly show the new higher rate, falsifying their financial history.

**Right:**
Calculate it once during generation, save the final `gross_pay` value into the `payslips` table permanently, and just read that static number forever.

### ❌ Mistake 3: Floating Point Financial Math

**Wrong:**
```javascript
const taxDeducted = grossPay * 0.15; // Javascript Float math
```
*Why it's bad:* `0.1 + 0.2 === 0.30000000000000004`. Over thousands of payslips, these micro-penny errors accumulate, causing your ledgers to fail audits.

**Right:**
Use a specialized Decimal library (like `decimal.js` in Node), or cast all currency to Integers (cents) before doing math.

---
