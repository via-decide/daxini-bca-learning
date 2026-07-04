# Code Snippet Storage API: Learn By Building

**"Build a Pastebin-clone backend that allows developers to quickly save, format, and retrieve code snippets with syntax metadata."**

---


## 🧪 Testing: How to Verify

### Test 1: Whitespace Preservation
- Create a snippet with multiple tabs and newlines.
- Fetch the snippet back via GET.
- Ensure the tabs and newlines (`\n`) are completely unmodified.

### Test 2: Pagination / Limits
- Create 15 snippets.
- Request `/api/snippets/recent?limit=5`. Ensure it returns exactly 5 items.
- Request `/api/snippets/recent?limit=10000`. Ensure your API forcefully caps it (e.g., returns a maximum of 50) to prevent abuse.

---


## 🛠️ Debugging: When Things Break

### Problem: Code with quotes breaks the database insert.
**Root Cause:** You are manually constructing SQL strings like `INSERT INTO Snippets VALUES ('${code}')`. If the code contains `'`, it breaks the SQL syntax (and causes SQL Injection).
**Solution:** Always use **Parameterized Queries** (e.g., `execute("INSERT INTO Snippets (code) VALUES (?)", [code])`). The database driver will safely escape all characters automatically.

---
