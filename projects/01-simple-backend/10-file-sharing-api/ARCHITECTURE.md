# 📁 File Sharing API: Learn By Building

**"Build a secure backend service where users can upload any file, receive a download link, and protect the download with an optional password."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: Where should the actual files be saved?**

Just like the Image Gallery project, saving a 50MB PDF directly into a SQL database is a terrible idea. Databases are meant for metadata. The actual binary files should be saved on the server's Hard Drive.

**The Data Model:**
```
Database Table: SharedFiles
├─ id (UUID)
├─ original_filename (e.g. "financial_report.pdf")
├─ saved_filename (e.g. "1710523491-financial_report.pdf")
├─ file_path (e.g. "/uploads/1710523491-financial_report.pdf")
├─ mime_type (e.g. "application/pdf")
├─ size_bytes (Integer)
├─ password_hash (String - Nullable)
└─ uploaded_at (Timestamp)

Server Hard Drive:
/uploads
  ├─ 1710523491-financial_report.pdf
  └─ 1710523500-party-video.mp4
```

---

### Step 2: The Download Stream (Memory Management)

**Question: If a user downloads a 1GB video, how does your server handle it?**

**Bad Idea (Loading into memory):**
```javascript
app.get('/download/:id', (req, res) => {
  // Reads the entire 1GB file into the server's RAM!
  const fileBuffer = fs.readFileSync('/uploads/party-video.mp4'); 
  res.send(fileBuffer);
});
```
*Why it's bad:* If your Node.js server only has 512MB of RAM, trying to load a 1GB file into a variable will instantly crash the server with an "Out of Memory" (OOM) error. Even if you have 8GB of RAM, 10 users downloading the file at once will crash the server.

**Good Idea (Streaming):**
Instead of holding the whole file, you create a "pipe" between the hard drive and the network connection. Node.js reads a tiny chunk (e.g., 64KB), sends it to the user, clears that chunk from RAM, and reads the next chunk.

```javascript
app.get('/download/:id', (req, res) => {
  // Tells the browser "Hey, I'm sending a file attachment, please download it"
  res.setHeader('Content-Disposition', `attachment; filename="party-video.mp4"`);
  
  // Create a stream from the hard drive directly to the HTTP response
  const stream = fs.createReadStream('/uploads/party-video.mp4');
  stream.pipe(res);
});
```
This uses almost 0MB of RAM, allowing thousands of concurrent downloads.

---

### Step 3: Password Protection

If the user sets a password, we CANNOT save it in plain text. We must hash it using `bcrypt` (just like a user login). When someone tries to download the file, they send the password, and we use `bcrypt.compare()` to verify it before starting the download stream.

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ <input type="file" />                │  │
│  │ Password Input (Optional)            │  │
│  │ "Upload" Button                      │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP POST /api/files/upload
        (Content-Type: multipart/form-data)
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. Multer intercept & save to disk   │  │
│  │ 2. Hash password (if provided)       │  │
│  │ 3. Save metadata to DB               │  │
│  │ 4. Return Download Link              │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP POST /api/files/:id/download
        (Body: { password: "..." })
              │
              ▼
┌────────────────────────────────────────────┐
│        Download Handler                    │
│  1. Check DB for file metadata             │
│  2. Verify password (bcrypt)               │
│  3. Set Content-Disposition Headers        │
│  4. `fs.createReadStream().pipe(res)`      │
└────────────────────────────────────────────┘
```
