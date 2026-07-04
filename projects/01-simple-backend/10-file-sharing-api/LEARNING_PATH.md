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


## ✅ Before Submission

- [ ] Are uploaded files stored on the file system, not the database?
- [ ] Are files saved on disk with random IDs rather than user-provided names?
- [ ] Does downloading the file restore its original name?
- [ ] Are you enforcing a strict maximum file size?

---

**Build this and learn: Binary file handling, multipart parsing, and secure file system interactions.**
