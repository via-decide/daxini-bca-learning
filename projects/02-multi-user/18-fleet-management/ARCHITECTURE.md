# Fleet Management System (GPS Tracking)

## 🏗️ Architecture: Design Before Coding

**The Problem:**
A logistics company tracks 500 delivery trucks. Each truck pings its GPS location every 10 seconds. We need to know where they are *right now*, and the path they took *historically*.

**The Solution:**
Two separate concepts: A `Vehicles` table for the "Current State", and a `Location_Telemetry` time-series table for the "Historical Path". 

**Database Architecture:**
```text
Vehicles
├─ id
├─ license_plate
├─ current_lat (DECIMAL)
└─ current_lng (DECIMAL)
└─ last_ping_time (TIMESTAMP)

Location_Telemetry (High volume table)
├─ vehicle_id
├─ lat
├─ lng
└─ timestamp
```
