## 🛠️ Debugging & Verification

**Test 1: Snapshot Integrity**
- Generate a payslip for John ($120k/yr). Net pay should be $10k.
- Update John's contract to $240k/yr.
- Fetch the old payslip. It MUST STILL SAY $10k.

**Test 2: Ledger Math**
- Ensure `Gross Pay + Additions - Deductions` exactly equals the `Net Pay` column.
