# Weather App API: Learn By Building

**"Build a proxy API that fetches live weather data, standardizes it, and caches the results to avoid external rate limits."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **API Proxying** - Building a backend that securely talks to another backend (OpenWeatherMap)
✅ **In-Memory Caching** - Using Redis (or local memory) to cache data that changes frequently but not every millisecond
✅ **Data Transformation (Adapters)** - Taking a messy third-party JSON response and converting it into a clean, predictable format for your own frontend
✅ **Secret Management** - Safely storing API keys in `.env` files so they don't leak to GitHub
✅ **Error Handling** - Gracefully handling when the external weather service goes down

---

## 📋 Project Overview

### The Problem
If you build a weather app and the frontend directly calls the OpenWeatherMap API, you expose your secret API key to the entire internet. Anyone can steal it and use up your quota. Furthermore, if 10,000 users open your app in London at the same time, you'll hit OpenWeatherMap 10,000 times and get blocked. You need a middleman (proxy) that hides the key and caches the data.

### Who Uses It
```
Mobile App (Frontend):
├─ Requests: "Get weather for London"
└─ Receives: Clean JSON { temp: 22, condition: "Sunny" }

Backend Proxy (You):
├─ Hides the real API key
├─ Checks if London's weather was fetched in the last 10 minutes
└─ Fetches from OpenWeatherMap only if necessary
```

### The Big Picture

```text
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Mobile App  │ ──> │ Your Backend │ ──> │ Redis Cache  │
│  (Frontend)  │ <── │ (API Proxy)  │ <── │ (10 min TTL) │
└──────────────┘     └──────┬───────┘     └──────────────┘
                            │
                            │ (Cache Miss)
                            V
                     ┌──────────────┐
                     │ OpenWeather  │
                     │ Map API      │
                     └──────────────┘
```

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

## 🗄️ Database: Design, Don't Code

### Schema Design (Think Before SQL)

Since we are using Redis (a Key-Value store), there is no SQL schema. Instead, we design our **Keyspace**.

```text
Key Format: weather:{city_name_lowercase}
Example Key: weather:london
Value: '{"temp": 22, "condition": "Clouds"}'
TTL (Expiration): 600 seconds (10 minutes)
```

### Design Questions

1. **Why set a TTL of 10 minutes?**
   Weather doesn't change drastically every second. If 1,000 users ask for London's weather within 10 minutes, your API only hits OpenWeatherMap *once*. This saves massive amounts of money and API quota.

2. **What if the user types "LONDON", "london", or " London "?**
   Cache keys must be strictly normalized. Before checking the cache, the backend must `trim()` the string and convert it to `toLowerCase()`.

---

## 🔌 API Design: Plan Before Coding

### Endpoint 1: Get Current Weather
**GET `/api/weather?city=London`**
- **Purpose**: Fetch current weather for a specific city.
- **Response**: `200 OK`
```json
{
  "city": "London",
  "temperature_c": 22,
  "condition": "Rain",
  "source": "cache" // or "api", helpful for debugging
}
```

---

## 🧠 Implementation: Pseudocode First

```text
FUNCTION get_weather(request):
    raw_city = request.query.city
    
    // 1. Normalize Input
    city = lowercase(trim(raw_city))
    IF city is empty:
        RETURN ERROR 400 "City is required"
        
    cache_key = "weather:" + city
    
    // 2. Check Cache
    cached_data = Redis.get(cache_key)
    IF cached_data is NOT NULL:
        result = parse_json(cached_data)
        result.source = "cache"
        RETURN result
        
    // 3. Cache Miss - Fetch from External API
    api_key = ENVIRONMENT_VARIABLES.OPENWEATHER_KEY
    url = "https://api.openweathermap.org/data/2.5/weather?q=" + city + "&appid=" + api_key + "&units=metric"
    
    TRY:
        response = HTTP.GET(url)
        
        // 4. Transform Data
        clean_data = {
            city: response.name,
            temperature_c: response.main.temp,
            condition: response.weather[0].main,
            source: "api"
        }
        
        // 5. Save to Cache (Expire in 600 seconds)
        Redis.setex(cache_key, 600, to_json(clean_data))
        
        RETURN clean_data
        
    CATCH Error (e.g., 404 City Not Found):
        RETURN ERROR 404 "City not found"
```

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Hardcoding API Keys
**What's wrong:** Writing `const API_KEY = "123456789abc"` directly in your source code.
**Why it's bad:** When you push your code to GitHub, bots scan for API keys. They will steal it in seconds and use it for themselves.
**How to fix:** Store keys in a `.env` file, read them using environment variables (`process.env.API_KEY`), and add `.env` to your `.gitignore` file.

### ❌ Mistake 2: Not Handling External API Failures
**What's wrong:** Assuming OpenWeatherMap will always return a 200 OK response.
**Why it's bad:** If OpenWeatherMap is down, your API crashes and throws a stack trace to the frontend.
**How to fix:** Wrap external HTTP calls in `try/catch` blocks. If the external API fails, return a clean `502 Bad Gateway` error to your frontend.

---

## 🧪 Testing: How to Verify

### Test 1: Cache Verification
- Make a request for a city (e.g., `/api/weather?city=tokyo`). Look at the response time (e.g., 400ms) and the `source` field.
- Make the exact same request immediately after.
- The response time should be nearly instant (e.g., 5ms), and the `source` field should say "cache".

### Test 2: Error Propagation
- Make a request for a fake city (`/api/weather?city=GothamCity`).
- Ensure your API safely returns a `404 Not Found` with a clean JSON error message, rather than crashing the server.

---

## 🛠️ Debugging: When Things Break

### Problem: Cache misses are happening even for the same city
**Root Cause:** You forgot to normalize the city name before generating the cache key. "Paris" and "paris" are generating two different cache keys.
**Solution:** Ensure `city.toLowerCase().trim()` is applied before doing any cache lookups.

---

## 📚 Resources

- **Caching**: Redis Quick Start Guide
- **Environment Variables**: The Twelve-Factor App (Config)
- **External API**: OpenWeatherMap Current Weather API

---

## ✅ Before Submission

- [ ] Is your OpenWeather API key stored strictly in a `.env` file?
- [ ] Does your cache successfully expire after 10 minutes?
- [ ] Did you implement an adapter to clean up the JSON response?
- [ ] Does the app handle invalid city names gracefully?

---

**Build this and learn: The Proxy pattern, caching strategies, and secure credential management.**
