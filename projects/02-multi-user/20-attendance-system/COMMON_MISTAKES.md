## ⚠️ Common Mistakes

❌ **Mistake 1: Trusting Client Time**
Never accept `{ "punch_in_time": "08:00 AM" }` from the mobile app. The employee can change their phone's clock. Always use `CURRENT_TIMESTAMP` on the server when the request arrives.

❌ **Mistake 2: Forgetting to close open shifts**
If an employee forgets to punch out on Tuesday, their `punch_out` is NULL. On Wednesday, the payroll math will crash. You need a daily cron job that auto-closes open shifts at midnight (setting total_hours to 0 or flagging it for manager review).
