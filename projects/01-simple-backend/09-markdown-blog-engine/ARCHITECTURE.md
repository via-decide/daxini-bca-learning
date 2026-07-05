# 📝 Markdown Blog Engine: Learn By Building

**"Build a fast, file-based blog engine that reads Markdown files from the hard drive, parses them into HTML, and serves them to users without needing a database."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. You write a new blog post on your computer as a `.md` file.
2. You save it in a folder called `/posts`.
3. A user visits `yourblog.com/posts/my-first-post`.
4. The server needs to find `my-first-post.md`, convert it to HTML, and return it.
5. The user visits the homepage. The server needs to list all blog posts, sorted by date, with their titles and summaries.

**What data do you need for each?**

After thinking, here's the data model:

```
NO RELATIONAL DATABASE (SQL) REQUIRED.
The File System IS the database.

Folder Structure:
/posts
  ├─ 2026-10-01-my-first-post.md
  ├─ 2026-10-05-learning-apis.md
  └─ 2026-10-10-markdown-is-great.md
```

---

### Step 2: The Metadata Problem (Frontmatter)

**Question: How do you store the title, author, and date of a blog post if you don't have a database?**

If a Markdown file just has text, how does the home page know the title of the post without reading and parsing the entire file?

**Bad Idea:**
Assuming the first `# Heading` is the title, and trying to parse the file creation date from the operating system.

**Good Idea (YAML Frontmatter):**
Add a structured data block at the very top of every Markdown file.

```markdown
---
title: "My First Post"
date: "2026-10-01"
author: "Dharam"
tags: ["tech", "coding"]
summary: "A brief introduction to my new blog."
---

# Welcome to my blog!
This is the **markdown** content...
```

**Decision:** The engine MUST read the file, split it into two parts (Metadata and Content), and use a library like `gray-matter` to parse the YAML metadata.

---

### Step 3: Performance & Caching

**Question: Is it slow to read the hard drive on every single page load?**

Yes. Reading from a hard drive (Disk I/O) is one of the slowest things a server can do. If 1,000 people hit the homepage, reading all 50 Markdown files 1,000 times will crash the server.

**The Solution:**
Read all the files *once* when the server starts up. Store the parsed metadata (titles, dates, summaries) in an array in the server's RAM (Memory). When a user visits the homepage, return the array from RAM instantly.

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML)             │
│  ┌──────────────────────────────────────┐  │
│  │ Homepage (List of Posts)             │  │
│  │ Post Page (Full HTML Content)        │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP GET /api/posts
        HTTP GET /api/posts/my-first-post
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ Server Startup:                      │  │
│  │ 1. Read all .md files in /posts      │  │
│  │ 2. Parse YAML Frontmatter            │  │
│  │ 3. Save to In-Memory Cache           │  │
│  ├──────────────────────────────────────┤  │
│  │ API Routes:                          │  │
│  │ - GET /api/posts (Returns Cache)     │  │
│  │ - GET /api/posts/:slug               │  │
│  │   (Reads specific file, converts     │  │
│  │   Markdown to HTML, returns it)      │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
┌────────────────────────────────────────────┐
│        File System (Hard Drive)            │
│  - /posts/*.md                             │
└────────────────────────────────────────────┘
```
