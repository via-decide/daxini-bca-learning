-- 📱 QR Code Generator API: Database Schema

-- THIS FILE IS INTENTIONALLY EMPTY.

-- Why?
-- This project is a Stateless Microservice. 
-- It does not need a database. It receives an input, performs a 
-- computation (generating the image), and returns the output.
-- 
-- Once the HTTP request is finished, the server forgets it ever happened.
-- This architecture allows the service to handle millions of requests
-- simultaneously without worrying about database locks, scaling, or storage costs.