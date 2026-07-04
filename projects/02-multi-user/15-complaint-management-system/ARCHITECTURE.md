# Complaint Management System (City/HOA Portal)

## 🏗️ Architecture: Design Before Coding

**The Problem:**
Citizens report issues (Potholes, Broken Lights). They attach photos. The city dispatches workers. The citizen needs to track the status of their complaint over time.

**The Solution:**
A core `Complaints` table with an `Attachments` table (1-to-Many). A `Complaint_History` ledger to track exactly when and who changed the status of the complaint.

**Database Architecture:**
```text
Complaints
├─ id
├─ citizen_id
├─ category (ENUM: Road, Water, Electricity)
├─ description
├─ lat / lng (Location)
└─ current_status (ENUM: Submitted, In_Progress, Resolved)

Complaint_Images
├─ complaint_id
└─ s3_image_url

Complaint_History
├─ complaint_id
├─ updated_by (Admin User ID)
├─ old_status
├─ new_status
└─ updated_at
```
