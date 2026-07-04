## ⚠️ Common Mistakes

❌ **Mistake 1: Merging Invoice and Payment**
If you just have a `Rent` table with `due_date` and `paid_date`, you can't handle partial payments (e.g. paying half on the 1st, half on the 15th). You must separate the Invoice from the Payment.

❌ **Mistake 2: Floating Point Math for Rent**
As always with financial applications, DO NOT use `FLOAT`. Use `DECIMAL(10,2)` or integer cents, otherwise a tenant might owe `$0.0000000001` and the system will mark them as "Unpaid".
