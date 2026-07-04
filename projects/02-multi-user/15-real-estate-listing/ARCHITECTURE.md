# Real Estate Listing Platform (Zillow Clone)

## 🏗️ Architecture: Design Before Coding

**The Problem:**
Users want to find houses "within 5 miles of me". Real estate listings require geo-spatial data (Latitude/Longitude) and complex media (multiple images per house).

**The Solution:**
Use Spatial indexing (like PostGIS in PostgreSQL, or Haversine formula math) to calculate distance. Store property images in a 1-to-Many `Property_Images` table.

**Database Architecture:**
```text
Properties
├─ id
├─ agent_id
├─ price (DECIMAL)
├─ latitude (DECIMAL(9,6))
└─ longitude (DECIMAL(9,6))

Property_Images
├─ id
├─ property_id
├─ image_url
└─ is_primary (BOOLEAN)
```
