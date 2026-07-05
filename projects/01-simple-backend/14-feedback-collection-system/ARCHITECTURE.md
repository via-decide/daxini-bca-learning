# 📝 Feedback Collection System: Learn By Building

**"Build an API that allows a business to create multiple feedback forms (e.g. 'Website Redesign', 'Customer Support'), generate unique links for them, and securely collect and aggregate user responses."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. An admin creates a "Product Launch Feedback" form.
2. The admin shares the URL: `your-api.com/feedback/prod-launch-26`.
3. 50 users fill out the form, providing a star rating (1-5) and a text comment.
4. The admin logs in to see the average rating and read the comments.

**What data do you need for each?**

After thinking, here's the data model. You need TWO tables because one Form can have MANY Responses (A One-to-Many Relationship).

```
Table 1: Forms
├─ id (String - URL friendly slug like 'prod-launch-26')
├─ title (String - e.g. "Product Launch Feedback")
├─ is_active (Boolean - So admins can turn off old forms)
└─ created_at

Table 2: Responses
├─ id (UUID)
├─ form_id (Foreign Key -> Forms.id)
├─ rating (Integer 1-5)
├─ comment (TEXT)
├─ user_ip_hash (String - To prevent spam/duplicate voting)
└─ submitted_at
```

---

### Step 2: The Aggregation Problem

**Question: When the admin asks for the results of the form, how do you get the average rating?**

**Bad Idea (Computing in Memory):**
```javascript
const responses = await db.query("SELECT rating FROM responses WHERE form_id = 'prod-launch-26'");
// Array of 10,000 ratings is now in server RAM
let total = 0;
for (let r of responses) total += r.rating;
const average = total / responses.length;
```
*Why it's bad:* Moving 10,000 rows from the database to the Node.js server just to calculate an average is extremely slow and wastes massive amounts of RAM.

**Good Idea (SQL Aggregation):**
Let the database do the math. Databases are highly optimized for this.
```sql
SELECT 
  COUNT(id) as total_responses, 
  AVG(rating) as average_rating 
FROM responses 
WHERE form_id = 'prod-launch-26';
```
This returns exactly one row, instantly, using zero Node.js RAM.

---

### Step 3: Preventing Spam (Without Logins)

If a feedback form is public (no login required), a single angry user can write a script to submit 10,000 1-star ratings, ruining the data.

**Solution:** 
You can track the user's IP Address (`req.ip` in Express). However, storing raw IP addresses is a privacy violation in many countries (GDPR). 
Instead, you should **Hash** the IP address with a daily salt.
```javascript
const crypto = require('crypto');
// Hash the IP + the Form ID so we know this device voted on this specific form
const voterHash = crypto.createHash('sha256').update(req.ip + formId).digest('hex');

// Check DB if voterHash already exists for this form...
```

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Public Form UI (5 Stars + Textbox)   │  │
│  │ Admin Dashboard (Analytics View)     │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP GET /api/forms/:id
        HTTP POST /api/forms/:id/responses
        HTTP GET /api/forms/:id/analytics (Admin)
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. IP Hashing / Spam Prevention      │  │
│  │ 2. Insert Response to DB             │  │
│  │ 3. SQL Aggregation (COUNT, AVG)      │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
┌────────────────────────────────────────────┐
│        Database (SQLite/PostgreSQL)        │
│  - forms table                             │
│  - responses table (Foreign Key: form_id)  │
└────────────────────────────────────────────┘
```
