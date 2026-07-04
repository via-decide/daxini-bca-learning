## 🔌 API Design: Plan Before Coding

### 1. Search Jobs
**GET `/api/jobs?remote=true&min_salary=50000&page=1`**
- **Logic**: Construct a dynamic SQL query. Add `WHERE is_remote = true`, add `WHERE max_salary >= 50000`. Add `LIMIT 10 OFFSET 0`.

### 2. Apply for Job
**POST `/api/jobs/:id/apply`**
- **Headers**: `Content-Type: multipart/form-data`
- **Logic**: Save the uploaded PDF to disk (e.g., `./uploads/resumes/123.pdf`). Save the string `/uploads/resumes/123.pdf` to the `resume_file_path` column.
