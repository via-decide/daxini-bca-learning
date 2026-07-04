# Tutoring Platform

## 🏗️ Architecture: Design Before Coding

**The Problem:**
Students book tutors for specific subjects. Tutors charge hourly rates. The session takes place over video. 

**The Solution:**
A classic scheduling system (like Salon/Clinic) combined with a `Subjects` tagging system (Many-to-Many). The `Sessions` table holds the meeting URL.

**Database Architecture:**
```text
Subjects
├─ id
└─ name (e.g. "Calculus", "Physics")

Tutor_Subjects
├─ tutor_id
├─ subject_id
└─ hourly_rate (DECIMAL)

Sessions
├─ id
├─ tutor_id
├─ student_id
├─ subject_id
├─ start_time
├─ duration_minutes
├─ meeting_url (External Zoom/Meet link)
└─ total_price (Calculated: duration/60 * hourly_rate)
```
