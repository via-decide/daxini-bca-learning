## 🔌 API Design: Plan Before Coding

### 1. Search Jobs
**GET `/api/jobs?query=developer&location=remote`**
- **Logic**: Use SQL `ILIKE` or Full Text Search to filter the `jobs` table, returning only `is_active = true`.

### 2. Update Application Status (Employer Only)
**PUT `/api/applications/:id/status`**
- **Body**: `{ "status": "interviewing" }`
- **Logic**: Validate that the User making the request is the `owner_id` of the `Company` that posted the `Job` that this `Application` is for.
