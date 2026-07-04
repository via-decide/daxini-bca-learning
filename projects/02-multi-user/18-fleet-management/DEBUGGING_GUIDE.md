## 🛠️ Debugging & Verification

**Test 1: Map Dashboard Performance**
- Insert 1 million fake rows into the telemetry table.
- Hit the GET `/api/vehicles/active` endpoint. It should read from the `vehicles` table and return instantly, unaffected by the 1M history rows.

**Test 2: Offline Detection**
- Write a cron job or a query: `SELECT * FROM vehicles WHERE last_ping_time < NOW() - INTERVAL '5 minutes'`. This correctly identifies trucks that have lost signal.
