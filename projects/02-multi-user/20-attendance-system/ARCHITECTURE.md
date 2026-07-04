# Attendance & Time-clock System

## 🏗️ Architecture: Design Before Coding

**The Problem:**
Factory workers punch in and punch out daily. The company needs to know exactly how many hours were worked to run payroll. Sometimes workers forget to punch out.

**The Solution:**
A time-series ledger of `Punch_Records`. A separate calculated table or query that pairs the IN and OUT punches to calculate `hours_worked`.

**Database Architecture:**
```text
Daily_Attendance
├─ id
├─ employee_id
├─ date (DATE)
├─ punch_in (TIMESTAMP)
├─ punch_out (TIMESTAMP, Nullable)
└─ total_hours (DECIMAL, Calculated on punch out)
```
