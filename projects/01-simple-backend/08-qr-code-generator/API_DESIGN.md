# 📱 QR Code Generator API: API Design

**"Build a stateless API that accepts a string (like a URL) and instantly generates and returns a downloadable QR code image."**

---

## 🔗 API Endpoints

```
GET    /api/qr/generate               → Generate and return a QR code image
```

---

## 📦 Request/Response Examples

### 1. Generate a Basic QR Code

**Request:**
```http
GET /api/qr/generate?text=https://github.com HTTP/1.1
```

**Response (200):**
```http
HTTP/1.1 200 OK
Content-Type: image/png
Content-Disposition: inline; filename="qrcode.png"

[...RAW BINARY PNG DATA...]
```
*(Notice this is NOT JSON!)*

### 2. Generate a Customized QR Code (Advanced)

*You can allow users to customize colors and size via query parameters.*

**Request:**
```http
GET /api/qr/generate?text=Hello&size=500&fgColor=FF0000&bgColor=000000 HTTP/1.1
```
*(Generates a 500x500 red QR code on a black background)*

**Response (200):**
```http
HTTP/1.1 200 OK
Content-Type: image/png

[...RAW BINARY PNG DATA...]
```

---

## ⚠️ Error Responses

If there is an error, we *cannot* return an image. We must change the Content-Type back to JSON and return the error.

**Request:**
```http
GET /api/qr/generate HTTP/1.1
```
*(Forgot to include the `text` parameter)*

**Response (400):**
```http
HTTP/1.1 400 Bad Request
Content-Type: application/json

{
  "error": "The 'text' query parameter is required."
}
```
