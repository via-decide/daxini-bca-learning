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


## ✅ Before Submission

- [ ] Is your OpenWeather API key stored strictly in a `.env` file?
- [ ] Does your cache successfully expire after 10 minutes?
- [ ] Did you implement an adapter to clean up the JSON response?
- [ ] Does the app handle invalid city names gracefully?

---

**Build this and learn: The Proxy pattern, caching strategies, and secure credential management.**
