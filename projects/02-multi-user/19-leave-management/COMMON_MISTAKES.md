## ⚠️ Common Mistakes

❌ **Mistake 1: Subtracting on Request Instead of Approval**
If you subtract the days from the balance immediately when the request is `pending`, and the manager Rejects it, you have to remember to add the days back. It's safer to only subtract upon `approval`. (However, to prevent over-requesting, you must check `days_remaining - sum(pending_days) > 0`).

❌ **Mistake 2: Counting Weekends**
If an employee requests Friday to Monday off, that is 2 working days, not 4. Your backend must have logic to skip Saturdays and Sundays when calculating `days_requested`.
