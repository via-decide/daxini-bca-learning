# QR Code Generator: Learn By Building

**"Build a stateless API that accepts a URL and generates a customized, downloadable QR Code image on the fly."**

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
