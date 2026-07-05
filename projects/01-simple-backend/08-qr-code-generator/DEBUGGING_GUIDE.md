# 📱 QR Code Generator API: Learn By Building

**"Build a stateless API that accepts a string (like a URL) and instantly generates and returns a downloadable QR code image."**

---

## 🧪 Testing Scenarios

### Scenario 1: The Browser Test

```
1. Start your backend server.
2. Open Google Chrome.
3. Type `http://localhost:3000/api/qr/generate?text=HelloWorld` into the URL bar.
4. Expected: The browser should immediately display a black and white QR code.
5. Verify: Take your actual smartphone, open the camera, and point it at your computer monitor. It should scan "HelloWorld".
```

### Scenario 2: The HTML Image Tag Test

```
1. Create a tiny `test.html` file on your desktop.
2. Put this inside: `<img src="http://localhost:3000/api/qr/generate?text=Test" />`
3. Open `test.html` in your browser.
4. Expected: The image should load perfectly on the webpage.
```

### Scenario 3: Validation Test

```
1. Open Google Chrome.
2. Type `http://localhost:3000/api/qr/generate` (Missing the text parameter).
3. Expected: The browser should NOT try to display a broken image icon. It should display the raw JSON error: `{"error": "Text is required"}`.
```

### Scenario 4: The Data Limit Test

```
1. Try to generate a QR code with 4,000 characters of text (copy-paste a whole paragraph).
2. Expected: It should work, but the QR code will look INCREDIBLY dense and complex.
3. Try to generate a QR code with 10,000 characters.
4. Expected: The API should gracefully fail (return a 400 Bad Request) because QR codes have a strict maximum data capacity (~3KB). It should NOT crash the server.
```

---
