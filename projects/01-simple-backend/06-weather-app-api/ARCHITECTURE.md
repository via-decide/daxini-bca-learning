# Weather App API: Learn By Building

**"Build a proxy API that fetches live weather data, standardizes it, and caches the results to avoid external rate limits."**

---


## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data

**Question: What information must the system store?**
- Do we need a SQL database to store weather forever? Probably not. Weather is transient.
- We need a fast, temporary storage mechanism (Cache) that automatically deletes old data. Redis is perfect for this.

**After thinking, here's the data model:**
- A Key-Value store where the Key is the city name (e.g., `weather:london`) and the Value is the JSON response.

### Step 2: Architecture Diagram

```text
1. Client requests GET /api/weather?city=London
2. API checks Cache for key "weather:london"
3. IF CACHE HIT -> Return cached data immediately
4. IF CACHE MISS -> 
     a. Fetch from OpenWeatherMap using secret API key
     b. Transform messy OpenWeatherMap JSON into clean JSON
     c. Save to Cache with a TTL (Time To Live) of 600 seconds
     d. Return clean JSON to Client
```

### Step 3: Data Transformation (Adapter Pattern)
External APIs often return more data than you need, in weird formats.
**OpenWeatherMap Returns:**
`{"main": {"temp": 295.15}, "weather": [{"main": "Clouds", "description": "scattered clouds"}]}` (Temperature is in Kelvin!)

**Your API Returns:**
`{"city": "London", "temperature_celsius": 22, "condition": "Clouds"}`

---
