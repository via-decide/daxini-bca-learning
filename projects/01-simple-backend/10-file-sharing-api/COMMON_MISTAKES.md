# File Sharing API: Learn By Building

**"Build a backend service that accepts file uploads via multipart form data, saves them to disk, and generates unique download links."**

---


## ⚠️ Common Mistakes

### ❌ Mistake 1: Memory Exhaustion (RAM)
**What's wrong:** Loading a 1GB uploaded video completely into RAM (`fs.readFileSync`), and then sending it to the client. If 4 people download it, your server crashes because it ran out of RAM.
**Why it's bad:** Servers usually have 512MB or 1GB of RAM. 
**How to fix:** Use **Streams**. Pipe the file directly from the hard drive to the HTTP response. It acts like a conveyor belt, moving chunks of data without filling up the memory.

### ❌ Mistake 2: Directory Traversal Attacks
**What's wrong:** Letting users download files via `GET /api/download?file=report.pdf`.
**Why it's bad:** A hacker can request `GET /api/download?file=../../../../etc/passwd` and download your server's secret password file.
**How to fix:** Never trust user input for file paths. Lookup the safe `local_path` from your database using an ID instead.

---
