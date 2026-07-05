# 📝 Feedback Collection System: Learn By Building

**"Build an API that allows a business to create multiple feedback forms (e.g. 'Website Redesign', 'Customer Support'), generate unique links for them, and securely collect and aggregate user responses."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Computing averages in Node.js instead of SQL

**Wrong:**
```javascript
const allResponses = await db.query("SELECT * FROM responses WHERE form_id = ?", id);
const total = allResponses.reduce((sum, r) => sum + r.rating, 0);
const average = total / allResponses.length;
```
*Why it's bad:* If your app goes viral and you get 500,000 responses, `SELECT *` will pull 500,000 rows across the network and try to load them into a massive Javascript Array. Your server will crash immediately (Out of Memory).

**Right:**
```sql
-- Node.js only receives a tiny JSON object: { avg: 4.2 }
SELECT AVG(rating) as avg FROM responses WHERE form_id = ?;
```

### ❌ Mistake 2: Missing Foreign Key Indexes

**Wrong:**
Creating the `responses` table WITHOUT adding `CREATE INDEX idx_form_id ON responses(form_id);`.

*Why it's bad:* When the database executes `SELECT AVG(rating) FROM responses WHERE form_id = 'xyz'`, it has to scan every single row in the database (a "Full Table Scan") to see if it belongs to 'xyz'. If you have millions of rows, this query will take seconds to run.

**Right:**
Always create an Index on Foreign Keys. This allows the database to instantly jump to the exact rows it needs.

### ❌ Mistake 3: Storing Raw IP Addresses (GDPR Violation)

**Wrong:**
```javascript
db.insert({ ip_address: req.ip, rating: 5 });
```
*Why it's bad:* In Europe and California, IP addresses are considered "Personally Identifiable Information (PII)". If you store them, you are subject to strict privacy laws, cookie banners, and right-to-delete requests.

**Right:**
Hash the IP address so you can compare it, but never know what it originally was.
```javascript
// Hash the IP with a secret salt. 
// Now it's just a random string, useless to hackers, but perfect for preventing double-votes!
const hash = crypto.createHash('sha256').update(req.ip + process.env.SALT).digest('hex');
```

---
