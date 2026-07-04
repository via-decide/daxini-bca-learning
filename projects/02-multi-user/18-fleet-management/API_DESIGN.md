## 🔌 API Design: Plan Before Coding

### 1. Ingest GPS Ping
**POST `/api/telemetry/ping`**
- **Logic**: 
  1. `UPDATE vehicles SET current_lat = X, current_lng = Y, last_ping_time = NOW()`
  2. `INSERT INTO location_telemetry`

### 2. Replay Route
**GET `/api/vehicles/:id/route?date=2024-10-10`**
- **Logic**: `SELECT lat, lng, recorded_at FROM location_telemetry WHERE vehicle_id = X AND DATE(recorded_at) = Y ORDER BY recorded_at ASC`.
