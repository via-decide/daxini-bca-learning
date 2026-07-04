## ⚠️ Common Mistakes

❌ **Mistake 1: Querying the Telemetry table to find current locations**
If you want to show all 500 trucks on a map, do NOT run `SELECT * FROM location_telemetry ORDER BY time DESC LIMIT 1` for each truck. The telemetry table will have millions of rows. It will crash. This is why the `Vehicles` table caches the `current_lat`/`lng`.

❌ **Mistake 2: Missing Index on Time-Series Data**
If you don't index `(vehicle_id, recorded_at)`, replaying a route for a truck will require a full table scan across millions of pings.
