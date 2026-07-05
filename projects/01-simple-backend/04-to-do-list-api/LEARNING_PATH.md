# 📝 To-Do List API: Learn By Building

**"Build the classic To-Do list, but do it right: with user authentication, persistent database storage, and a clean RESTful API."**

---

## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **RESTful API Design** - Using GET, POST, PUT, PATCH, and DELETE correctly.  
✅ **Authentication (JWT)** - Generating and verifying JSON Web Tokens to secure endpoints.  
✅ **Data Isolation (Multi-Tenancy)** - Ensuring users can only access their own data, preventing IDOR vulnerabilities.  
✅ **Parameterized SQL** - Protecting against SQL Injection attacks.  
✅ **Relational Database Design** - Linking multiple tables (Users -> Tasks) using Foreign Keys.

---

## 📋 Project Overview

### The Problem

Every tutorial teaches you to build a To-Do list, but they usually skip the most important part: Security and Multiple Users. A real-world application must handle thousands of users logging in, adding their private data, and ensuring that no one else can see or modify it.

**Your job:** Build the backend for a production-ready, secure Task Management application.

### Who Uses It

```
The User:
├─ Signs up for an account
├─ Logs in to get a token
├─ Creates private tasks
├─ Marks tasks as complete
└─ Deletes old tasks
```

---

## 🧠 Implementation Strategy: Pseudocode

### 1. The Authentication Middleware

Before a request reaches your route logic, it must pass through this security checkpoint.

```javascript
function authenticateToken(req, res, next) {
  // 1. Get the token from the "Authorization: Bearer <token>" header
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];
  
  if (!token) return res.status(401).json({ error: "Missing token" });
  
  // 2. Verify the signature
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
    // 3. Attach the user info to the request for the next function to use!
    req.user = decoded; 
    
    // 4. Proceed to the actual route
    next();
  } catch (error) {
    return res.status(403).json({ error: "Invalid token" });
  }
}
```

### 2. Fetching Tasks (With Isolation)

```pseudocode
// Notice how we use the authenticateToken middleware here
GET /api/tasks (authenticateToken):
  Step 1: Extract User ID
    // We know this is safe because the middleware verified the JWT
    user_id = request.user.id
    
  Step 2: Query Database
    // CRITICAL: We only select tasks belonging to this user
    tasks = database.query("SELECT * FROM tasks WHERE user_id = ?", user_id)
    
  Step 3: Return
    return { tasks: tasks }
```

### 3. Creating a Task

```pseudocode
POST /api/tasks (authenticateToken):
  Step 1: Validate
    if !request.body.title:
      return 400 "Title is required"
      
  Step 2: Insert
    task_id = database.insert("tasks", {
      user_id: request.user.id, // Forced by the server, not the client!
      title: request.body.title,
      description: request.body.description || null,
      due_date: request.body.due_date || null
    })
    
  Step 3: Return
    return 201 Created
```

### 4. Updating a Task (The IDOR Protection)

```pseudocode
DELETE /api/tasks/:id (authenticateToken):
  Step 1: Execute Query
    // We attempt to delete, but ONLY if the user_id matches
    result = database.execute(
      "DELETE FROM tasks WHERE id = ? AND user_id = ?", 
      request.params.id, 
      request.user.id
    )
    
  Step 2: Check Result
    if result.affectedRows == 0:
      // Either it doesn't exist, OR the user is trying to delete someone else's task!
      return 404 "Task not found"
      
  Step 3: Success
    return 200 "Deleted"
```

---

## ✅ Before Submission

- [ ] Users can register and login to receive a JWT.
- [ ] Users can Create, Read, Update, and Delete their tasks.
- [ ] A user absolutely CANNOT read or modify another user's tasks.
- [ ] The `user_id` is extracted from the JWT token on the server, not trusted from the client's JSON payload.
- [ ] All database queries use parameterized inputs (e.g., `?` or `$1`) to prevent SQL Injection.
- [ ] Code is on GitHub.

**Success:** A secure, multi-tenant API that forms the basis of 90% of all SaaS applications in the world.
