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


## ✅ Before Submission

- [ ] Does navigating to the endpoint return an actual image?
- [ ] Is the API completely stateless (no database, no file system writes)?
- [ ] Are query parameters for `size` and `color` successfully altering the image?

---

**Build this and learn: Binary responses, memory buffers, and stateless microservices.**
