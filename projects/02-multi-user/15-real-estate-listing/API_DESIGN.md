## 🔌 API Design: Plan Before Coding

### 1. Search Nearby Properties
**GET `/api/properties/nearby?lat=34.05&lng=-118.24&radius_km=10`**
- **Logic**: Use the Haversine formula in your SQL query to calculate the distance between the input lat/lng and the rows in the database. Filter where distance < radius.

### 2. Get Property Details
**GET `/api/properties/:id`**
- **Logic**: Fetch the property, and `LEFT JOIN` the `property_images` to return the house details along with an array of image URLs.
