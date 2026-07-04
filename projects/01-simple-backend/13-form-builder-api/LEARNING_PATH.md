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


## ✅ Before Submission

- [ ] Does your API reject submissions that are missing required fields?
- [ ] Does your API strip out fields that were not defined in the original schema?
- [ ] Can your validation engine handle both `string` and `number` type checks?
- [ ] Are the error messages clear enough for a frontend dev to display them to a user?

---

**Build this and learn: Dynamic schema architecture, validation engines, and JSONB database strategies.**
