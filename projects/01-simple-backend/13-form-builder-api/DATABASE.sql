-- Schema Design
Table: Forms
- id: UUID (Primary Key)
- title: VARCHAR
- schema: JSONB (Stores the array of field definitions)

Table: Submissions
- id: UUID (Primary Key)
- form_id: UUID (Foreign Key)
- answers: JSONB (Stores the user's data payload)
- submitted_at: TIMESTAMP