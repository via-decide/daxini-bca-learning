-- 📁 File Sharing API: Database Schema

CREATE TABLE shared_files (
  id TEXT PRIMARY KEY,                -- UUID
  
  original_filename TEXT NOT NULL,    -- E.g., "report.pdf"
  saved_filename TEXT NOT NULL,       -- E.g., "1696155000000-report.pdf"
  
  -- The absolute or relative path to where the file is physically stored
  file_path TEXT NOT NULL,            -- E.g., "/uploads/1696155000000-report.pdf"
  
  mime_type TEXT NOT NULL,            -- E.g., "application/pdf"
  size_bytes INTEGER NOT NULL,        -- File size in bytes
  
  -- If NULL, the file is public. If NOT NULL, it contains a bcrypt hash.
  password_hash TEXT,
  
  uploaded_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- We don't need complex indexes because we only query by Primary Key (id).