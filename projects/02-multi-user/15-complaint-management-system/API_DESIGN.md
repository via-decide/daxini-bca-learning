## 🔌 API Design: Plan Before Coding

### 1. Submit Complaint
**POST `/api/complaints`**
- **Logic**: Insert the complaint. If photos are attached, upload them to S3 and save the URLs in `complaint_images`.

### 2. Update Status (Admin Only)
**PUT `/api/complaints/:id/status`**
- **Body**: `{ "new_status": "resolved" }`
- **Logic**: Use a Transaction. 
  1. Read current status. 
  2. Insert row into `complaint_history`. 
  3. Update `current_status` on `complaints`.
