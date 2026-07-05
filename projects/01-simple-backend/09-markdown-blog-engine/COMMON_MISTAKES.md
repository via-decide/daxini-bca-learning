# 📝 Markdown Blog Engine: Learn By Building

**"Build a fast, file-based blog engine that reads Markdown files from the hard drive, parses them into HTML, and serves them to users without needing a database."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Reading the file system on every request

**Wrong:**
```javascript
app.get('/api/posts', (req, res) => {
  // Reading the Hard Drive inside the route handler
  const files = fs.readdirSync('./posts'); 
  const posts = files.map(file => readAndParse(file));
  res.json({ posts });
});
```
*Why it's bad:* `fs.readdirSync` blocks the entire Node.js event loop. If one user asks for the homepage, NO OTHER USER can do anything until the server finishes reading all the files.

**Right:**
Read the files *once* when the server boots up, save them to a variable, and serve the variable.
```javascript
// Server Startup
let cachedPosts = [];
function loadPostsToMemory() {
  const files = fs.readdirSync('./posts');
  cachedPosts = files.map(file => readAndParse(file));
}
loadPostsToMemory(); // Call it once

app.get('/api/posts', (req, res) => {
  // Instant response from RAM!
  res.json({ posts: cachedPosts });
});
```

### ❌ Mistake 2: Vulnerability to Path Traversal

**Wrong:**
```javascript
app.get('/api/posts/:slug', (req, res) => {
  const fileContent = fs.readFileSync(`./posts/${req.params.slug}.md`, 'utf8');
});
```
*Why it's bad:* A hacker can request `/api/posts/..%2F..%2F..%2Fetc%2Fpasswd`. 
Your code translates this to `./posts/../../../etc/passwd.md` and tries to read the server's private password file!

**Right:**
Validate the slug to ensure it only contains alphanumeric characters and dashes.
```javascript
app.get('/api/posts/:slug', (req, res) => {
  const slug = req.params.slug;
  if (!/^[a-zA-Z0-9-]+$/.test(slug)) {
    return res.status(400).json({ error: "Invalid post URL" });
  }
  
  // Also wrap in try/catch to handle file not found
});
```

### ❌ Mistake 3: Returning full content to the homepage

**Wrong:**
```javascript
// Reading all files and sending EVERYTHING to the frontend
res.json({ posts: cachedPostsWithFullHTML });
```
*Why it's bad:* If you have 100 blog posts, each with 5 pages of text, you are sending megabytes of data to a user who just wants to read the titles on the homepage.

**Right:**
Map over your cached data and strip out the `html_content` before sending it to the `/api/posts` endpoint. Only send the full content in the `/api/posts/:slug` endpoint.

---
