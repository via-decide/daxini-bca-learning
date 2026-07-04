-- Schema Design
Table: EmailJobs
- id: UUID
- to_address: VARCHAR
- subject: VARCHAR
- body: TEXT
- send_at: TIMESTAMP (UTC)
- status: VARCHAR (Enum: 'pending', 'processing', 'completed', 'failed')
- retries: INT (Default 0)