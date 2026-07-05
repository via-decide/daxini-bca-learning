# 📝 Markdown Blog Engine: Learn By Building

**"Build a fast, file-based blog engine that reads Markdown files from the hard drive, parses them into HTML, and serves them to users without needing a database."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **File System Operations (fs)** - Reading directories and files from the server's hard drive using Node.js.  
✅ **In-Memory Caching** - Loading data into RAM on server startup to bypass slow disk reads.  
✅ **Markdown & YAML Parsing** - Using libraries to extract structured metadata (Frontmatter) and convert Markdown strings into HTML.  
✅ **Security (Path Traversal)** - Protecting your server from hackers trying to read files outside the `/posts` folder.  
✅ **Stateless APIs vs Flat-File CMS** - Understanding when you actually need a database, and when simple files are better.

---

## 📋 Project Overview

### The Problem

Database-driven CMS platforms like WordPress are heavy, slow, and a pain to secure. Many developers prefer to write their blogs in simple Markdown files, commit them to GitHub, and have their server automatically render them. This is called a "Flat-File" or "Headless" CMS architecture.

**Your job:** Build the engine that turns a folder of Markdown files into a blazing-fast JSON API.

### Who Uses It

```
The Frontend UI:
├─ Fetches /api/posts to display the blog feed
└─ Fetches /api/posts/my-post to display the full article
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. Server Startup (The Cache Builder)

```pseudocode
Global Variable: cached_post_metadata = []
Global Variable: cached_post_html = {}

function initializeBlogEngine():
  // 1. Read the directory
  files = fs.readdirSync('./posts')
  
  for file in files:
    if !file.endsWith(".md"): continue
    
    // 2. Read the raw text
    raw_content = fs.readFileSync(`./posts/${file}`, 'utf-8')
    
    // 3. Parse the YAML Frontmatter and Markdown Body (using 'gray-matter')
    parsed = grayMatter(raw_content)
    metadata = parsed.data // { title: "...", date: "..." }
    markdown_body = parsed.content 
    
    // 4. Generate the Slug from the filename (e.g. "my-post.md" -> "my-post")
    slug = file.replace(".md", "")
    metadata.slug = slug
    
    // 5. Convert Markdown to HTML (using 'marked' or 'showdown')
    html = convertMarkdownToHTML(markdown_body)
    
    // 6. Save to our RAM caches
    cached_post_metadata.push(metadata)
    cached_post_html[slug] = html
    
  // 7. Sort the metadata array by Date (Descending)
  cached_post_metadata.sort((a, b) => new Date(b.date) - new Date(a.date))
```

### 2. The Endpoints

```pseudocode
// Called when the frontend wants the homepage feed
GET /api/posts:
  return 200 {
    posts: cached_post_metadata,
    meta: { total: cached_post_metadata.length }
  }
```

```pseudocode
// Called when the frontend wants to read a specific post
GET /api/posts/:slug:
  slug = request.params.slug
  
  // Look up the metadata
  metadata = cached_post_metadata.find(p => p.slug == slug)
  
  if !metadata:
    return 404 "Post not found"
    
  // Look up the HTML
  html = cached_post_html[slug]
  
  // Combine and return
  return 200 {
    ...metadata,
    html_content: html
  }
```

---

## ✅ Before Submission

- [ ] API reads a folder of `.md` files dynamically.
- [ ] Uses YAML frontmatter for metadata (`title`, `date`, `summary`).
- [ ] Converts the Markdown body into standard HTML.
- [ ] Implements an In-Memory cache (Reads files on startup, NOT on every request).
- [ ] Sorts the posts by Date (Newest first).
- [ ] Secures against Path Traversal (A user cannot request `/api/posts/../package.json`).
- [ ] Code is on GitHub.

**Success:** You have built a static-site-generator engine similar to Gatsby or Next.js!
