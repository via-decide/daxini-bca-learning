# QR Code Generator: Learn By Building

**"Build a stateless API that accepts a URL and generates a customized, downloadable QR Code image on the fly."**

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
