-- 🖼️ Image Gallery API: Database Schema

CREATE TABLE images (
  id TEXT PRIMARY KEY,                -- UUID
  uploader_name TEXT NOT NULL,
  
  original_filename TEXT NOT NULL,    -- E.g., "vacation.jpg"
  saved_filename TEXT NOT NULL,       -- E.g., "1696155000000-vacation.jpg"
  
  -- The relative URL path the frontend uses to fetch the image
  file_path TEXT NOT NULL,            -- E.g., "/uploads/1696155000000-vacation.jpg"
  
  mime_type TEXT NOT NULL,            -- E.g., "image/jpeg" or "image/png"
  size_bytes INTEGER NOT NULL,        -- File size in bytes (for analytics/quotas)
  
  uploaded_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Index for fetching the gallery feed efficiently (newest first)
CREATE INDEX idx_images_uploaded_at ON images(uploaded_at DESC);
