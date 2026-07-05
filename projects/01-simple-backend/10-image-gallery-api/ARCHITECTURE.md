# 🖼️ Image Gallery API: Learn By Building

**"Build a backend API that allows users to upload image files (multipart/form-data), saves them to the server's hard drive, and stores the image metadata in a SQL database."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: Where should you save the actual image files (the JPEGs and PNGs)?**

**Bad Idea:** Saving the binary image data directly into the SQL Database (in a BLOB column).
*Why it's bad:* Databases are designed for searching text and numbers. Putting a 5MB image into a database row makes the database massive, slow, and expensive to backup.

**Good Idea:** Save the image file to the server's Hard Drive (e.g., in a folder called `/uploads`), and save the *file path* (the text string) in the SQL database.

**The Data Model:**
```
Database Table: Images
├─ id (UUID)
├─ uploader_name (String)
├─ original_filename (e.g. "vacation.jpg")
├─ saved_filename (e.g. "1710523491-vacation.jpg" - To prevent overwrites)
├─ file_path (e.g. "/uploads/1710523491-vacation.jpg")
├─ mime_type (e.g. "image/jpeg")
├─ size_bytes (Integer)
└─ uploaded_at (Timestamp)

Server Hard Drive:
/uploads
  ├─ 1710523491-vacation.jpg
  └─ 1710523500-dog.png
```

---

### Step 2: The Multipart Form Data Problem

**Question: How does an image get from the browser to the backend?**

Normal APIs use JSON (`application/json`). But JSON is just text. You cannot easily send a 5MB binary image inside a JSON string. 

To upload files, browsers use a special content type called `multipart/form-data`. This allows the browser to send a request that contains both text fields (like `uploader_name`) and binary files (like the image) in chunks.

Your standard Express server (`express.json()`) does not know how to read `multipart/form-data`. You MUST use a specialized middleware library like **Multer** to intercept the request, extract the file, save it to the hard drive, and then pass the text fields to your route logic.

---

### Step 3: Security (Preventing Overwrites)

If User A uploads "cat.jpg", and User B later uploads a different "cat.jpg", User A's image will be overwritten on the hard drive. 

**Solution:** The backend must rename the file the moment it receives it. A common pattern is to prepend the current timestamp (in milliseconds) or a UUID to the filename: `1710523491-cat.jpg`.

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ <input type="file" />                │  │
│  │ "Upload" Button                      │  │
│  │ Image Grid (Gallery)                 │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP POST /api/upload
        (Content-Type: multipart/form-data)
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. Multer Middleware intercepts req  │  │
│  │ 2. Multer saves file to /uploads     │  │
│  │    and renames it uniquely           │  │
│  │ 3. Express Route handles the rest    │  │
│  │ 4. Insert metadata into SQL DB       │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
        │                            │
        ▼                            ▼
┌────────────────┐          ┌────────────────┐
│   Hard Drive   │          │  SQL Database  │
│ /uploads/*.jpg │          │  images table  │
└────────────────┘          └────────────────┘
```
