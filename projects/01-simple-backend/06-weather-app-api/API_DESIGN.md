# Weather App API: Learn By Building

**"Build a proxy API that fetches live weather data, standardizes it, and caches the results to avoid external rate limits."**

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
