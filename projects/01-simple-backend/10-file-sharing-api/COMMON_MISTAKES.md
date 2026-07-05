# 📁 File Sharing API: Learn By Building

**"Build a secure backend service where users can upload any file, receive a download link, and protect the download with an optional password."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Memory Leaks (Loading files into RAM)

**Wrong:**
```javascript
app.get('/download/:id', async (req, res) => {
  const file = await db.query("...");
  // DO NOT DO THIS
  const buffer = fs.readFileSync(file.file_path); 
  res.send(buffer);
});
```
*Why it's bad:* `fs.readFileSync` forces Node.js to read the entire file into the server's RAM before sending a single byte to the user. A few users downloading large files will instantly crash your server with an Out Of Memory error.

**Right:**
Use Streams.
```javascript
app.post('/download/:id', async (req, res) => {
  const file = await db.query("...");
  // Creates a pipeline directly from hard drive to the network
  const stream = fs.createReadStream(file.file_path);
  stream.pipe(res);
});
```

### ❌ Mistake 2: Passing Passwords in the URL

**Wrong:**
```
GET /api/files/uuid-1234/download?password=mySecret123
```
*Why it's bad:* URLs are logged everywhere. They are saved in browser history, logged by internet service providers, and logged by your server's proxy (like Nginx). Anyone looking at the logs can see the password.

**Right:**
Use a POST request to download secured files, and put the password in the JSON body.
```javascript
// POST /api/files/:id/download
// Body: { "password": "mySecret123" }
```

### ❌ Mistake 3: Storing Plain-Text Passwords

**Wrong:**
```javascript
// Database Insertion
db.insert({ password_hash: req.body.password }); // Saving exactly what the user typed
```
*Why it's bad:* If your database is compromised, the hackers have everyone's passwords. Users often reuse passwords across different sites.

**Right:**
Use `bcrypt`.
```javascript
const bcrypt = require('bcrypt');

let hash = null;
if (req.body.password) {
  hash = await bcrypt.hash(req.body.password, 10);
}
db.insert({ password_hash: hash });
```

---
