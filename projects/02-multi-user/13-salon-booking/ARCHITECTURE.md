# Salon Booking System

## 🏗️ Architecture: Design Before Coding

**The Problem:**
Unlike a clinic where a doctor has uniform 30-minute slots, a Salon has services of varying lengths. A Haircut takes 30 mins, but a Hair Coloring takes 120 mins. How do you prevent overlap when durations are dynamic?

**The Solution:**
Use `OVERLAPS` or start/end boundary checks. You no longer have discrete "slots", you have contiguous blocks of time on a stylist's calendar.

**Database Architecture:**
```text
Services
├─ id
├─ name
├─ duration_minutes (INT)
└─ price (DECIMAL)

Stylists
├─ id
└─ name

Appointments
├─ id
├─ stylist_id
├─ customer_id
├─ service_id
├─ start_time (TIMESTAMP)
└─ end_time (TIMESTAMP) -- Calculated from start_time + duration
```
