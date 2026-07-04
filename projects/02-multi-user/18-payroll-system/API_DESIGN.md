## 🔌 API Design: Plan Before Coding

### 1. Generate Monthly Payslips (Batch Job)
**POST `/api/payroll/run-monthly`**
- **Logic**: 
  1. Fetch all active employees and their `annual_base_salary`.
  2. Gross = Base / 12.
  3. Calculate Tax (e.g. 20% of Gross).
  4. Net = Gross - Tax.
  5. Insert into `Payslips` and `Payslip_Line_Items`.

### 2. View Payslip
**GET `/api/payslips/:id`**
- **Logic**: Return the Payslip and JOIN all Line Items so the frontend can render a PDF.
