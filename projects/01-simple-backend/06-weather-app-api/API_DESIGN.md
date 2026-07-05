# ⛅ Weather App API: API Design

**"Build a proxy API that fetches real-time weather from a third-party service, caches the results to save money and improve speed, and returns a clean, customized JSON response to your frontend."**

---

## 🔗 API Endpoints

### The Main Proxy Endpoint

```
GET    /api/weather/:city             → Fetch current weather for a city
GET    /api/weather/coordinates       → Fetch current weather by Lat/Lon
```

---

## 📦 Request/Response Examples

### 1. Fetching Weather for a City

**Request:**
```http
GET /api/weather/london HTTP/1.1
```

**Response (200):**
```json
{
  "city": "London",
  "temperature": {
    "celsius": 15.2,
    "fahrenheit": 59.3
  },
  "condition": "Cloudy",
  "icon_url": "https://openweathermap.org/img/wn/04d@2x.png",
  "humidity": 82,
  "wind_speed_kmh": 12.5,
  "meta": {
    "data_source": "cache",
    "last_updated": "2026-10-01T10:05:00Z",
    "expires_in_seconds": 300
  }
}
```

*Note the `meta` block. It tells the frontend if the data was fresh from the 3rd party API, or served instantly from the cache, and when it will expire.*

### 2. The Transformation (What OpenWeatherMap actually sends)

*For context, this is what the 3rd party API sends to your backend. Your API design's job is to hide this mess from the frontend:*

**Raw 3rd Party Response (DO NOT SEND THIS TO FRONTEND):**
```json
{
  "coord": { "lon": -0.1257, "lat": 51.5085 },
  "weather": [ { "id": 803, "main": "Clouds", "description": "broken clouds", "icon": "04d" } ],
  "base": "stations",
  "main": { "temp": 288.35, "feels_like": 288.11, "temp_min": 287.15, "temp_max": 289.26, "pressure": 1012, "humidity": 82 },
  "visibility": 10000,
  "wind": { "speed": 3.48, "deg": 240 },
  "clouds": { "all": 75 },
  "dt": 1696155000,
  "sys": { "type": 2, "id": 2075535, "country": "GB", "sunrise": 1696139400, "sunset": 1696181400 },
  "timezone": 3600,
  "id": 2643743,
  "name": "London",
  "cod": 200
}
```

---

## ⚠️ Error Responses

```json
// 404 Not Found (City does not exist)
{ "error": "City 'Atlantis' not found" }

// 429 Too Many Requests (Your backend rate limiting)
{ "error": "Please wait a moment before requesting weather again." }

// 502 Bad Gateway (OpenWeatherMap is down)
{ "error": "The weather provider is currently unavailable. Please try again later." }
```
