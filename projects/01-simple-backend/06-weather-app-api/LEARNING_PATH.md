# ⛅ Weather App API: Learn By Building

**"Build a proxy API that fetches real-time weather from a third-party service, caches the results to save money and improve speed, and returns a clean, customized JSON response to your frontend."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **The Proxy Pattern** - Creating a backend that sits between the client and a 3rd-party API to hide secrets and control traffic.  
✅ **Data Transformation (Adapter Pattern)** - Taking a complex, messy external JSON payload and mapping it into a clean, minimal interface for your frontend.  
✅ **Caching Mechanisms** - Storing data temporarily in a database (or memory) to dramatically reduce latency and API costs.  
✅ **Environment Variables** - Using `.env` files to securely store API keys.  
✅ **Outbound HTTP Requests** - Using libraries like `axios` or native `fetch` on the backend.

---

## 📋 Project Overview

### The Problem

Weather data updates relatively slowly (a few degrees per hour). If 1,000 users open your weather app in London within the same 5-minute window, it is highly inefficient and expensive to ask the weather provider for the temperature 1,000 times. You should ask them *once*, and serve the other 999 users from memory.

**Your job:** Build a smart API proxy that handles the heavy lifting, caching, and secret management.

### Who Uses It

```
The Frontend UI:
├─ Sends a simple request: "GET /api/weather/london"
└─ Receives a simple response: "{ temp: 15.2, condition: 'Cloudy' }"
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. The Core Proxy Endpoint

```pseudocode
GET /api/weather/:city:
  Step 1: Normalize City Name
    city = request.params.city.toLowerCase()
    
  Step 2: Check the Cache
    cached_data = database.query("SELECT * FROM weather_cache WHERE city_name = ?", city)
    
    // Check if it exists AND is less than 10 minutes old
    if cached_data and (NOW() - cached_data.fetched_at < 10 minutes):
      return 200 { 
        ...cached_data, 
        meta: { data_source: "cache" } 
      }
      
  Step 3: Cache Miss! Fetch from 3rd Party
    try:
      raw_json = http.get("https://api.openweathermap.org/...", { apiKey: ENV.API_KEY })
    catch error:
      if error.status == 404: return 404 "City not found"
      return 502 "Weather provider down"
      
  Step 4: Transform Data (Adapter)
    clean_data = {
      city_name: city,
      temperature_c: convertKelvinToCelsius(raw_json.main.temp),
      condition: raw_json.weather[0].main,
      icon_code: raw_json.weather[0].icon,
      humidity: raw_json.main.humidity,
      wind_speed: raw_json.wind.speed
    }
    
  Step 5: Save to Cache
    // We use UPSERT (Insert, or Replace if it already exists)
    database.execute(`
      INSERT INTO weather_cache (city_name, temperature_c, condition, icon_code, humidity, wind_speed, fetched_at)
      VALUES (?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)
      ON CONFLICT(city_name) DO UPDATE SET
        temperature_c = excluded.temperature_c,
        condition = excluded.condition,
        ...
        fetched_at = CURRENT_TIMESTAMP
    `, [clean_data...])
    
  Step 6: Return Fresh Data
    return 200 {
      ...clean_data,
      meta: { data_source: "live_api" }
    }
```

---

## ✅ Before Submission

- [ ] `.env` file contains your OpenWeatherMap API key. (DO NOT commit `.env` to GitHub!).
- [ ] Backend receives a city name and successfully fetches data from OpenWeatherMap.
- [ ] Backend transforms the data (e.g., converts Kelvin to Celsius, extracts only the necessary fields).
- [ ] Backend saves the result to the cache.
- [ ] Subsequent requests within 10 minutes serve the cached data (No outbound HTTP request is made).
- [ ] The API does not crash if a user enters an invalid city name.
- [ ] Code is on GitHub.

**Success:** You have implemented a production-grade Backend-For-Frontend (BFF) proxy with caching!
