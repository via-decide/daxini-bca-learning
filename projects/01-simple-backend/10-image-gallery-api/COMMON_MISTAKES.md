# 🖼️ Image Gallery API: Learn By Building

**"Build a backend API that allows users to upload image files (multipart/form-data), saves them to the server's hard drive, and stores the image metadata in a SQL database."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Trying to parse files using `express.json()`

**Wrong:**
```javascript
app.use(express.json()); // This only parses raw JSON text!

app.post('/api/upload', (req, res) => {
  console.log(req.body); // Will be completely empty when sending a file!
});
```
*Why it's bad:* File uploads use `multipart/form-data`, which `express.json()` ignores. You will spend hours wondering why `req.body` is empty.

**Right:**
Use `multer` middleware on routes that accept files.
```javascript
const upload = multer({ dest: 'uploads/' });

// The middleware intercepts the file, saves it, and populates `req.file` and `req.body`
app.post('/api/upload', upload.single('image'), (req, res) => {
  console.log(req.file); // Information about the saved file
  console.log(req.body); // Any text fields (like uploader_name)
});
```

### ❌ Mistake 2: Forgetting to serve the `/uploads` folder statically

**Wrong:**
If you save a file to `/uploads/dog.jpg`, and then type `http://localhost:3000/uploads/dog.jpg` in your browser, Express will say `Cannot GET /uploads/dog.jpg`.

*Why it's bad:* By default, Express protects all your folders. If it didn't, anyone could type `http://localhost:3000/server.js` and read your source code!

**Right:**
You must explicitly tell Express that the `/uploads` folder is "public".
```javascript
// Any request to /uploads will look inside the local 'uploads' directory
app.use('/uploads', express.static('uploads'));
```

### ❌ Mistake 3: Storage Leaks (Not deleting the physical file)

**Wrong:**
```javascript
app.delete('/api/images/:id', (req, res) => {
  db.query("DELETE FROM images WHERE id = ?", [req.params.id]);
  res.json({ message: "Deleted!" });
});
```
*Why it's bad:* You deleted the database record, but the 5MB image is STILL sitting on your hard drive forever. Eventually, your server runs out of storage and crashes.

**Right:**
Fetch the file path from the DB first, delete the physical file, THEN delete the DB row.
```javascript
const fs = require('fs');

app.delete('/api/images/:id', async (req, res) => {
  // 1. Get the file path
  const image = await db.query("SELECT file_path FROM images WHERE id = ?", [req.params.id]);
  
  // 2. Delete the physical file from the hard drive
  if (fs.existsSync(image.file_path)) {
    fs.unlinkSync(image.file_path);
  }
  
  // 3. Delete the DB record
  await db.query("DELETE FROM images WHERE id = ?", [req.params.id]);
});
```

---
