# 📄 SaaS Resume Builder API: Learn By Building

**"Build a multi-user API where Users create multiple versions of their resumes with distinct sections (Education, Experience), and generate public shareable links that track view counts."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. User Ursula signs up and creates a "Software Engineer" resume.
2. She adds two Job Experiences and one Education entry to this resume.
3. She creates a second resume called "Product Manager" and adds different jobs.
4. She generates a public link for her "Software Engineer" resume.
5. Recruiter Rick clicks the link. The system increments the view count.

**What data do you need for each?**

After thinking, here's the data model:

```
Table: Users
├─ id (UUID)
├─ email (String)
└─ password_hash (String)

Table: Resumes (The Core Document)
├─ id (UUID)
├─ user_id (Foreign Key -> Users)
├─ title (String - e.g., "Software Engineer")
├─ public_slug (String - Unique, used for sharing)
├─ is_published (Boolean)
└─ view_count (Integer)

Table: Resume_Experiences (1-to-Many with Resume)
├─ id (UUID)
├─ resume_id (Foreign Key -> Resumes)
├─ company (String)
├─ role (String)
├─ start_date (Date)
├─ end_date (Date - NULL if current)
└─ description (String)

Table: Resume_Educations (1-to-Many with Resume)
├─ id (UUID)
├─ resume_id (Foreign Key -> Resumes)
├─ institution (String)
├─ degree (String)
└─ graduation_year (Integer)
```

---

### Step 2: Complex JSON Payloads vs Flat Tables

**Question: When Ursula saves her resume, the frontend sends a massive JSON object containing the title, 3 jobs, and 2 educations. How do you save this to a Relational Database?**

**Bad Idea:** Dumping the entire JSON payload into a single `TEXT` column on the `Resumes` table. (You lose the ability to query/filter by specific companies or degrees later).

**Good Idea:** The Backend parses the JSON and executes multiple `INSERT` statements inside a **Database Transaction**.
1. `INSERT INTO resumes`
2. `INSERT INTO resume_experiences` (looping through the array)
3. `INSERT INTO resume_educations` (looping through the array)
If any of these fail, the transaction rolls back, preventing a half-saved resume.

---

### Step 3: The Public Share Link (Concurrency)

When a recruiter views the public link, the `view_count` must increment.

**Bad Idea:**
```javascript
const resume = db.query("SELECT view_count FROM resumes...");
db.query("UPDATE resumes SET view_count = ?...", resume.view_count + 1);
```
If two recruiters click the link at the exact same millisecond, they both see a count of 10, and both update it to 11. One view is lost.

**Good Idea:** Atomic SQL increment.
```sql
UPDATE resumes SET view_count = view_count + 1 WHERE public_slug = 'ursula-swe';
```
This forces the database to lock the row for a microsecond and do the math internally, ensuring perfect accuracy.

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Resume Editor (Drag & Drop)          │  │
│  │ Public View Page (Read-Only)         │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP requests (JWT for editing, none for viewing)
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. Transactional Multi-Table Insert  │  │
│  │ 2. Public Link Router                │  │
│  │ 3. Atomic View Counter               │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
┌────────────────────────────────────────────┐
│        Database (PostgreSQL/MySQL)         │
│  - users, resumes, experiences, edus       │
└────────────────────────────────────────────┘
```
