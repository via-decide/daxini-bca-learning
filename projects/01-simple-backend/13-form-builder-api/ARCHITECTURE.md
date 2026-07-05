# 📝 Form Builder API (Typeform Clone): Learn By Building

**"Build a dynamic form engine where users can define custom questions, share links, and collect structured responses."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. User creates a new form called "Customer Feedback"
2. User adds three questions: a text input, a multiple-choice, and a rating
3. User publishes the form and gets a shareable link
4. A customer opens the link and submits answers
5. The creator views a dashboard of all submitted responses

**What data do you need for each?**

After thinking, here's the data model:

```
Users (for login)
├─ id (UUID)
├─ email (unique)
├─ password_hash
└─ created_at

Forms (the main container)
├─ id (UUID)
├─ user_id (links to Users)
├─ title
├─ description
├─ is_published (boolean)
└─ created_at

Questions (fields within a form)
├─ id (UUID)
├─ form_id (links to Forms)
├─ question_text
├─ type (text/radio/checkbox/rating)
├─ options (JSON string — e.g. ["Yes", "No", "Maybe"])
├─ is_required (boolean)
└─ position (integer or string for sorting)

Submissions (a single person filling out the form)
├─ id (UUID)
├─ form_id (links to Forms)
├─ submitted_at
└─ ip_address (optional, for rate limiting)

Answers (individual answers linked to a submission)
├─ id (UUID)
├─ submission_id (links to Submissions)
├─ question_id (links to Questions)
└─ value (TEXT — stores the actual answer)
```

---

### Step 2: The JSON vs. Relational Dilemma

**Question: Should `options` be a separate table or a JSON column?**

**Option A (Separate Table `Options`):**
- Pros: Strictly relational, easy to query "how many people picked Option B".
- Cons: Overkill for simple forms. Harder to reorder.

**Option B (JSON string in `Questions` table):**
- Pros: Much simpler to fetch a form (1 query instead of 2). Perfect for Document stores or modern SQL (Postgres JSONB / SQLite JSON).
- Cons: Harder to write complex analytical SQL queries.

**Decision:** We use JSON for `options` because form definitions are usually read as a single block and passed directly to the frontend.

---

### Step 3: Database Architecture

```
┌──────────────────────────────────────────┐
│              Database                    │
├──────────────────────────────────────────┤
│                                          │
│  users ─────────┐                        │
│                 │                        │
│                 ├──► forms ─────────┐    │
│                 │       │           │    │
│                 │       ▼           ▼    │
│                 │    questions  submissions│
│                 │       │           │    │
│                 │       └─────► answers ◄┘
│                                          │
└──────────────────────────────────────────┘

Relationships:
- users.id → forms.user_id (one user, many forms)
- forms.id → questions.form_id (one form, many questions)
- forms.id → submissions.form_id (one form, many submissions)
- submissions.id → answers.submission_id (one submission, many answers)
- questions.id → answers.question_id (one answer belongs to one specific question)
```

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML)             │
│  ┌──────────────────────────────────────┐  │
│  │ Form Builder UI (Creator view)       │  │
│  │ Public Form UI (Respondent view)     │  │
│  │ Analytics Dashboard (Results)        │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP Requests
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ Auth (Creator login)                 │  │
│  ├──────────────────────────────────────┤  │
│  │ Creator API (Needs JWT token)        │  │
│  │  - Create/Edit forms                 │  │
│  │  - Add/Edit questions                │  │
│  │  - View submissions                  │  │
│  ├──────────────────────────────────────┤  │
│  │ Public API (No auth required)        │  │
│  │  - Get published form details        │  │
│  │  - Submit answers                    │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        SQL Queries
              │
              ▼
┌────────────────────────────────────────────┐
│        Database (SQLite/PostgreSQL)        │
│  - Persistent data storage                 │
│  - Foreign key constraints                 │
└────────────────────────────────────────────┘
```

---
