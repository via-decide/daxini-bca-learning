# 📱 QR Code Generator API: Learn By Building

**"Build a stateless API that accepts a string (like a URL) and instantly generates and returns a downloadable QR code image."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **HTTP Content Types** - Understanding how the web differentiates between HTML, JSON, and Images using Headers.  
✅ **Binary Data Streams** - Sending raw binary data (Buffers) over HTTP instead of text.  
✅ **Stateless Architecture** - Building a highly scalable microservice that requires no database or file system storage.  
✅ **In-Memory Processing** - Performing operations entirely in RAM for maximum speed.

---

## 📋 Project Overview

### The Problem

You want to build a feature where every user profile on your website has a unique QR code they can scan to share their profile. You *could* generate these and save millions of images to an AWS S3 bucket. But that costs money and storage. 

Instead, it is much cheaper and faster to generate the QR code *on the fly* the exact moment someone requests it, and throw it away immediately after.

**Your job:** Build the on-the-fly QR code generation microservice.

### Who Uses It

```
The HTML Frontend:
<img src="https://your-api.com/qr?text=https://my-profile.com/john" />

The API:
├─ Receives the request
├─ Draws the QR code in RAM
└─ Streams the PNG to the `<img>` tag instantly
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. The Core Endpoint

```pseudocode
GET /api/qr/generate:
  Step 1: Extract Parameters
    text = query.text
    
  Step 2: Validate
    if !text: 
      return 400 JSON { "error": "Text is required" }
      
    if length(text) > 2000:
      return 400 JSON { "error": "Text too long for QR Code" }
      
  Step 3: Generate Image (In Memory)
    try:
      // Using a library like 'qrcode' in Node.js
      // This creates a raw binary Buffer of a PNG image
      image_buffer = QRCode.toBuffer(text, { 
        errorCorrectionLevel: 'H', // High reliability
        margin: 1,
        width: 300 
      })
      
    catch error:
      return 500 JSON { "error": "Failed to generate image" }
      
  Step 4: Set Headers and Send
    // Tell the browser "Prepare yourself, an image is coming!"
    response.setHeader('Content-Type', 'image/png')
    
    // Optional: Tell the browser to cache this image for 1 year!
    // Since the text input dictates the output, it never changes.
    response.setHeader('Cache-Control', 'public, max-age=31536000')
    
    // Send the raw binary
    response.send(image_buffer)
```

---

## ✅ Before Submission

- [ ] API accepts a `text` query parameter.
- [ ] API returns a raw `image/png` binary stream (NOT JSON!).
- [ ] You can copy the API URL, paste it into your browser's address bar, and immediately see an image.
- [ ] The API does NOT save the image to the local hard drive (no `fs.writeFile`).
- [ ] If `text` is missing, the API gracefully returns a `400 Bad Request` with a JSON payload.
- [ ] Code is on GitHub.

**Success:** You have built a lightning-fast, stateless microservice that can be embedded directly into standard HTML `<img>` tags!
