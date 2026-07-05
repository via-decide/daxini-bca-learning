# 🖼️ Image Gallery API: Learn By Building

**"Build a backend API that allows users to upload image files (multipart/form-data), saves them to the server's hard drive, and stores the image metadata in a SQL database."**

---

## 🧪 Testing Scenarios

### Scenario 1: The Basic Upload Test (Using Postman or Thunder Client)

```
1. Open Postman. Create a POST request to `/api/images/upload`.
2. Go to the "Body" tab. Select "form-data".
3. Add a key called `image`, change its type from "Text" to "File", and select an image from your computer.
4. Add a key called `uploader_name` and type your name.
5. Hit Send.
6. Expected: You get a 201 Created JSON response.
7. Verify 1: Check your database. A new row should exist.
8. Verify 2: Check your `/uploads` folder on your hard drive. The actual image file should be sitting there.
```

### Scenario 2: Serving Static Files

```
1. Take the `url` returned from Scenario 1 (e.g., `http://localhost:3000/uploads/123-dog.jpg`).
2. Paste it into your Chrome browser address bar.
3. Expected: The browser displays the image!
4. Verify: If it says "Cannot GET /uploads...", it means you forgot to use `express.static('uploads')` in your server setup.
```

### Scenario 3: The Virus/Executable Test (Validation)

```
1. Try to upload a `.pdf`, a `.txt`, or a `.exe` file.
2. Expected: The server should reject the request with a 415 error ("Only images allowed").
3. Verify: The file MUST NOT be saved to the `/uploads` folder, and NO row should be added to the database.
```

### Scenario 4: The Clean Delete Test

```
1. Upload an image. Note its ID.
2. Send a `DELETE /api/images/:id` request.
3. Expected: Returns 200 OK.
4. Verify 1: The row is gone from the database.
5. Verify 2 (CRITICAL): The actual physical file in the `/uploads` folder MUST be deleted (using `fs.unlinkSync`). If the file is still there, your server has a massive "storage leak".
```

---
