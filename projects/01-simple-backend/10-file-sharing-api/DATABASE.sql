-- Schema Design
Table: Files
- id: UUID (Primary Key)
- original_name: VARCHAR (e.g., "vacation_photo.jpg")
- mime_type: VARCHAR (e.g., "image/jpeg")
- size_bytes: INT
- local_path: VARCHAR (e.g., "/app/uploads/8f2c.jpg")
- created_at: TIMESTAMP