## ⚠️ Common Mistakes

❌ **Mistake 1: Storing standard rates**
If you put `hourly_rate` on the `Users` table, a tutor can only charge one rate for everything. If you put it on the `Subjects` table, every tutor must charge the exact same amount for Calculus. It MUST go on the `Tutor_Subjects` join table.

❌ **Mistake 2: Calculating Price on the Client**
Never let the frontend tell you `total_price: 50.00` in the booking POST request. The backend must independently query the database for the rate and multiply by the duration.
