# 📱 QR Code Generator API: Learn By Building

**"Build a stateless API that accepts a string (like a URL) and instantly generates and returns a downloadable QR code image."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. User types "https://google.com" and clicks "Generate".
2. The API receives the text and uses a library (like `qrcode` in Node.js) to draw an image.
3. The API sends the image binary data back to the browser.
4. The user downloads the image.

**What data do you need for each?**

After thinking, here's the data model:

```
NO DATABASE REQUIRED.
```

**Decision:** This is a **Stateless Microservice**. The server does not need to remember anything about past requests. It simply takes an input, performs a heavy computation (generating the image), and returns the output. It requires zero storage, which means it can scale infinitely.

---

### Step 2: The Data Format Problem

**Question: How do you send an image over an API?**

Normally, APIs return JSON: `{"message": "success"}`.
You cannot easily put raw image data into standard JSON.

**Bad Idea:**
Converting the image to a massive Base64 string and putting it in JSON:
`{"image": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAA..."}`
*Why it's bad:* Base64 encoding increases file size by 33%. It's slow for the server to encode, slow for the network to transfer, and slow for the browser to decode.

**Good Idea:**
Change the HTTP `Content-Type` header. Instead of returning `application/json`, the API will return `image/png`. The API directly streams the raw binary image data.
*Why it's good:* Fast, native, and the browser can display it directly using `<img src="http://your-api.com/generate?text=hello">`.

---

### Step 3: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Text Input ("Enter URL")             │  │
│  │ "Generate" Button                    │  │
│  │ <img src="...API_URL..." />          │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP GET /api/qr?text=Hello
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. Validate Input (Is text empty?)   │  │
│  │ 2. Generate QR Code in memory        │  │
│  │    (using a library like 'qrcode')   │  │
│  │ 3. Set Header: Content-Type: image/png│ │
│  │ 4. Pipe binary image to response     │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
```
