# QR Code Generator: Learn By Building

**"Build a stateless API that accepts a URL and generates a customized, downloadable QR Code image on the fly."**

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
