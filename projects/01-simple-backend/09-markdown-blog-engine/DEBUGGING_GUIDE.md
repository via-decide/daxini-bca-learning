# 📝 Markdown Blog Engine: Learn By Building

**"Build a fast, file-based blog engine that reads Markdown files from the hard drive, parses them into HTML, and serves them to users without needing a database."**

---

## 🧪 Testing Scenarios

### Scenario 1: The Sorting Test

```
1. Create 3 markdown files in your `/posts` folder.
   - `post1.md` (Date: 2026-10-01)
   - `post2.md` (Date: 2026-10-15)
   - `post3.md` (Date: 2026-10-05)
2. Request `/api/posts`.
3. Expected: The array of posts MUST be sorted by Date descending (Newest first).
4. Verify: `post2` should be first, `post3` second, `post1` last.
```

### Scenario 2: The Parsing Test

```
1. Create a markdown file with this content:
   ---
   title: "Test"
   date: "2026-10-01"
   ---
   # Hello World
   **Bold Text**
2. Request `/api/posts/test`
3. Expected: The `html_content` should literally be `"<h1>Hello World</h1>\n<p><strong>Bold Text</strong></p>"`
```

### Scenario 3: Missing File Handling

```
1. Request `/api/posts/this-file-does-not-exist`
2. Expected: API should return 404 Not Found.
3. Verify: The Node.js server SHOULD NOT crash with an `ENOENT: no such file or directory` error. You must catch that error.
```

### Scenario 4: Performance / Caching Test

```
1. Add a `console.log("Reading from hard drive")` inside the function that reads your markdown folder.
2. Request `/api/posts` 5 times in a row.
3. Expected: You should only see "Reading from hard drive" ONE time in your terminal. The other 4 requests should be served from the RAM cache.
```

---
