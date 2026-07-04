# Form Builder API: Learn By Building

**"Build a dynamic API that allows users to define custom form fields (JSON schemas), and then strictly validates incoming submissions against those user-defined rules."**

---


## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data

**Question: How do we store thousands of different forms without making thousands of SQL tables?**
- We use two tables. 
- Table 1 (`Forms`): Stores the *rules* (the schema) as a JSON blob.
- Table 2 (`Submissions`): Stores the user's *answers* as a JSON blob, linked to the Form ID.

### Step 2: Architecture Diagram

```text
1. Creator POSTs to /api/forms with a schema:
   [ { "id": "f1", "type": "number", "min": 18, "required": true } ]
   
2. Respondent POSTs to /api/forms/123/submit with answers:
   { "f1": 25 }
   
3. API intercepts the submission.
4. API fetches Form 123's schema from the database.
5. API runs the validation engine: "Is 'f1' present? Is it a number? Is it >= 18?"
6. IF valid -> Save answer to Submissions table.
7. IF invalid -> Return 400 Bad Request with specific error messages.
```

---
