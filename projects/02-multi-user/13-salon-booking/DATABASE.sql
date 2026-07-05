-- ✂️ Salon Booking API: Database Schema

-- 1. Users
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('admin', 'stylist', 'customer')),
  full_name TEXT NOT NULL
);

-- 2. Services (The Menu)
CREATE TABLE services (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  
  -- How long does this take? Crucial for the overlapping algorithm.
  duration_minutes INTEGER NOT NULL CHECK (duration_minutes > 0),
  
  -- Precise money storage
  price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 3. Stylist Services (Many-to-Many Junction Table)
-- Not all stylists can do all services.
CREATE TABLE stylist_services (
  stylist_id TEXT NOT NULL,
  service_id TEXT NOT NULL,
  
  FOREIGN KEY (stylist_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE,
  
  PRIMARY KEY (stylist_id, service_id)
);

-- 4. Appointments
CREATE TABLE appointments (
  id TEXT PRIMARY KEY,
  customer_id TEXT NOT NULL,
  stylist_id TEXT NOT NULL,
  service_id TEXT NOT NULL,
  
  appointment_date DATE NOT NULL,
  
  -- We store both start and end time to make overlap querying MUCH faster,
  -- even though end_time is technically derived from (start_time + service.duration)
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  
  status TEXT DEFAULT 'booked' CHECK (status IN ('booked', 'completed', 'cancelled')),
  
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (customer_id) REFERENCES users(id),
  FOREIGN KEY (stylist_id) REFERENCES users(id),
  FOREIGN KEY (service_id) REFERENCES services(id),
  
  -- Sanity check: An appointment must end after it starts
  CHECK (end_time > start_time)
);

-- INDEXES
-- We will constantly query "Does this stylist have an appointment on this date between X and Y times?"
CREATE INDEX idx_appointments_overlap ON appointments(stylist_id, appointment_date, start_time, end_time) WHERE status = 'booked';
