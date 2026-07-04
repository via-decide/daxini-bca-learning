# Resume Builder

## 🏗️ Architecture: Design Before Coding

**The Problem:**
A resume has highly nested, dynamic data. 3 Education entries, 5 Experience entries (each with 4 bullet points), 10 Skills. If we create a separate SQL table for every single entity (`User_Educations`, `User_Experiences`, `User_Skills`, `User_Bullets`), the queries become a nightmare of 10 JOINs.

**The Solution:**
Embrace the `JSONB` column in PostgreSQL. Because a resume is a self-contained document that is usually loaded all at once and rarely queried by individual bullet points, it's the perfect candidate for a NoSQL-like JSON column within a relational database.

**Database Architecture:**
```text
Resumes
├─ id
├─ user_id
├─ title (e.g. "Software Engineer Resume")
├─ template_id (ENUM: Classic, Modern, Creative)
├─ content (JSONB)
└─ last_updated
```
