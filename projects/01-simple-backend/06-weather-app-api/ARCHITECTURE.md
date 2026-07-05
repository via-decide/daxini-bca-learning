# ⛅ Weather App API: Learn By Building

**"Build a proxy API that fetches real-time weather from a third-party service, caches the results to save money and improve speed, and returns a clean, customized JSON response to your frontend."**

---

## 🏗️ Architecture: Design Before Coding

### Step 1: Understand the Data (Design Yourself First)

**Question: What information must the system store?**

Think about these scenarios:
1. User requests weather for "London".
2. Your backend has no idea what the weather is in London.
3. Your backend calls a 3rd-party API (like OpenWeatherMap).
4. The 3rd-party API charges you $0.01 per request. If 1,000 users check the weather for London at the same time, you pay $10 for the exact same data.
5. You need to temporarily store (cache) the London weather for 10 minutes so subsequent requests are free and lightning fast.

**What data do you need for each?**

After thinking, here's the data model:

```
Weather_Cache (Temporary Storage)
├─ city_name (Primary Key / Unique identifier)
├─ temperature
├─ description (e.g. "Cloudy")
├─ icon (e.g. "04d")
├─ humidity
├─ wind_speed
└─ fetched_at (Timestamp - Crucial for knowing when the data is stale)
```
*(Note: A simple weather app doesn't strictly need a "Users" table unless you want to save favorite cities, but we will focus on the caching architecture here).*

---

### Step 2: The API Proxy Pattern (Why not just call OpenWeatherMap from the Frontend?)

**Bad Idea (Frontend calls OpenWeatherMap directly):**
```javascript
// React Frontend
const response = await fetch(`https://api.openweathermap.org/data/2.5/weather?q=London&appid=YOUR_SECRET_API_KEY`);
```
*Why it's bad:*
1. **Security:** Your secret API key is shipped to the user's browser. Anyone can view the source code, steal your key, and rack up a $5,000 bill on your credit card.
2. **Cost:** Every single page load hits the 3rd-party API.
3. **Data Bloat:** OpenWeatherMap returns 50 fields of data. Your app only needs 4. You are wasting the user's bandwidth.

**Good Idea (The Backend Proxy):**
```javascript
// React Frontend calls YOUR backend
const response = await fetch(`https://your-api.com/api/weather/London`);
```
*Why it's good:*
1. Your secret API key stays safely on your server.
2. You can implement caching to save money.
3. You can strip out the 46 useless fields and only send the 4 you need.

---

### Step 3: Database / Cache Architecture

```
┌──────────────────────────────────────────┐
│              Database / Cache            │
├──────────────────────────────────────────┤
│                                          │
│  weather_cache                           │
│  (Can be SQLite, Postgres, or Redis)     │
│                                          │
└──────────────────────────────────────────┘
```
*For this project, SQLite or an in-memory object/Map is fine. For production, you would use Redis.*

---

### Step 4: System Architecture

```
┌────────────────────────────────────────────┐
│          Frontend (React/HTML/Mobile)      │
│  ┌──────────────────────────────────────┐  │
│  │ Search Bar ("Enter City")            │  │
│  │ Weather Display (Temp, Icon)         │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        HTTP GET /api/weather/:city
              │
              ▼
┌────────────────────────────────────────────┐
│       Backend (Node.js Express)            │
│  ┌──────────────────────────────────────┐  │
│  │ 1. Check Database/Cache for City     │  │
│  │ 2. Is data < 10 mins old?            │  │
│  │    YES -> Return Cached Data (Fast)  │  │
│  │    NO  -> Make outbound HTTP request │  │
│  │           to OpenWeatherMap          │  │
│  │ 3. Transform complex response into   │  │
│  │    clean, simple JSON                │  │
│  │ 4. Save to Database/Cache            │  │
│  │ 5. Return JSON to Frontend           │  │
│  └──────────────────────────────────────┘  │
└────────────────────────────────────────────┘
              │
        (If Cache Miss)
              │
              ▼
┌────────────────────────────────────────────┐
│      3rd Party (OpenWeatherMap API)        │
│  - Requires Secret API Key                 │
│  - Returns massive JSON payload            │
└────────────────────────────────────────────┘
```
