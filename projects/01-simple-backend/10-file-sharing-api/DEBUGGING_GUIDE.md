# 📁 File Sharing API: Learn By Building

**"Build a secure backend service where users can upload any file, receive a download link, and protect the download with an optional password."**

---

## 🧪 Testing Scenarios

### Scenario 1: Unprotected File Download

```
1. POST to `/api/files/upload` with a file (e.g., a PDF) and NO password.
2. Note the returned `id`.
3. POST to `/api/files/:id/download` with an empty JSON body `{}`.
4. Expected: The API should respond with a 200 OK and a stream of binary data. In Postman, you can click "Save Response" -> "Save to a file" to verify the PDF opens correctly on your computer.
```

### Scenario 2: Password Protection Flow

```
1. POST to `/api/files/upload` with a file AND `password: "secret123"`.
2. GET `/api/files/:id/info`.
3. Expected: The API should return `is_password_protected: true`.
4. POST to `/api/files/:id/download` with `{ "password": "wrongpassword" }`.
5. Expected: The API MUST return 401 Unauthorized. The file download MUST NOT start.
6. POST to `/api/files/:id/download` with `{ "password": "secret123" }`.
7. Expected: The API should stream the file.
```

### Scenario 3: Memory Exhaustion Test (Streaming Verification)

```
1. Find a massive file on your computer (e.g., a 1GB or 2GB movie file).
2. Upload it to your API. (You may need to temporarily increase your Multer size limits to test this).
3. Start downloading it.
4. Open your computer's Task Manager or Activity Monitor. Watch the memory usage of your Node.js process.
5. Expected: The memory usage should remain extremely low (under 100MB) throughout the entire 1GB download. If memory usage skyrockets to 1GB+, you are loading the file into RAM instead of streaming it.
```

### Scenario 4: The Path Traversal Test

```
1. Manually insert a row into your database where `file_path` is `../../../../../etc/passwd`.
2. Attempt to download that file via the API.
3. Expected: The server should either crash gracefully (File Not Found) or actively prevent downloading from outside the `/uploads` directory. Never blindly trust the file path in the DB if an admin or hacker could have modified it.
```

---
