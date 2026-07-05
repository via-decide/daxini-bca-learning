# 💰 Payroll System API: API Design

**"Build a multi-user API where Admins define salary structures, Employees log daily hours, and the system automatically generates monthly payslips calculating gross pay, tax deductions, and net pay."**

---

## 🔗 API Endpoints

*(All routes require Authentication via JWT)*

**Admin Operations (Requires 'admin' role):**
```
PUT    /api/salary-configs/:userId → Set an employee's pay rate and tax bracket
POST   /api/payroll/run            → Generate payslips for a specific time period
GET    /api/reports/payroll        → View company-wide payroll expenses
```

**Employee Operations (Requires 'employee' role):**
```
POST   /api/timesheets         → Log hours worked for a specific day
GET    /api/timesheets/me      → View my logged hours
GET    /api/payslips/me        → View my generated payslips
GET    /api/payslips/:id/pdf   → (Optional) Download payslip PDF
```

---

## 📦 Request/Response Examples

### 1. Log Hours (Employee)

**Request:**
```json
POST /api/timesheets
{
  "work_date": "2026-10-15",
  "hours_worked": 8.5
}
```

**Response (201):**
```json
{
  "message": "Timesheet logged",
  "timesheet": {
    "id": "time-123",
    "date": "2026-10-15",
    "hours": 8.5,
    "status": "pending"
  }
}
```

### 2. Run Payroll (Admin)

This is a heavy endpoint that performs calculations and database transactions.

**Request:**
```json
POST /api/payroll/run
{
  "period_start": "2026-10-01",
  "period_end": "2026-10-31"
}
```

**Response (200):**
```json
{
  "message": "Payroll processed successfully",
  "summary": {
    "total_employees_processed": 45,
    "total_gross_pay_outflow": 150000.00,
    "total_tax_withheld": 30000.00,
    "total_net_pay_outflow": 120000.00
  }
}
```

### 3. View My Payslips (Employee)

**Request:**
```http
GET /api/payslips/me HTTP/1.1
```

**Response (200):**
```json
{
  "payslips": [
    {
      "id": "slip-999",
      "period": "Oct 01 - Oct 31, 2026",
      "total_hours": 160,
      "gross_pay": 4800.00,
      "tax_deducted": 960.00,
      "net_pay": 3840.00
    }
  ]
}
```

---

## ⚠️ Error Responses

```json
// 409 Conflict (Employee tries to log 26 hours in a single day)
{ "error": "Hours worked cannot exceed 24 in a single day." }

// 400 Bad Request (Admin runs payroll, but no one has pending timesheets)
{ "error": "No pending timesheets found for this period." }

// 403 Forbidden (Employee tries to view another employee's payslip)
{ "error": "You do not have permission to view this document." }
```
