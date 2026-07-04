# Form Builder API: Learn By Building

**"Build a dynamic API that allows users to define custom form fields (JSON schemas), and then strictly validates incoming submissions against those user-defined rules."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Dynamic Data Modeling** - Storing changing structural schemas instead of hard-coded SQL columns.
✅ **JSON Schema Validation** - Validating arbitrary JSON objects against strict rule sets.
✅ **EAV (Entity-Attribute-Value) Pattern Concepts** - How to store unstructured user data securely.
✅ **Validation Engine Logic** - Writing an engine that loops through rules to catch bad data.

---

## 📋 Project Overview

### The Problem
If you build a standard "Contact Us" form, you create a database table with `name`, `email`, and `message` columns. But what if you are building a tool like Google Forms or Typeform? Every user creates a form with entirely different fields. User A wants "Age (Number)". User B wants "Favorite Color (Dropdown)". You cannot create a new SQL column every time a user adds a field. You need a flexible system.

### Who Uses It
```
Creator (Admin):
├─ Sends: "I need a form with Name (String, required) and Age (Number, min 18)"
└─ API saves this definition as a JSON Schema.

Submitter (User):
├─ Sends: { "name": "John", "age": 16 }
└─ API rejects: "Validation failed: Age must be >= 18"
```

### The Big Picture

```text
┌──────────────┐                 ┌──────────────┐
│  Form Admin  │ ──(Define)────> │ Your Backend │
│  (Creator)   │                 │ (Validator)  │
└──────────────┘                 └──────┬───────┘
                                        │ (Checks rules)
┌──────────────┐                        V
│  Respondent  │ ──(Submit)────> ┌──────────────┐
│  (User)      │                 │ Database     │
└──────────────┘                 └──────────────┘
```

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

## 🗄️ Database: Design, Don't Code

### Schema Design (PostgreSQL / Document DB recommended)

```text
Table: Forms
- id: UUID (Primary Key)
- title: VARCHAR
- schema: JSONB (Stores the array of field definitions)

Table: Submissions
- id: UUID (Primary Key)
- form_id: UUID (Foreign Key)
- answers: JSONB (Stores the user's data payload)
- submitted_at: TIMESTAMP
```

### Design Questions

1. **Why use `JSONB` instead of standard `TEXT`?**
   If you use a modern database like PostgreSQL, `JSONB` allows you to write queries *inside* the JSON. For example, later you could query: `SELECT * FROM Submissions WHERE answers->>'f1' = '25'`.

---

## 🔌 API Design: Plan Before Coding

### Endpoint 1: Create a Form
**POST `/api/forms`**
- **Body**:
```json
{
  "title": "Event Registration",
  "fields": [
    { "id": "name", "type": "string", "required": true },
    { "id": "age", "type": "number", "min": 18, "required": true }
  ]
}
```

### Endpoint 2: Submit a Form
**POST `/api/forms/:id/submit`**
- **Body**:
```json
{
  "answers": {
    "name": "Alice",
    "age": 16
  }
}
```
- **Response**: `400 Bad Request`
```json
{ "error": "Validation failed: 'age' must be at least 18." }
```

---

## 🧠 Implementation: Pseudocode First

```text
FUNCTION submit_form(request, response):
    form_id = request.params.id
    user_answers = request.body.answers
    
    // 1. Fetch Form Schema
    form = DB.find("Forms", form_id)
    IF form is NULL: RETURN 404 "Form not found"
    
    // 2. The Validation Engine
    errors = []
    
    FOR field IN form.schema.fields:
        answer = user_answers[field.id]
        
        // Check Required
        IF field.required == true AND answer is NULL:
            errors.push("Field " + field.id + " is required.")
            CONTINUE
            
        // Skip further checks if empty and not required
        IF answer is NULL: CONTINUE
        
        // Type Check
        IF type_of(answer) != field.type:
            errors.push("Field " + field.id + " must be a " + field.type)
            CONTINUE
            
        // Rule Check: Number Min/Max
        IF field.type == "number":
            IF field.min != NULL AND answer < field.min:
                errors.push(field.id + " must be >= " + field.min)
                
    // 3. Evaluate Result
    IF length(errors) > 0:
        RETURN 400 { validation_errors: errors }
        
    // 4. Save Submission
    DB.insert("Submissions", { form_id: form_id, answers: user_answers })
    RETURN 201 "Success"
```

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Trusting the Client's Payload
**What's wrong:** Letting the user submit `{ "admin_override": true }` inside their answers, and blindly saving the whole `request.body` to the database.
**Why it's bad:** Mass Assignment vulnerability.
**How to fix:** Ensure your validation engine ONLY copies keys from `request.body` that actually exist in the `form.schema.fields` definition. Discard everything else.

### ❌ Mistake 2: Type Coercion Bugs
**What's wrong:** The schema asks for a `number`. The user submits `"25"` (a string). Your language converts `"25" >= 18` to `true` (type coercion), but it saves as a string in the DB.
**Why it's bad:** Data corruption. The database now has mixed types for the same field.
**How to fix:** Strictly enforce types (`typeof answer === 'number'`) before validating logic.

---

## 🧪 Testing: How to Verify

### Test 1: The Rejection Test
- Create a form requiring a number > 10.
- Submit a string (`"15"`). Ensure it fails type checking.
- Submit a number (`9`). Ensure it fails logic checking.
- Submit an empty object (`{}`). Ensure it fails required checking.

### Test 2: The Extra Data Test
- Submit valid answers, but include a fake field: `{"name": "Bob", "secret_hack": "yes"}`.
- Check the database. Ensure `secret_hack` was NOT saved.

---

## 🛠️ Debugging: When Things Break

### Problem: Everything passes validation even when it shouldn't.
**Root Cause:** The loop logic. If you use a `forEach` loop in some languages, returning from inside the loop only exits the callback, it doesn't stop the validation engine.
**Solution:** Collect all errors into an array. Check `errors.length > 0` at the very end of the evaluation phase.

---

## 📚 Resources

- **Data Modeling**: Read about the "Entity-Attribute-Value" (EAV) model vs JSONB storage.
- **Libraries**: Look up JSON Schema validation libraries (like `Ajv` for Node.js or `Pydantic` for Python) to see how pros do it.

---

## ✅ Before Submission

- [ ] Does your API reject submissions that are missing required fields?
- [ ] Does your API strip out fields that were not defined in the original schema?
- [ ] Can your validation engine handle both `string` and `number` type checks?
- [ ] Are the error messages clear enough for a frontend dev to display them to a user?

---

**Build this and learn: Dynamic schema architecture, validation engines, and JSONB database strategies.**
