# 💰 Payroll System API: Learn By Building

**"Build a multi-user API where Admins define salary structures, Employees log daily hours, and the system automatically generates monthly payslips calculating gross pay, tax deductions, and net pay."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Financial Immutability** - Storing derived values (like Gross Pay) permanently as snapshots, rather than calculating them dynamically, to preserve historical accuracy.  
✅ **Database Transactions** - Grouping multiple inserts and updates (aggregating timesheets, generating payslips, marking timesheets paid) into a single atomic operation.  
✅ **State-Based Processing** - Using `pending` and `processed` statuses rather than strict date ranges to ensure no data is missed or processed twice.

---

## 📋 Project Overview

### The Problem

Payroll is a high-stakes data aggregation problem. If you double-pay someone, the company loses money. If you underpay someone, it's a legal issue.

The biggest challenge is handling the transition from "Raw Data" (Timesheets) to a "Finalized Document" (Payslip). This requires moving multiple rows from `pending` to `processed` exactly at the moment the Payslip is created. If the database connection drops halfway through, you must roll everything back.

**Your job:** Build a bulletproof transaction script that safely aggregates pending hours, applies current tax logic, generates a permanent snapshot (Payslip), and updates the timesheets so they can never be processed again.

### Who Uses It

```
Employee:
├─ POST /api/timesheets (Logs their hours)
└─ GET /api/payslips/me (Downloads their check)

Admin:
├─ PUT /api/salary-configs/:id (Sets the rules)
└─ POST /api/payroll/run (Generates the money)
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. Safely Logging Hours (The UNIQUE constraint)

To prevent an employee from submitting 8 hours, and then accidentally submitting another 8 hours for the exact same day, we rely on the `UNIQUE (user_id, work_date)` constraint in the database.

```pseudocode
POST /api/timesheets:
  middlewares: [authenticateUser, requireRole(['employee'])]
  
  try:
    db.query(`
      INSERT INTO timesheets (id, user_id, work_date, hours_worked)
      VALUES (UUID(), ?, ?, ?)
    `, [req.user.id, request.body.work_date, request.body.hours_worked])
    
    return 201 "Timesheet logged."
    
  catch (error):
    if isUniqueViolation(error):
      return 409 "You have already logged hours for this date. Use PUT to update."
```

### 2. The Payroll Generator (The Massive Transaction)

This is the core of the app. It must be wrapped in a transaction.

```pseudocode
POST /api/payroll/run:
  middlewares: [authenticateUser, requireRole(['admin'])]
  
  // Start the atomic block
  db.execute("BEGIN TRANSACTION")
  
  try:
    // 1. Get ALL employees and their configs
    configs = db.query("SELECT * FROM salary_configs")
    
    for config in configs:
      // 2. Find their PENDING timesheets
      timesheets = db.query(`
        SELECT id, hours_worked FROM timesheets 
        WHERE user_id = ? AND status = 'pending'
      `, config.user_id)
      
      if timesheets.length === 0:
        continue // Skip, they didn't work
        
      // 3. Do the Math
      total_hours = sum(timesheets.map(t => t.hours_worked))
      gross_pay = total_hours * config.hourly_rate
      tax_deducted = gross_pay * config.tax_percentage
      net_pay = gross_pay - tax_deducted
      
      payslip_id = UUID()
      
      // 4. Create the Permanent Snapshot
      db.query(`
        INSERT INTO payslips 
        (id, user_id, period_start, period_end, total_hours, hourly_rate_applied, gross_pay, tax_deducted, net_pay)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
      `, [payslip_id, config.user_id, req.body.start, req.body.end, total_hours, config.hourly_rate, gross_pay, tax_deducted, net_pay])
      
      // 5. UPDATE the timesheets to PROCESSED so they are never paid again
      // We explicitly update only the specific IDs we fetched in step 2.
      timesheet_ids = timesheets.map(t => t.id)
      
      db.query(`
        UPDATE timesheets 
        SET status = 'processed', payslip_id = ?
        WHERE id IN (?)
      `, [payslip_id, timesheet_ids])
      
    // 6. If we get here without throwing an error, commit it all!
    db.execute("COMMIT")
    return 200 "Payroll Run Complete"
    
  catch (error):
    db.execute("ROLLBACK")
    return 500 "Payroll failed. No records were changed."
```

---

## ✅ Before Submission

- [ ] System separates Admin and Employee roles.
- [ ] Employees cannot log multiple timesheets for the exact same date.
- [ ] The Payroll Run endpoint uses a `BEGIN TRANSACTION` and `COMMIT` block.
- [ ] Timesheets use a `status` column (`pending` -> `processed`) to prevent double-payment.
- [ ] Payslips store hardcoded financial values (`gross_pay`), ensuring past payslips are unaffected by future salary changes.
- [ ] Code is on GitHub.

**Success:** You have built an enterprise-grade financial processor!
