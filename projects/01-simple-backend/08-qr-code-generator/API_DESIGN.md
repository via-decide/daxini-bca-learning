# QR Code Generator: Learn By Building

**"Build a stateless API that accepts a URL and generates a customized, downloadable QR Code image on the fly."**

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
