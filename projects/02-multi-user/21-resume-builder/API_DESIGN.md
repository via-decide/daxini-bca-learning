## 🔌 API Design: Plan Before Coding

### 1. Auto-Save Resume
**PUT `/api/resumes/:id`**
- **Body**: `{ "content": { "education": [...], "experience": [...] } }`
- **Logic**: Simple `UPDATE resumes SET content = payload`.

### 2. Export to PDF
**GET `/api/resumes/:id/export`**
- **Logic**: 
  1. Fetch `content` from DB.
  2. Pass `content` to an HTML templating engine (like EJS or Handlebars).
  3. Send the HTML string to Puppeteer.
  4. Return the generated PDF buffer as a file download (`Content-Type: application/pdf`).
