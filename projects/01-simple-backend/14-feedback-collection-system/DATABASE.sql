-- Schema Design
Table: Feedback
- id: UUID
- page_url: VARCHAR (e.g., "/blog/post-1")
- rating: INT (1 to 5)
- user_hash: VARCHAR (Hashed IP)
- created_at: TIMESTAMP