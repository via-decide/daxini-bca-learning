## ⚠️ Common Mistakes

❌ **Mistake 1: Relying on the Client's Clock**
If the frontend sends `{ "start_time": "10:00AM" }`, users can spoof it to bill more hours. ALWAYS use the server's clock (`NOW()`) when a start/stop request is received.

❌ **Mistake 2: Missing Timezones**
Storing time as "2024-10-10 09:00:00" without a timezone means a user in India and a user in New York will have hopelessly corrupted reporting data. Always use UTC.
