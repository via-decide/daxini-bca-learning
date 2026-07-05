# ⛅ Weather App API: Learn By Building

**"Build a proxy API that fetches real-time weather from a third-party service, caches the results to save money and improve speed, and returns a clean, customized JSON response to your frontend."**

---

## 🧪 Testing Scenarios

### Scenario 1: The First Fetch (Cache Miss)

```
1. Make a GET request to `/api/weather/tokyo`
2. Expected: API takes ~500ms to respond.
3. Verify: The `meta.data_source` should say `"live_api"`.
4. Verify: The database `weather_cache` table should now have a row for `tokyo`.
```

### Scenario 2: The Second Fetch (Cache Hit)

```
1. Make a GET request to `/api/weather/tokyo` IMMEDIATELY after Scenario 1.
2. Expected: API takes ~10ms to respond (Lightning fast!).
3. Verify: The `meta.data_source` should say `"cache"`.
4. Verify Network: Your backend did NOT make a network request to OpenWeatherMap.
```

### Scenario 3: Cache Expiration

```
1. Wait 11 minutes (or manually change the `fetched_at` timestamp in your database to be 11 minutes ago).
2. Make a GET request to `/api/weather/tokyo`.
3. Expected: API takes ~500ms.
4. Verify: The `meta.data_source` should say `"live_api"`.
5. Verify: The database row should be updated with a new `fetched_at` timestamp.
```

### Scenario 4: Error Handling (3rd Party Down)

```
1. Change your OpenWeatherMap API key in your `.env` file to a fake, invalid string.
2. Make a GET request to `/api/weather/berlin`.
3. Expected: Your server SHOULD NOT CRASH.
4. Expected: The API should return a `502 Bad Gateway` or `500 Internal Server Error` with a JSON message: "Weather provider unavailable".
```

---
