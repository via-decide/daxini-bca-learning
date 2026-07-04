# To-Do List API: Learn By Building

**"Build the quintessential CRUD API with a twist: focus heavily on database relationships, pagination, and data validation."**

---


## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **CRUD Operations** - Creating, Reading, Updating, and Deleting data cleanly via REST
✅ **Data Validation** - Using schemas to ensure clients can't submit empty or malformed tasks
✅ **Pagination** - Returning data in chunks (e.g., 10 items per page) so the API scales
✅ **Soft Deletes** - Learning why we rarely actually `DELETE` data from a production database
✅ **HTTP Status Codes** - When to use 200, 201, 400, 404, and 500 correctly

---


## 📋 Project Overview

### The Problem
While a To-Do list sounds simple, it's the perfect isolated environment to learn how data moves between a client, a server, and a database. If you build a bad To-Do list, it crashes when someone submits 10,000 tasks. A good To-Do list handles pagination, validates inputs, and uses proper database practices like Soft Deletes.

### Who Uses It
```
Frontend App / Mobile App:
├─ Fetches tasks for the current view (Page 1)
├─ Sends a POST request to add a new task
└─ Sends a PATCH request when a user checks a box

Backend System (You):
├─ Receives the request
├─ Validates the data (Is the title empty?)
└─ Updates the database safely
```

### The Big Picture

```text
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Mobile App  │ ──> │ Backend API  │ ──> │  PostgreSQL  │
│  (Frontend)  │ <── │ (Controller) │ <── │  (Database)  │
└──────────────┘     └──────┬───────┘     └──────────────┘
                            │
                     ┌──────┴───────┐
                     │ Input Schema │
                     │  Validation  │
                     └──────────────┘
```

---


## 🧠 Implementation: Pseudocode First

```text
FUNCTION get_tasks(request):
    // 1. Extract Query Parameters with Defaults
    page = request.query.page OR 1
    limit = request.query.limit OR 10
    filter_status = request.query.status OR NULL
    
    // 2. Calculate Math for Pagination
    offset = (page - 1) * limit
    
    // 3. Build Query
    base_query = "SELECT * FROM tasks WHERE deleted_at IS NULL"
    
    IF filter_status IS NOT NULL:
        base_query += " AND status = :filter_status"
        
    // 4. Execute Query with Pagination
    final_query = base_query + " ORDER BY created_at DESC LIMIT :limit OFFSET :offset"
    results = Database.execute(final_query)
    
    // 5. Get Total Count for Metadata
    count_query = "SELECT COUNT(*) FROM tasks WHERE deleted_at IS NULL"
    total_items = Database.execute(count_query)
    total_pages = ceil(total_items / limit)
    
    // 6. Return standard paginated format
    RETURN {
        data: results,
        meta: {
            page: page,
            limit: limit,
            total_items: total_items,
            total_pages: total_pages
        }
    }
```

---


## ✅ Before Submission

- [ ] Does `DELETE` actually delete the row, or does it update `deleted_at`?
- [ ] Are you returning the correct HTTP status codes?
- [ ] Is input validation strictly enforced?
- [ ] Does pagination metadata accurately reflect the total number of items?

---

**Build this and learn: The foundational mechanics of every web backend in existence.**
