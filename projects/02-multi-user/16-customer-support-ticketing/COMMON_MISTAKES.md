## ⚠️ Common Mistakes

❌ **Mistake 1: Storing comments as an array in the Ticket row**
Don't use `JSONB` for an open-ended conversation thread. If a ticket goes on for 500 messages, pulling the whole JSON object, appending, and saving it will cause massive race conditions and slow down the DB. Use a separate `Ticket_Comments` table.

❌ **Mistake 2: Missing Concurrent Claim Protection**
Agent A and Agent B both look at the "Unassigned" queue. Both click "Claim" at the same time. If you just run `UPDATE tickets SET assignee = X`, whoever clicked last wins. You MUST use `WHERE assignee_id IS NULL` in the update.
