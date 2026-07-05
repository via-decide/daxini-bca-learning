# 📱 QR Code Generator API: Learn By Building

**"Build a stateless API that accepts a string (like a URL) and instantly generates and returns a downloadable QR code image."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Trying to return JSON containing an image buffer

**Wrong:**
```javascript
const imageBuffer = await QRCode.toBuffer(text);
res.json({ image: imageBuffer });
```
*Why it's bad:* The frontend will receive a JSON object where the `image` field is just an array of raw numbers. The frontend developer will have a nightmare trying to convert that back into a displayable image.

**Right:**
Change the headers and send the raw binary stream!
```javascript
const imageBuffer = await QRCode.toBuffer(text);
res.setHeader('Content-Type', 'image/png');
res.send(imageBuffer);
```

### ❌ Mistake 2: Missing Error Headers

**Wrong:**
```javascript
if (!req.query.text) {
  // We forgot to set the Content-Type back to JSON!
  res.status(400).send({ error: "Text is required" });
}
```
*Why it's bad:* If you previously forced the headers to `image/png` in middleware, or if the client expects an image, sending a JSON object without explicitly declaring it as JSON can confuse the client. 

**Right:**
Use `res.json()`, which automatically sets `Content-Type: application/json`.
```javascript
if (!req.query.text) {
  return res.status(400).json({ error: "Text is required" });
}
```

### ❌ Mistake 3: Saving the image to the Hard Drive first

**Wrong:**
```javascript
// Saving to disk
await QRCode.toFile('./temp.png', text);
// Sending the file
res.sendFile('./temp.png');
```
*Why it's bad:*
1. It is incredibly slow to write to a hard drive and read it back.
2. If 1,000 users hit this API at once, they will all try to overwrite `./temp.png` simultaneously, corrupting the image.
3. Your server's hard drive will fill up with garbage if you forget to delete it.

**Right:**
Keep it entirely in memory (RAM).
```javascript
// toBuffer generates the image directly in RAM
const imageBuffer = await QRCode.toBuffer(text);
res.send(imageBuffer);
```

---
