# 📝 Markdown Blog Engine: API Design

**"Build a fast, file-based blog engine that reads Markdown files from the hard drive, parses them into HTML, and serves them to users without needing a database."**

---

## 🔗 API Endpoints

```
GET    /api/posts                     → Get a list of all blog posts (Metadata only)
GET    /api/posts/:slug               → Get a specific blog post (Metadata + HTML content)
```
*(Note: A `slug` is the URL-friendly version of a title, usually the filename without the `.md` extension. e.g., `my-first-post`)*

---

## 📦 Request/Response Examples

### 1. Get All Posts (The Homepage Feed)

**Request:**
```http
GET /api/posts HTTP/1.1
```

**Response (200):**
```json
{
  "posts": [
    {
      "slug": "learning-apis",
      "title": "Learning APIs the Right Way",
      "date": "2026-10-05",
      "author": "Dharam",
      "tags": ["tech", "api"],
      "summary": "APIs are the backbone of the internet."
    },
    {
      "slug": "my-first-post",
      "title": "My First Post",
      "date": "2026-10-01",
      "author": "Dharam",
      "tags": ["personal"],
      "summary": "A brief introduction to my new blog."
    }
  ],
  "meta": {
    "total_posts": 2
  }
}
```
*(Notice that the `content` is NOT included here. We don't want to send 50 megabytes of HTML to the homepage if the user is just browsing the list.)*

### 2. Get a Specific Post

**Request:**
```http
GET /api/posts/learning-apis HTTP/1.1
```

**Response (200):**
```json
{
  "slug": "learning-apis",
  "title": "Learning APIs the Right Way",
  "date": "2026-10-05",
  "author": "Dharam",
  "tags": ["tech", "api"],
  "html_content": "<h1>Learning APIs the Right Way</h1><p>APIs are the backbone of the internet...</p>"
}
```
*(Notice we converted the Markdown to HTML on the backend. The frontend can now just safely inject this HTML using `dangerouslySetInnerHTML` in React or similar).*

---

## ⚠️ Error Responses

```json
// 404 Not Found (User typed a bad URL)
{ "error": "Post 'learning-apis-part-2' not found." }

// 500 Internal Server Error (The Markdown file is corrupted or YAML is invalid)
{ "error": "Failed to parse post metadata." }
```
