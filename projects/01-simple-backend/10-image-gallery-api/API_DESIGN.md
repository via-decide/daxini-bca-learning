# 🖼️ Image Gallery API: API Design

**"Build a backend API that allows users to upload image files (multipart/form-data), saves them to the server's hard drive, and stores the image metadata in a SQL database."**

---

## 🔗 API Endpoints

```
POST   /api/images/upload             → Upload an image (multipart/form-data)
GET    /api/images                    → List all uploaded images (metadata)
GET    /uploads/:filename             → Serve the actual image file to the browser
DELETE /api/images/:id                → Delete an image (DB and File)
```

---

## 📦 Request/Response Examples

### 1. Upload an Image

**Request:**
```http
POST /api/images/upload HTTP/1.1
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW

------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="uploader_name"

Dharam
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="image"; filename="dog.jpg"
Content-Type: image/jpeg

[...RAW BINARY IMAGE DATA...]
------WebKitFormBoundary7MA4YWxkTrZu0gW--
```

**Response (201):**
```json
{
  "message": "Image uploaded successfully",
  "image": {
    "id": "uuid-1234",
    "uploader_name": "Dharam",
    "original_filename": "dog.jpg",
    "url": "http://localhost:3000/uploads/1696155000000-dog.jpg",
    "size_bytes": 1024500,
    "uploaded_at": "2026-10-01T10:00:00Z"
  }
}
```

### 2. List Images (The Gallery Feed)

**Request:**
```http
GET /api/images?sort=newest HTTP/1.1
```

**Response (200):**
```json
{
  "images": [
    {
      "id": "uuid-1234",
      "uploader_name": "Dharam",
      "url": "http://localhost:3000/uploads/1696155000000-dog.jpg",
      "uploaded_at": "2026-10-01T10:00:00Z"
    }
  ],
  "meta": {
    "total": 1
  }
}
```
*(The frontend uses the `url` property in an `<img src="...">` tag to display it).*

### 3. Delete an Image

**Request:**
```http
DELETE /api/images/uuid-1234 HTTP/1.1
```

**Response (200):**
```json
{
  "message": "Image deleted successfully from database and file system."
}
```

---

## ⚠️ Error Responses

```json
// 400 Bad Request (No file attached)
{ "error": "Please upload a file." }

// 415 Unsupported Media Type (User tried to upload a .pdf or .exe)
{ "error": "Only .jpg, .jpeg, and .png files are allowed." }

// 413 Payload Too Large (File is bigger than 5MB limit)
{ "error": "File size exceeds the 5MB limit." }
```
