# 📝 Form Builder API (Typeform Clone): Learn By Building

**"Build a dynamic form engine where users can define custom questions, share links, and collect structured responses."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Dynamic Schemas** - How to store data when you don't know the schema ahead of time.  
✅ **EAV Pattern (Entity-Attribute-Value)** - Storing answers dynamically linked to variable questions.  
✅ **JSON in SQL** - When it's acceptable (and preferred) to store JSON arrays in a relational database.  
✅ **Authentication vs Public Access** - Designing an API that has both secured endpoints (creator) and public endpoints (respondent).  
✅ **Data Validation** - Validating incoming arbitrary payloads against dynamic rules (is_required).  
✅ **Cascade Deletes** - Managing orphaned rows automatically at the database level.  
✅ **Database Transactions** - Ensuring all parts of a complex submission save simultaneously.

---

## 📋 Project Overview

### The Problem

Standard web forms are hardcoded (e.g., a "Contact Us" form). But what if a user wants to build their *own* form without writing code? They need a tool like Google Forms or Typeform.

**Your job:** Build the backend engine that powers a dynamic form builder.

### Who Uses It

```
Form Creator (Authenticated):
├─ Create a new Form
├─ Add/Edit/Delete Questions (Text, Checkbox, Radio, Rating)
├─ Set required fields
├─ Publish the form
└─ View all responses in an analytics dashboard

Form Respondent (Public/Anonymous):
├─ View the published form
└─ Submit answers to the questions
```

---

## 🧠 Implementation Strategy: Pseudocode

### Create a Form & Questions

```pseudocode
POST /api/forms(title, description):
  Step 1: Authenticate
    Verify JWT token -> get user_id
    
  Step 2: Create Form
    form_id = database.insert("forms", { title, description, user_id })
    return { id: form_id, title }

POST /api/forms/:id/questions(text, type, options, is_required):
  Step 1: Authenticate and Authorize
    Verify JWT token -> get user_id
    Verify form belongs to user_id
    
  Step 2: Validate Question Type
    if type not in ["text", "radio", "checkbox", "rating"]:
      return error "Invalid type"
      
  Step 3: Handle Options JSON
    if type == "radio" or "checkbox":
      if not options or length(options) < 2:
        return error "Must provide at least 2 options"
      options_json = JSON.stringify(options)
    else:
      options_json = null
      
  Step 4: Save Question
    q_id = database.insert("questions", { form_id, text, type, options: options_json, is_required })
    return { id: q_id, text, type }
```

### Public View of Form

```pseudocode
GET /api/published-forms/:id
  Step 1: Fetch Form details
    form = database.query("SELECT title, description FROM forms WHERE id = ? AND is_published = true", id)
    if not form:
      return error 404 "Form not found or not published"
      
  Step 2: Fetch Questions
    questions = database.query("SELECT id, question_text, type, options, is_required, position FROM questions WHERE form_id = ? ORDER BY position ASC", id)
    
  Step 3: Format and Return
    // Parse the JSON options back into an array for the frontend
    foreach q in questions:
      if q.options: q.options = JSON.parse(q.options)
      
    return { form, questions }
```

### Submit Answers (The Complex Part)

```pseudocode
POST /api/published-forms/:id/submit(answers_array):
  Step 1: Fetch the actual form schema from DB
    form_questions = database.query("SELECT id, is_required FROM questions WHERE form_id = ?", id)
    
  Step 2: Validation Engine
    foreach db_question in form_questions:
      // Did they answer this question?
      user_answer = answers_array.find(a => a.question_id == db_question.id)
      
      if db_question.is_required and not user_answer:
        return error 400 "Missing required question"
        
  Step 3: Save Data Safely (Transaction)
    START TRANSACTION:
      // 1. Create the submission record
      sub_id = database.insert("submissions", { form_id: id, ip_address: request.ip })
      
      // 2. Insert all valid answers
      foreach user_answer in answers_array:
        // Only save if the question actually belongs to this form
        if form_questions.includes(user_answer.question_id):
          database.insert("answers", { 
            submission_id: sub_id, 
            question_id: user_answer.question_id, 
            value: user_answer.value 
          })
    COMMIT
    
  Step 4: Return success
    return { success: true, submission_id: sub_id }
```

---

## ✅ Before Submission

- [ ] Authentication works (Creator can login)
- [ ] Creator can build forms and add questions
- [ ] Questions support JSON arrays for options (like radio buttons)
- [ ] Form can be published
- [ ] Unauthenticated users can view published forms
- [ ] Validation engine enforces `is_required` rules during submission
- [ ] Unauthenticated users can submit answers
- [ ] Creator can view all submissions and their answers
- [ ] Deleting a form cascades and deletes all its questions, submissions, and answers
- [ ] Code is on GitHub

**Success:** A functioning dynamic form engine capable of generating and processing arbitrary data.
