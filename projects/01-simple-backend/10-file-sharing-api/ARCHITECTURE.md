# File Sharing API: Learn By Building

**"Build a backend service that accepts file uploads via multipart form data, saves them to disk, and generates unique download links."**

---


## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data Separation

**Question: Why not save the PDF inside a SQL column (BLOB)?**
- Databases are optimized for fast searching and joining text/numbers. Putting 50MB binary files inside SQL blows up the database size, slows down backups, and ruins query performance.
- **Rule of Thumb:** Store files on disk (or S3). Store the *path* to the file in the database.

### Step 2: Architecture Diagram

**Upload Flow:**
```text
1. Client POSTs multipart/form-data to /api/upload
2. API validates file size (< 5MB) and type (only Images/PDFs)
3. API generates a UUID (e.g., "7f8b9")
4. API saves file to disk at: `/uploads/7f8b9.pdf`
5. API saves metadata to DB: `INSERT INTO files (id, original_name, path) VALUES ('7f8b9', 'report.pdf', '/uploads/7f8b9.pdf')`
6. API returns `{ "download_url": "/api/download/7f8b9" }`
```

**Download Flow:**
```text
1. Client GETs /api/download/7f8b9
2. API finds record '7f8b9' in DB.
3. API reads `path` (/uploads/7f8b9.pdf) and `original_name` (report.pdf).
4. API sets header `Content-Disposition: attachment; filename="report.pdf"`
5. API streams the file from disk to the client.
```

---
