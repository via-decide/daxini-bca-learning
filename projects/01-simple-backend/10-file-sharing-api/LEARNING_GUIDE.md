# File Sharing API: Learn By Building

**"Build a backend service that accepts file uploads via multipart form data, saves them to disk, and generates unique download links."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Multipart/Form-Data** - Parsing raw file bytes sent over HTTP.
✅ **Blob Storage Basics** - Saving binary files to a local file system (the precursor to AWS S3).
✅ **File Metadata** - Storing file details (size, MIME type, original name) in a database while storing the actual file on disk.
✅ **Security & Validation** - Preventing malicious uploads (e.g., stopping users from uploading `.exe` viruses).
✅ **Streams** - Returning large files to users efficiently without crashing the server's RAM.

---

## 📋 Project Overview

### The Problem
Sending a JSON string to an API is easy. Sending a 50MB PDF document requires a different protocol format (`multipart/form-data`). Once the backend receives the 50MB file, it cannot simply save it into a SQL database (doing so degrades database performance). The API must save the *file* to the hard drive, and save the *metadata* (where to find it) in the database.

### Who Uses It
```
Web Dashboard (Frontend):
├─ Uploads: "Q3_Report.pdf" (15MB)
└─ Receives: "https://api.yourapp.com/download/9a1b2c3d"

Backend API (You):
├─ Parses the incoming byte stream
├─ Saves the raw file to `/uploads/9a1b2c3d.pdf`
├─ Saves to Database: { id: "9a1b...", name: "Q3_Report.pdf", size: 15000000 }
└─ Returns the download link
```

### The Big Picture

```text
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Web Client  │ ──> │ Your Backend │ ──> │ File System  │
│  (Uploader)  │     │ (Parser)     │     │ (/uploads/)  │
└──────────────┘     └──────┬───────┘     └──────────────┘
                            │
┌──────────────┐            │             ┌──────────────┐
│  Web Client  │ <──(Stream)│ ──────────> │ Database     │
│  (Downloader)│ ──(Link)───┘             │ (Metadata)   │
└──────────────┘                          └──────────────┘
```

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

## 🗄️ Database: Design, Don't Code

### Schema Design (SQL or NoSQL)

```text
Table: Files
- id: UUID (Primary Key)
- original_name: VARCHAR (e.g., "vacation_photo.jpg")
- mime_type: VARCHAR (e.g., "image/jpeg")
- size_bytes: INT
- local_path: VARCHAR (e.g., "/app/uploads/8f2c.jpg")
- created_at: TIMESTAMP
```

### Design Questions

1. **Why rename the file on the hard drive?**
   If User A uploads `report.pdf` and User B uploads `report.pdf`, User B will overwrite User A's file! Always save files using unique IDs on the disk, and map them back to their original names in the database.

---

## 🔌 API Design: Plan Before Coding

### Endpoint 1: Upload File
**POST `/api/upload`**
- **Content-Type**: `multipart/form-data`
- **Body**: File payload attached to field name `file`.
- **Response**: `201 Created`
```json
{
  "id": "7f8b9...",
  "url": "http://localhost:3000/api/download/7f8b9..."
}
```

### Endpoint 2: Download File
**GET `/api/download/:id`**
- **Purpose**: Download the specific file.
- **Response**: Binary File Stream (`200 OK`)

---

## 🧠 Implementation: Pseudocode First

```text
FUNCTION upload_file(request, response):
    uploaded_file = parse_multipart_form(request)
    
    // 1. Validation
    IF uploaded_file.size > 5_000_000: // 5MB limit
        RETURN 400 "File too large"
    IF uploaded_file.mime_type NOT IN ["image/png", "application/pdf"]:
        RETURN 400 "Invalid file type"
        
    // 2. Storage
    file_id = generate_uuid()
    disk_path = "/uploads/" + file_id + get_extension(uploaded_file.name)
    
    save_to_disk(uploaded_file.buffer, disk_path)
    
    // 3. Database Metadata
    DB.insert("Files", {
        id: file_id,
        original_name: uploaded_file.name,
        mime_type: uploaded_file.mime_type,
        size: uploaded_file.size,
        local_path: disk_path
    })
    
    RETURN 201 { url: "/api/download/" + file_id }

FUNCTION download_file(request, response):
    file_record = DB.find(request.params.id)
    
    IF file_record is NULL:
        RETURN 404 "File not found"
        
    // 4. Set Headers so browser downloads it with original name
    response.setHeader("Content-Type", file_record.mime_type)
    response.setHeader("Content-Disposition", "attachment; filename=" + file_record.original_name)
    
    // 5. Stream from disk (Don't load whole file into RAM!)
    file_stream = open_file_stream(file_record.local_path)
    pipe_stream_to_response(file_stream, response)
```

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Memory Exhaustion (RAM)
**What's wrong:** Loading a 1GB uploaded video completely into RAM (`fs.readFileSync`), and then sending it to the client. If 4 people download it, your server crashes because it ran out of RAM.
**Why it's bad:** Servers usually have 512MB or 1GB of RAM. 
**How to fix:** Use **Streams**. Pipe the file directly from the hard drive to the HTTP response. It acts like a conveyor belt, moving chunks of data without filling up the memory.

### ❌ Mistake 2: Directory Traversal Attacks
**What's wrong:** Letting users download files via `GET /api/download?file=report.pdf`.
**Why it's bad:** A hacker can request `GET /api/download?file=../../../../etc/passwd` and download your server's secret password file.
**How to fix:** Never trust user input for file paths. Lookup the safe `local_path` from your database using an ID instead.

---

## 🧪 Testing: How to Verify

### Test 1: Upload Validation
- Try to upload a 10MB file. The API should reject it with a `400 Bad Request`.
- Try to upload a `.txt` file. The API should reject it if you only allow images/PDFs.

### Test 2: Name Preservation
- Upload a file named `my_crazy_vacation_photo!@#.jpg`.
- Download the file via the returned link.
- The downloaded file on your computer should still be named exactly `my_crazy_vacation_photo!@#.jpg`.

---

## 🛠️ Debugging: When Things Break

### Problem: Uploads are stalling or timing out.
**Root Cause:** Your server framework likely has a default request body size limit (e.g., 1MB in Express.js) or you are testing using raw JSON instead of `multipart/form-data`.
**Solution:** Ensure your framework is configured to accept larger payloads and use a proper multipart parser library (like `multer` in Node.js or `MultipartFile` in Spring).

---

## 📚 Resources

- **File Uploads**: Look up "handling multipart form data" for your specific backend framework.
- **Streams**: Node.js `fs.createReadStream()`, Python `yield` generators for streaming responses.
- **Security**: OWASP Unrestricted File Upload vulnerabilities.

---

## ✅ Before Submission

- [ ] Are uploaded files stored on the file system, not the database?
- [ ] Are files saved on disk with random IDs rather than user-provided names?
- [ ] Does downloading the file restore its original name?
- [ ] Are you enforcing a strict maximum file size?

---

**Build this and learn: Binary file handling, multipart parsing, and secure file system interactions.**
