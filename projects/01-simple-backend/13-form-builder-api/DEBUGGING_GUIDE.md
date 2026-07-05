# 📝 Form Builder API (Typeform Clone): Learn By Building

**"Build a dynamic form engine where users can define custom questions, share links, and collect structured responses."**

---

## 🧪 Testing Scenarios

### Scenario 1: Creator Builds a Form

```
1. Creator logs in and requests POST /api/forms
2. Creator updates title: "Employee Satisfaction Survey"
3. Creator adds Question 1: "Department" (type: radio, options: ["HR", "Engineering", "Sales"])
4. Creator adds Question 2: "Feedback" (type: long_text)
5. Expected: Database shows 1 form and 2 questions linked to it
6. Verify: Creator can see the form when requesting GET /api/forms/:id
7. Non-creator tries to view GET /api/forms/:id: Expected 403 or 404
```

### Scenario 2: Form Publishing

```
1. Form is created (is_published = false)
2. Anonymous user tries to GET /api/published-forms/:id
3. Expected: 403 Forbidden "This form is not active."
4. Creator PATCH /api/forms/:id { "is_published": true }
5. Anonymous user tries to GET /api/published-forms/:id
6. Expected: 200 OK with Form Title, Description, and Questions (no sensitive data)
```

### Scenario 3: Missing Required Fields

```
1. Form has Question 1 (is_required = true) and Question 2 (is_required = false)
2. Respondent POSTs answers array with only Question 2 answered
3. Expected: Server rejects with 400 Bad Request
4. Validation logic should say: "Missing required answer for question: [Question 1 Text]"
5. Verify: No submission is created in the database
```

### Scenario 4: Valid Submission

```
1. Respondent POSTs answers array with all required questions answered
2. Expected: Server creates 1 row in `submissions` and N rows in `answers`
3. Response: 201 Created with submission_id
4. Creator requests GET /api/forms/:id/submissions
5. Expected: Creator sees the newly submitted answers linked to the form
```

### Scenario 5: Data Integrity (Cascade Deletes)

```
1. Creator deletes the form via DELETE /api/forms/:id
2. Expected: The form is deleted from `forms` table
3. Verify: All related questions are deleted from `questions` table
4. Verify: All related submissions are deleted from `submissions` table
5. Verify: All related answers are deleted from `answers` table
6. Reason: This ensures no "orphaned" rows are left behind, saving database space.
```

---
