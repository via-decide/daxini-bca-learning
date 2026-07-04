-- Schema Design
Table: Snippets
- id: VARCHAR (Primary Key, e.g., "aX9b2" - short ID)
- language: VARCHAR (e.g., "python", "json", "plain")
- code: TEXT (SQL) or String (NoSQL)
- created_at: TIMESTAMP
- ip_address: VARCHAR (For rate limiting/spam blocking - optional but recommended)