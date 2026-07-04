## 🔌 API Design: Plan Before Coding

### 1. Start Timer
**POST `/api/time-entries/start`**
- **Logic**: Ensure the user doesn't already have a timer running with `end_time = NULL`.

### 2. Stop Timer
**POST `/api/time-entries/stop`**
- **Logic**: Find the user's active timer (where `end_time = NULL`) and update it to `NOW()`.

### 3. Generate Invoice
**GET `/api/reports/invoice?project_id=123&month=2024-10`**
- **Logic**: `SELECT SUM(EXTRACT(EPOCH FROM (end_time - start_time))) / 3600 * project.rate`
