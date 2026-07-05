# ⛅ Weather App API: Learn By Building

**"Build a proxy API that fetches real-time weather from a third-party service, caches the results to save money and improve speed, and returns a clean, customized JSON response to your frontend."**

---

## ⚠️ Common Mistakes

### ❌ Mistake 1: Leaking API Keys to the Frontend

**Wrong:**
```html
<!-- In index.html or React code -->
<script>
  fetch("https://api.openweathermap.org/data/2.5/weather?q=London&appid=8a7b6c5d4e3f2g1h...");
</script>
```
*Why it's bad:* Anyone can right-click your website, click "View Source", steal your API key, and use it in their own million-user app. Your credit card gets charged.

**Right:**
Keep the API key in a `.env` file on your backend server. The frontend only talks to your backend.

### ❌ Mistake 2: Missing Error Handling for Outbound Requests

**Wrong:**
```javascript
// Backend code
const response = await axios.get(`https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${key}`);
const data = response.data;
res.json({ temp: data.main.temp });
```
*Why it's bad:* If the user types a city that doesn't exist ("Atlantis"), OpenWeatherMap returns a 404. `axios.get` will throw an exception, crashing your Node.js server!

**Right:**
Always wrap outbound requests in a `try...catch` block.
```javascript
try {
  const response = await axios.get(`...`);
  res.json({ temp: response.data.main.temp });
} catch (error) {
  if (error.response && error.response.status === 404) {
    return res.status(404).json({ error: "City not found" });
  }
  return res.status(502).json({ error: "Upstream API error" });
}
```

### ❌ Mistake 3: Returning the raw 3rd-party JSON to the frontend

**Wrong:**
```javascript
const data = await fetchWeatherFromAPI();
res.json(data); // Sending back all 50 fields, including internal IDs and timestamps
```
*Why it's bad:* You are forcing the frontend developer to figure out how to parse OpenWeatherMap's confusing JSON structure. If you ever switch weather providers (e.g., from OpenWeatherMap to WeatherAPI.com), the JSON structure changes, and you break the frontend!

**Right (The Adapter Pattern):**
Your backend acts as an Adapter. It takes the messy 3rd-party JSON, extracts just the 4 fields the frontend needs, and creates a standardized response. If you switch providers later, you just update the Adapter logic on the backend, and the frontend never knows!

```javascript
const raw = await fetchWeatherFromAPI();
const cleanResponse = {
  city: raw.name,
  temp: raw.main.temp,
  condition: raw.weather[0].main
};
res.json(cleanResponse);
```

---
