# Weather App API: Learn By Building

**"Build a proxy API that fetches live weather data, standardizes it, and caches the results to avoid external rate limits."**

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
