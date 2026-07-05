# 📝 Form Builder API (Typeform Clone): Learn By Building

**"Build a dynamic form engine where users can define custom questions, share links, and collect structured responses."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Validating Submissions Incorrectly

**Wrong:**
```javascript
// Loop through submitted answers and just insert them
req.body.answers.forEach(answer => {
  db.insert("answers", { submission_id: subId, question_id: answer.question_id, value: answer.value });
});
// Result: A user could skip required questions, or even submit answers for questions that don't belong to this form!
```

**Right:**
```javascript
// First, fetch the actual form questions from the DB
const formQuestions = db.query("SELECT id, is_required FROM questions WHERE form_id = ?", formId);

// Check that all required questions are present in the submission
formQuestions.forEach(q => {
  if (q.is_required) {
    const answered = req.body.answers.find(a => a.question_id === q.id);
    if (!answered) throw new Error(`Missing required question: ${q.id}`);
  }
});

// Only insert answers for questions that ACTUALLY belong to this form
req.body.answers.forEach(answer => {
  const isValidQuestion = formQuestions.find(q => q.id === answer.question_id);
  if (isValidQuestion) {
    db.insert("answers", { submission_id: subId, question_id: answer.question_id, value: answer.value });
  }
});
```

### ❌ Mistake 2: Storing Options in a Separate Table unnecessarily

**Wrong:**
```text
Table: question_options
- id
- question_id
- option_text (e.g. "Red")
- position
```
While technically fully normalized, retrieving a form with 10 questions and 5 options each requires complex JOINs or multiple queries just to render the form JSON to the frontend.

**Right:**
```text
Table: questions
- id
- text
- type: "radio"
- options: '["Red", "Blue", "Green"]' (JSON string)
```
For a form builder, the options are typically a static list associated with the question. Storing them as a serialized JSON array is dramatically easier to fetch and update, and perfectly suited for this use-case.

### ❌ Mistake 3: Exposing the Creator's ID on Public Forms

**Wrong:**
```javascript
// Public endpoint returns the raw form object
app.get('/api/published-forms/:id', (req, res) => {
  const form = db.query("SELECT * FROM forms WHERE id = ?", req.params.id);
  res.json(form); // Leaks user_id!
});
```

**Right:**
```javascript
// Public endpoint sanitizes the output
app.get('/api/published-forms/:id', (req, res) => {
  const form = db.query("SELECT title, description FROM forms WHERE id = ? AND is_published = 1", req.params.id);
  const questions = db.query("SELECT id, question_text, type, options, is_required FROM questions WHERE form_id = ?", req.params.id);
  
  res.json({
    title: form.title,
    description: form.description,
    questions: questions
  }); // Only safe, necessary data is sent
});
```

### ❌ Mistake 4: Missing Database Transactions

**Wrong:**
```javascript
// Inserting a submission and its answers
const subId = db.insert("submissions", { form_id: formId });
// Server crashes here!
insertAnswers(subId, answers);
// Result: An empty submission row is left in the database forever.
```

**Right:**
```javascript
db.transaction(() => {
  const subId = db.insert("submissions", { form_id: formId });
  answers.forEach(a => {
    db.insert("answers", { submission_id: subId, question_id: a.question_id, value: a.value });
  });
});
// Result: Either the submission and all answers are saved, or nothing is saved.
```

---
