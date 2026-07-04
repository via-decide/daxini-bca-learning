## ⚠️ Common Mistakes

❌ **Mistake 1: Calculating Net Pay on the Fly**
If you don't store a snapshot in the `Payslips` table, and instead just write a query that says `(annual_salary / 12) - taxes` on the fly, what happens when the employee gets a raise next year? All their historical payslips from last year will suddenly recalculate and show the new higher amount. Payslips must be frozen snapshots.

❌ **Mistake 2: Rounding errors**
Never round intermediate steps. Only round the final Net Pay, otherwise you will lose cents in the process.
