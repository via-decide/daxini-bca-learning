# File Sharing API: Learn By Building

**"Build a backend service that accepts file uploads via multipart form data, saves them to disk, and generates unique download links."**

---


## 🧪 Testing: How to Verify

### Test 1: Upload Validation
- Try to upload a 10MB file. The API should reject it with a `400 Bad Request`.
- Try to upload a `.txt` file. The API should reject it if you only allow images/PDFs.

### Test 2: Name Preservation
- Upload a file named `my_crazy_vacation_photo!@#.jpg`.
- Download the file via the returned link.
- The downloaded file on your computer should still be named exactly `my_crazy_vacation_photo!@#.jpg`.

---


## 🛠️ Debugging: When Things Break

### Problem: Uploads are stalling or timing out.
**Root Cause:** Your server framework likely has a default request body size limit (e.g., 1MB in Express.js) or you are testing using raw JSON instead of `multipart/form-data`.
**Solution:** Ensure your framework is configured to accept larger payloads and use a proper multipart parser library (like `multer` in Node.js or `MultipartFile` in Spring).

---
