# 🖼️ Image Gallery API: Learn By Building

**"Build a backend API that allows users to upload image files (multipart/form-data), saves them to the server's hard drive, and stores the image metadata in a SQL database."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Multipart Form Data** - How binary files are chunked and transmitted over HTTP alongside standard text fields.  
✅ **Multer Middleware** - How to intercept, validate, and save incoming files securely on a Node.js server.  
✅ **Static File Serving** - How to safely expose a specific folder (`/uploads`) to the public internet so browsers can load the images.  
✅ **Data Consistency** - Keeping the Hard Drive and the SQL Database perfectly in sync (especially during deletions).  
✅ **Security (Validation)** - Rejecting dangerous file types and setting maximum file size limits to prevent server crashes.

---

## 📋 Project Overview

### The Problem

Handling text is easy. Handling binary files (images, PDFs, videos) requires a fundamentally different approach. You have to deal with the file system (`fs`), manage storage capacity, ensure safe filenames so users don't overwrite each other, and serve those files back out to the internet efficiently.

**Your job:** Build the complete lifecycle of a file upload: Receive -> Validate -> Save to Disk -> Save to DB -> Serve to Public.

### Who Uses It

```
The Frontend:
├─ Shows a form with <input type="file" />
├─ Sends a POST request using JavaScript's `FormData` object
└─ Displays the returned image URL in an <img> tag.
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. The Multer Configuration (The Guard)

```javascript
// Step 1: Configure where and how to save the file
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    // Save in the 'uploads' folder
    cb(null, 'uploads/')
  },
  filename: function (req, file, cb) {
    // Rename the file to prevent overwrites! (e.g. 1630000000-vacation.jpg)
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9)
    cb(null, uniqueSuffix + '-' + file.originalname)
  }
})

// Step 2: Configure Validation
const upload = multer({ 
  storage: storage,
  limits: {
    fileSize: 5 * 1024 * 1024 // 5 Megabytes max limit!
  },
  fileFilter: function (req, file, cb) {
    // Reject anything that isn't a jpeg or png
    if (file.mimetype === 'image/jpeg' || file.mimetype === 'image/png') {
      cb(null, true)
    } else {
      cb(new Error('Only JPG and PNG files are allowed!'), false)
    }
  }
})
```

### 2. The Upload Route

```pseudocode
// Note how the `upload.single('image')` middleware runs BEFORE our function
POST /api/images/upload ( middleware: upload.single('image') ):
  
  // If we reach here, Multer successfully saved the file to the hard drive!
  
  Step 1: Validate Text Fields
    uploader_name = request.body.uploader_name
    if !uploader_name: return 400 "Name is required"
    
  Step 2: Get File Info (Provided by Multer)
    file = request.file
    // file.filename (The new unique name)
    // file.path (Where it is saved on disk)
    // file.mimetype (e.g. "image/jpeg")
    // file.size (in bytes)
    
  Step 3: Generate the Public URL
    // This is what the frontend needs to put in the <img src="..."> tag
    public_url = `http://localhost:3000/uploads/${file.filename}`
    
  Step 4: Save to Database
    database.insert("images", {
      uploader_name: uploader_name,
      original_filename: file.originalname,
      saved_filename: file.filename,
      file_path: file.path, 
      mime_type: file.mimetype,
      size_bytes: file.size
    })
    
  Step 5: Return Success
    return 201 { url: public_url }
```

---

## ✅ Before Submission

- [ ] API accepts `multipart/form-data` uploads containing an image and text fields.
- [ ] Uses `multer` to save the file to an `/uploads` directory on the server.
- [ ] Ensures filenames are unique (to prevent User B overwriting User A's file).
- [ ] Saves metadata (original name, path, size, etc.) to a SQL database.
- [ ] Uses `express.static` so users can view the images via URL.
- [ ] Deleting an image removes the row from the database AND deletes the physical file from the hard drive.
- [ ] Enforces a 5MB maximum file size limit.
- [ ] Code is on GitHub.

**Success:** You have built a robust file-handling system, a critical skill for building social media apps, document managers, or e-commerce platforms!
