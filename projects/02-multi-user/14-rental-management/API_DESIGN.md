## 🔌 API Design: Plan Before Coding

### 1. Log Payment
**POST `/api/invoices/:id/pay`**
- **Body**: `{ "amount": 1000.00 }`
- **Logic**: 
  1. Insert into `payments`.
  2. Sum all payments for this invoice.
  3. If Sum(payments) >= `amount_due`, UPDATE `invoices` SET `status` = 'paid'.

### 2. Get Outstanding Balances
**GET `/api/landlord/outstanding`**
- **Logic**: Return all invoices where `status` != 'paid' and `due_date` < CURRENT_DATE.
