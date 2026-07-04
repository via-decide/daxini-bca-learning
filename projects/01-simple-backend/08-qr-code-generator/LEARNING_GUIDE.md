# QR Code Generator: Learn By Building

**"Build a stateless API that accepts a URL and generates a customized, downloadable QR Code image on the fly."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Binary File Responses** - Returning images (PNG/SVG) from an API instead of standard JSON.
✅ **Stateless Processing** - Doing computational work (image generation) on-the-fly without saving to a database.
✅ **Query Parameters parsing** - Extracting configuration (color, size) directly from the URL.
✅ **Buffer Manipulation** - Handling data streams and memory buffers in the backend.
✅ **HTTP Headers** - Setting correct `Content-Type` and `Content-Disposition` headers so browsers know it's an image.

---

## 📋 Project Overview

### The Problem
Sometimes frontend apps need to generate a QR code, but doing heavy image generation on low-end mobile devices using JavaScript can freeze the UI. Offloading this to a backend API ensures fast, reliable generation.

### Who Uses It
```
Marketing Website (Frontend):
├─ Renders: <img src="https://api.yourapp.com/qr?data=https://daxini.xyz&color=black" />

Backend API (You):
├─ Reads the ?data and ?color parameters
├─ Generates a PNG QR code in memory
└─ Returns the raw image data directly to the <img> tag
```

### The Big Picture

```text
┌──────────────┐                 ┌──────────────┐
│  HTML <img>  │ ──(GET req)───> │ Your Backend │
│  (Frontend)  │ <──(PNG/SVG)─── │ (Generator)  │
└──────────────┘                 └──────────────┘
```

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data

**Question: Do we need a database?**
- No! This is a **stateless** service. We don't need to save the QR code to a database or a file system. We just generate it in RAM (memory) and immediately send it to the user.

### Step 2: Architecture Diagram

```text
1. Client requests GET /api/qr?data=https://github.com&size=300
2. API validates `data` (Is it empty?) and `size` (Is it between 100 and 1000?)
3. API uses a QR code library to generate a PNG buffer in memory.
4. API sets HTTP Header: `Content-Type: image/png`
5. API sends the binary buffer as the response body.
```

### Step 3: Returning Non-JSON Data
Most APIs return `Content-Type: application/json`.
For this, you must return `Content-Type: image/png`. If you don't, the browser will try to read the image as text, resulting in random gibberish characters (like `PNG...`).

---

## 🗄️ Database: Design, Don't Code

**No Database Required.**
This teaches you that not every backend project needs a database. Stateless microservices are highly scalable because they don't depend on database connections.

---

## 🔌 API Design: Plan Before Coding

### Endpoint 1: Generate QR Code
**GET `/api/qr`**
- **Query Params**:
  - `data` (string, required): The URL or text to encode.
  - `size` (integer, optional, default: 200): Width/height in pixels.
  - `color` (string, optional, default: "000000"): Hex code for the QR code color.
- **Purpose**: Generates the image.
- **Response**: Binary PNG Data (`200 OK`)

---

## 🧠 Implementation: Pseudocode First

```text
FUNCTION generate_qr(request, response):
    data = request.query.data
    size = request.query.size OR 200
    color = "#" + (request.query.color OR "000000")
    
    // 1. Validation
    IF data is empty:
        RETURN 400 JSON { "error": "Data query parameter is required" }
        
    IF size < 100 OR size > 1000:
        size = 200 // Default fallback
        
    // 2. Generate Image Buffer
    TRY:
        qr_options = { width: size, color: { dark: color, light: "#FFFFFF" } }
        image_buffer = QRCodeLibrary.toBuffer(data, qr_options)
        
        // 3. Set Headers and Return
        response.setHeader("Content-Type", "image/png")
        // Optional: Force download instead of displaying in browser
        // response.setHeader("Content-Disposition", "attachment; filename=qr.png")
        
        response.send(image_buffer)
        
    CATCH Error (e):
        RETURN 500 JSON { "error": "Failed to generate QR code" }
```

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Memory Leaks
**What's wrong:** Saving the generated QR code to the hard drive (`qr_123.png`) and returning the URL to the user, but never deleting the file.
**Why it's bad:** Your server's hard drive will fill up and crash.
**How to fix:** Generate the file in memory (RAM buffer) and send it directly. It will be garbage collected automatically. Do not use the file system.

### ❌ Mistake 2: Missing Headers
**What's wrong:** Returning the image buffer without setting `Content-Type`.
**Why it's bad:** The `<img src="...">` tag won't know how to render it, and the image will appear broken.
**How to fix:** Always explicitly set `Content-Type: image/png`.

---

## 🧪 Testing: How to Verify

### Test 1: Direct Browser Testing
- Open your browser and go to `http://localhost:3000/api/qr?data=hello`.
- You should physically see a QR code image, not JSON.

### Test 2: Validation Testing
- Go to `http://localhost:3000/api/qr` (missing data parameter).
- The browser should display a JSON error message `{"error": "Data... required"}`.

---

## 🛠️ Debugging: When Things Break

### Problem: The image downloads automatically instead of showing in the browser.
**Root Cause:** You set `Content-Disposition: attachment`.
**Solution:** Remove the `attachment` header. Browsers will display `image/png` natively unless told to download it.

---

## 📚 Resources

- **Libraries**: Look up standard QR code generation libraries for your language (e.g., `qrcode` in npm, `qrcode` in Python).
- **HTTP Headers**: MDN Web Docs: Content-Type and Content-Disposition.

---

## ✅ Before Submission

- [ ] Does navigating to the endpoint return an actual image?
- [ ] Is the API completely stateless (no database, no file system writes)?
- [ ] Are query parameters for `size` and `color` successfully altering the image?

---

**Build this and learn: Binary responses, memory buffers, and stateless microservices.**
