Here's the rewritten 'API_DESIGN.md' for 01 Url Shortener:

**URL Shortener: Learn By Building**

**System Overview**
The URL Shortener system is designed to shorten long URLs into shorter, more manageable links. This system will allow users to create custom short codes and track analytics for each shortened URL.

**Database Schema**
The database schema consists of three main tables: `urls`, `short_codes`, and `clicks`.

*   `urls` table:
    *   `id`: Unique identifier for the URL
    *   `long_url`: The original long URL
    *   `created_at`: Timestamp when the URL was created
    *   `updated_at`: Timestamp when the URL was last updated

*   `short_codes` table:
    *   `id`: Unique identifier for the short code
    *   `url_id`: Foreign key referencing the `urls` table
    *   `code`: The custom short code chosen by the user (if available)
    *   `created_at`: Timestamp when the short code was created

*   `clicks` table:
    *   `id`: Unique identifier for the click event
    *   `short_code_id`: Foreign key referencing the `short_codes` table
    *   `timestamp`: Timestamp when the click occurred
    *   `ip_address`: The IP address of the user who clicked the link

**API Endpoints**

### Endpoint 1: Create Short URL

Purpose: Create a short URL for a given long URL.

Request:
```
{
  "longUrl": "https://wikipedia.org/wiki/AI",
  "customCode": "ai" (optional)
}
```

Response (Success - 200):
```
{
  "shortCode": "ai",
  "shortUrl": "http://localhost:3000/ai",
  "longUrl": "https://wikipedia.org/wiki/AI"
}
```

Response (Error - 400):
```
{
  "error": "Invalid URL format"
}
```

Response (Error - 400):
```
{
  "error": "Custom code already exists"
}
```

Response (Error - 500):
```
{
  "error": "Database error"
}
```

### Endpoint 2: Redirect

Purpose: Redirect the user to the original long URL.

Request:
GET /ai

Response (Success - 302 Redirect):
Location: https://wikipedia.org/wiki/AI
(+ increment clicks in database)

Response (Error - 404):
```
{
  "error": "URL not found"
}
```

### Endpoint 3: Get Stats (Optional but good to include)

Purpose: Retrieve analytics for a given short URL.

Request:
GET /api/stats/ai

Response (Success - 200):
```
{
  "shortCode": "ai",
  "longUrl": "https://wikipedia.org/wiki/AI",
  "clicks": 42,
  "createdAt": "2026-01-15T10:30:00Z"
}
```

Response (Error - 404):
```
{
  "error": "URL not found"
}
```

**System Diagram**
Here's a high-level system diagram showing the relationships between the API endpoints and database tables:

```
          +---------------+
          |  Client    |
          +---------------+
                  |
                  | GET /api/shorten
                  v
          +---------------+
          |  Server     |
          +---------------+
                  |
                  | Create Short URL (Endpoint 1)
                  v
          +---------------+
          |  Database   |
          +---------------+
                  |
                  | Store URL and short code in urls table
                  | Increment clicks for the short code in clicks table
                  v
          +---------------+
          |  Client    |
          +---------------+
                  |
                  | GET /ai (Endpoint 2)
                  v
          +---------------+
          |  Server     |
          +---------------+
                  |
                  | Redirect to original long URL
                  v
          +---------------+
          |  Browser   |
          +---------------+
                  |
                  | Increment clicks for the short code in clicks table
                  v
          +---------------+
          |  Client    |
          +---------------+
                  |
                  | GET /api/stats/ai (Endpoint 3)
                  v
          +---------------+
          |  Server     |
          +---------------+
                  |
                  | Retrieve analytics for the short code
                  v
          +---------------+
          |  Database   |
          +---------------+
```

This system diagram shows the flow of requests and responses between the client, server, and database. It also highlights the key interactions between the API endpoints and database tables.

**Edge Cases**

*   What happens when a user tries to create a short code that already exists?
    *   The system should return an error message indicating that the custom code is already taken.
*   What happens when a user tries to access a non-existent short URL?
    *   The system should return a 404 error with a message indicating that the URL was not found.

**Why This Design?**
The design of this API is based on the principles of simplicity, scalability, and maintainability. By using a simple database schema and straightforward API endpoints, we can ensure that the system is easy to understand and use. Additionally, by incorporating analytics tracking and error handling, we can provide valuable insights into how users interact with the system and handle any potential issues that may arise.

I hope this rewritten content meets your expectations!