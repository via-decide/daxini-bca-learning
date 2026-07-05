# 📁 File Sharing API: API Design

**"Build a secure backend service where users can upload any file, receive a download link, and protect the download with an optional password."**

---

## 🔗 API Endpoints

```
POST   /api/files/upload          → Upload a file (multipart/form-data)
GET    /api/files/:id/info        → Get basic info about a file (name, size, is_password_protected)
POST   /api/files/:id/download    → Actually download the binary file
```

---

## 📦 Request/Response Examples

### 1. Upload a File

**Request:**
```http
POST /api/files/upload HTTP/1.1
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW

------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="password"

mySuperSecretPassword123
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="file"; filename="report.pdf"
Content-Type: application/pdf

[...RAW BINARY DATA...]
------WebKitFormBoundary7MA4YWxkTrZu0gW--
```

**Response (201):**
```json
{
  "message": "File uploaded successfully",
  "file": {
    "id": "uuid-1234",
    "original_filename": "report.pdf",
    "download_url": "http://localhost:3000/api/files/uuid-1234/download",
    "size_bytes": 1024500,
    "is_password_protected": true
  }
}
```

### 2. Get File Info (For the Download Landing Page)

Before downloading, a user usually visits a webpage that says "You are about to download X. Enter password if required." This endpoint powers that page.

**Request:**
```http
GET /api/files/uuid-1234/info HTTP/1.1
```

**Response (200):**
```json
{
  "id": "uuid-1234",
  "original_filename": "report.pdf",
  "size_bytes": 1024500,
  "is_password_protected": true
}
```

### 3. Download the File

**Request:**
```http
POST /api/files/uuid-1234/download HTTP/1.1
Content-Type: application/json

{
  "password": "mySuperSecretPassword123"
}
```
*(Note: We use POST instead of GET here so we can securely send the password in the JSON body, rather than in the URL query string `?password=123` which gets logged by internet routers).*

**Response (200 OK + Binary Stream):**
```http
HTTP/1.1 200 OK
Content-Disposition: attachment; filename="report.pdf"
Content-Type: application/pdf
Content-Length: 1024500

[...RAW BINARY STREAM CHUNKS START ARRIVING...]
```

---

## ⚠️ Error Responses

```json
// 401 Unauthorized (Wrong Password)
{ "error": "Invalid password." }

// 404 Not Found (File deleted or bad ID)
{ "error": "File not found." }

// 413 Payload Too Large (File is bigger than your set limit)
{ "error": "File size exceeds the limit." }
```
