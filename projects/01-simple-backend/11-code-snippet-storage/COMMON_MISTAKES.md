# Code Snippet Storage API: Learn By Building

**"Build a Pastebin-clone backend that allows developers to quickly save, format, and retrieve code snippets with syntax metadata."**

---


## ⚠️ Common Mistakes

### ❌ Mistake 1: Not Validating Payload Size
**What's wrong:** Accepting a POST body without checking its size.
**Why it's bad:** A malicious user can send a 5GB text payload in a single request, crashing your application (OOM - Out of Memory) and filling your database instantly.
**How to fix:** Enforce a strict max length (e.g., 100KB) on the incoming string.

### ❌ Mistake 2: Stripping Whitespace
**What's wrong:** Calling `trim()` on every line of the code, or storing it in a way that removes tabs.
**Why it's bad:** Programming languages like Python rely strictly on indentation. If you remove tabs, the code breaks.
**How to fix:** Store the string exactly as received, preserving all `\n` and `\t` characters.

---
