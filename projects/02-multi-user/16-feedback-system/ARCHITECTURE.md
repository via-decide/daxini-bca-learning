# Feedback & Rating System

## 🏗️ Architecture: Design Before Coding

**The Problem:**
Users submit feedback forms with 1-5 star ratings for different entities (Products, Services, or Employees). The UI needs to display the average rating across all reviews. 

**The Solution:**
Store every individual rating as a distinct row in a `Reviews` table. Calculate the average dynamically, or update a cached `average_rating` column on the parent entity using a database trigger.

**Database Architecture:**
```text
Entities (e.g. Products or Teachers)
├─ id
├─ name
└─ average_rating (DECIMAL, Cached)

Reviews
├─ id
├─ entity_id
├─ user_id
├─ rating (INT 1-5)
├─ comment (TEXT)
└─ created_at
```
