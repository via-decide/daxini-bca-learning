# 📁 File Sharing API: Learn By Building

**"Build a secure backend service where users can upload any file, receive a download link, and protect the download with an optional password."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Node.js Streams** - How to handle massive files using `fs.createReadStream().pipe(res)` without running out of server RAM.  
✅ **Content-Disposition Headers** - Forcing a browser to download a file with a specific filename rather than trying to display it on screen.  
✅ **Bcrypt Hashing** - Securely storing passwords and comparing them during the download request.  
✅ **Advanced Multer** - Combining multipart file uploads with standard text fields (like passwords) in a single request.

---

## 📋 Project Overview

### The Problem

Services like WeTransfer or Google Drive allow users to upload files and share links. The engineering challenge is moving large amounts of binary data efficiently. You must never load a large file into server memory. You must stream it. Furthermore, if a user wants to protect their file, you need a secure way to intercept the download, ask for a password, verify it, and *then* start the stream.

**Your job:** Build the upload pipeline (Multer + DB + Bcrypt) and the download pipeline (Bcrypt Verify + Stream).

### Who Uses It

```
Uploader:
├─ POSTs File + Optional Password
└─ Gets Download URL

Downloader:
├─ GETs File Info (Checks if password is required)
├─ POSTs to Download URL (Provides password if needed)
└─ Receives File Stream
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. The Upload Route

```pseudocode
// Middleware: upload.single('file') handles saving the file to disk
POST /api/files/upload:
  Step 1: Check File
    if !request.file: return 400 "File is required"
    
  Step 2: Handle Password (Optional)
    password_hash = null
    if request.body.password:
      // Hash it with a salt factor of 10
      password_hash = bcrypt.hash(request.body.password, 10)
      
  Step 3: Save to DB
    id = generateUUID()
    db.insert("shared_files", {
      id: id,
      original_filename: request.file.originalname,
      saved_filename: request.file.filename,
      file_path: request.file.path,
      mime_type: request.file.mimetype,
      size_bytes: request.file.size,
      password_hash: password_hash
    })
    
  Step 4: Return Link
    return 201 { download_url: `.../api/files/${id}/download` }
```

### 2. The Download Route (With Streams)

```pseudocode
POST /api/files/:id/download:
  Step 1: Fetch Metadata
    file_record = db.query("SELECT * FROM shared_files WHERE id = ?", id)
    if !file_record: return 404 "File not found"
    
  Step 2: Password Verification
    if file_record.password_hash is not null:
      provided_password = request.body.password
      if !provided_password:
        return 401 "Password required"
        
      is_match = bcrypt.compare(provided_password, file_record.password_hash)
      if !is_match:
        return 401 "Invalid password"
        
  Step 3: Set Download Headers
    // This tells the browser to pop up a "Save As" dialog with the original name
    response.setHeader('Content-Disposition', `attachment; filename="${file_record.original_filename}"`)
    response.setHeader('Content-Type', file_record.mime_type)
    
  Step 4: Stream the File!
    // Do NOT use fs.readFileSync!
    stream = fs.createReadStream(file_record.file_path)
    
    // Connect the file reader directly to the HTTP response writer
    stream.pipe(response)
    
    // Handle errors (e.g. file was deleted from hard drive but still in DB)
    stream.on('error', (err) => {
      response.status(500).send("File read error")
    })
```

---

## ✅ Before Submission

- [ ] Users can upload files via `multipart/form-data`.
- [ ] Uploaded files are saved to the server's hard drive using `multer`.
- [ ] Users can optionally provide a password.
- [ ] Passwords are hashed with `bcrypt` before being saved to the database.
- [ ] The API provides an `/info` endpoint to check if a file requires a password.
- [ ] The download endpoint verifies the password (if applicable).
- [ ] The download endpoint uses `fs.createReadStream().pipe(res)` to stream the data.
- [ ] Code is on GitHub.

**Success:** You have built a highly scalable file distribution server!
