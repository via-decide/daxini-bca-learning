-- Schema Design
Table: Secrets
- id: UUID (Primary Key, e.g., "8f2c-49a3...")
- message: TEXT
- current_views: INT (Default 0)
- max_views: INT
- expires_at: TIMESTAMP
- created_at: TIMESTAMP