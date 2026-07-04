## 🛠️ Debugging & Verification

**Test 1: JSON Validation**
- Attempt to PUT a string into the `content` field instead of a valid JSON object. Ensure the API rejects it before it hits the database.

**Test 2: PDF Headers**
- Hit the Export endpoint. Ensure the browser automatically triggers a file download instead of trying to render binary gibberish on the screen (Check `Content-Disposition` header).
