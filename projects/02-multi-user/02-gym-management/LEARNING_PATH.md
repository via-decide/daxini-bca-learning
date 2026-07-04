# 💪 Gym Management System: Learn By Building

**"Build a complete system for managing gyms. Understand databases, roles, and complex workflows."**

---


## 🎯 Learning Outcomes

After completing this project, you will understand:

✅ **Multi-User Systems** - Admin vs Member roles and permissions  
✅ **Complex Data Models** - Members, memberships, attendance, workouts  
✅ **Relationships** - Foreign keys, joins, data integrity  
✅ **Authentication** - Login, JWT tokens, password hashing  
✅ **Authorization** - Role-based access control  
✅ **Business Logic** - Membership renewal, attendance tracking  
✅ **Full-Stack Development** - Frontend + Backend + Database  
✅ **Data Persistence** - Saving and retrieving relational data  

---


## 📋 Project Overview

### The Problem

Gyms need to manage:
- Members (who they are, contact info, when they joined)
- Memberships (what package, when expires, payment)
- Attendance (who came today, how long they stayed)
- Workouts (what exercises, progress tracking)
- Staff (admin dashboard, management tools)

**Your job:** Build a system for all this.

### Who Uses It

```
Admin User:
├─ Dashboard (stats, revenue, attendance)
├─ Manage Members (add, edit, delete)
├─ Manage Memberships (packages, renewals)
├─ View Attendance (daily, reports)
└─ Analytics (popular times, member retention)

Member User:
├─ Profile (personal info, membership status)
├─ Log Workouts (exercises, progress)
├─ View Attendance (check-in history)
└─ See Membership Status (expiration date)
```

---


## 🧠 Implementation Strategy: Pseudocode

### Login Flow

```pseudocode
POST /api/auth/login(email, password):
  Step 1: Find user by email
    user = database.query("SELECT * FROM users WHERE email = ?")
    if user not found:
      return error 401 "Invalid credentials"
  
  Step 2: Compare passwords
    passwordMatch = bcryptjs.compare(password, user.password_hash)
    if not match:
      return error 401 "Invalid credentials"
  
  Step 3: Generate JWT token
    token = jwt.sign(
      { userId: user.id, role: user.role },
      secret_key,
      { expiresIn: "7d" }
    )
  
  Step 4: Return token and user info
    return {
      token: token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role
      }
    }
```

### Add Member (Admin Only)

```pseudocode
POST /api/members(name, email, phone, age, weight, height):
  Step 1: Verify user is admin
    if request.user.role != "admin":
      return error 403 "Unauthorized"
  
  Step 2: Validate input
    if not email or not name or not phone:
      return error 400 "Missing required fields"
    
    if not isValidEmail(email):
      return error 400 "Invalid email"
  
  Step 3: Check if email already exists
    exists = database.query("SELECT id FROM users WHERE email = ?")
    if exists:
      return error 400 "Email already registered"
  
  Step 4: Create user and member records
    (This requires a transaction - both must succeed or both fail)
    
    START TRANSACTION:
      user_id = database.insert("users", { email, name, role: "member" })
      member_id = database.insert("members", {
        user_id,
        phone,
        age,
        weight,
        height,
        join_date: today
      })
    COMMIT
  
  Step 5: Return created member
    return { id: member_id, name, email, phone, age, weight, height }
```

### Mark Attendance

```pseudocode
POST /api/attendance(member_id):
  Step 1: Verify user is admin or is the member
    if request.user.role == "member":
      if request.user.id != member_id:
        return error 403 "Can't check in other members"
  
  Step 2: Verify member exists
    member = database.query("SELECT id FROM members WHERE id = ?")
    if not member:
      return error 404 "Member not found"
  
  Step 3: Check if already checked in today
    today = currentDate()
    existing = database.query(
      "SELECT id FROM attendance WHERE member_id = ? AND date = ? AND check_out IS NULL"
    )
    if existing:
      return error 400 "Already checked in"
  
  Step 4: Create attendance record
    attendance_id = database.insert("attendance", {
      member_id: member_id,
      date: today,
      check_in_time: now(),
      check_out_time: null,
      duration_minutes: null
    })
  
  Step 5: Return record
    return { id: attendance_id, member_id, check_in_time }
```

---


## ✅ Before Submission

- [ ] Authentication works (login, JWT)
- [ ] Role-based access works (admin vs member)
- [ ] All CRUD operations work
- [ ] Membership expiration checked
- [ ] Attendance tracking works
- [ ] Data persists across restarts
- [ ] Errors handled gracefully
- [ ] Can demo 5 features
- [ ] Can explain architecture
- [ ] Code is on GitHub

**Success:** A complete system that actually works, and you understand every part.
