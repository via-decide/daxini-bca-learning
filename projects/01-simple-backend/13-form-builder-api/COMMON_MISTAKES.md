# Form Builder API: Learn By Building

**"Build a dynamic API that allows users to define custom form fields (JSON schemas), and then strictly validates incoming submissions against those user-defined rules."**

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
