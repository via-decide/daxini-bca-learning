# 📚 E-Learning Platform: Learn By Building

**"Build a complete online learning system with courses, videos, quizzes, and progress tracking. Master full-stack education technology."**

---


## 🏗️ Architecture: System Design

### Step 1: Key Entities

**Question: What are the main things in an e-learning system?**

Think about:
1. What information describes a course?
2. How does a student enroll?
3. How is progress tracked?
4. What makes a quiz?
5. How are grades calculated?

**Core Entities:**

```
Course (What's being taught)
├─ Title, Description, Instructor
├─ Duration, Level (beginner/intermediate/advanced)
├─ Price or Free
├─ Category
└─ Thumbnail/Preview

Lesson (Parts of a course)
├─ Order in course
├─ Title
├─ Duration
├─ Video URL
├─ Description
└─ Prerequisites

Video Lesson (Specific type of lesson)
├─ Video file/streaming URL
├─ Duration
├─ Resolution options
├─ Captions available?
└─ Downloadable?

Quiz (Assessment)
├─ Course it belongs to
├─ Questions
├─ Pass percentage
├─ Time limit (if any)
├─ Retake allowed?
└─ Max attempts

Question (Part of quiz)
├─ Type (multiple choice, true/false, essay)
├─ Text
├─ Options (if multiple choice)
├─ Correct answer
├─ Points
└─ Explanation

Enrollment (Student in course)
├─ Student
├─ Course
├─ Enrollment date
├─ Payment status
├─ Access expiration (if limited)
└─ Status (active/completed/dropped)

Progress (What student has done)
├─ Student
├─ Course
├─ Lessons completed
├─ Lessons viewed
├─ Current lesson
├─ Time spent
└─ Last accessed

Quiz Attempt (Student took quiz)
├─ Student
├─ Quiz
├─ Attempt number
├─ Answers submitted
├─ Score
├─ Time taken
├─ Date
└─ Passed?

Grade (Final assessment)
├─ Student
├─ Course
├─ Quiz scores average
├─ Assignment scores average
├─ Final grade
├─ Grade letter (A/B/C/D/F)
└─ Date

Certificate (Proof of completion)
├─ Student
├─ Course
├─ Issue date
├─ Certificate URL
└─ Verification code
```

### Step 2: Architecture Diagram

```
┌──────────────────────────────────────────────────────┐
│              Frontend (React/Vue)                    │
│  ┌────────────────────────────────────────────────┐  │
│  │ Pages:                                          │  │
│  │ - Course Browse/Search                         │  │
│  │ - Course Details (Preview)                     │  │
│  │ - Video Player                                 │  │
│  │ - Quiz Interface                               │  │
│  │ - Progress Dashboard                           │  │
│  │ - Certificate Generator                        │  │
│  │ - Instructor Dashboard                         │  │
│  │ - Admin Panel                                  │  │
│  └────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────┘
                          │
                    HTTP/WebSocket
                          │
         ┌────────────────┴────────────────┐
         │                                 │
         ▼                                 ▼
┌─────────────────────────────┐  ┌──────────────────────┐
│    API Server (Node/Django) │  │  Video Streaming     │
│                             │  │  (CDN or own server) │
│ Routes:                     │  │                      │
│ - /api/courses              │  │ Serves video files   │
│ - /api/courses/:id          │  │ Handles streaming    │
│ - /api/enroll               │  │ Adaptive bitrate     │
│ - /api/progress             │  └──────────────────────┘
│ - /api/quiz                 │
│ - /api/quiz/submit          │
│ - /api/grades               │
│ - /api/certificates         │
│ - /admin/*                  │
└─────────────────────────────┘
         │
    SQL Queries
         │
         ▼
┌──────────────────────────────┐
│ Database (PostgreSQL/SQLite) │
│ Tables:                      │
│ - courses                    │
│ - lessons                    │
│ - videos                     │
│ - quizzes                    │
│ - questions                  │
│ - enrollments                │
│ - progress                   │
│ - grades                     │
│ - certificates               │
│ - quiz_attempts              │
└──────────────────────────────┘
```

### Step 3: Data Flow

**Scenario: Student takes a course**

```
1. Student browses courses
   - Query: GET /api/courses?category=programming
   - Returns: List of courses with preview

2. Student views course details
   - Query: GET /api/courses/123
   - Returns: Full course info, price, lessons preview

3. Student enrolls
   - API: POST /api/enroll
   - Create enrollment record
   - Update access permissions

4. Student views first lesson
   - Query: GET /api/lessons/456
   - Returns: Video URL, title, description
   - Create progress record

5. Student watches video
   - Streaming server streams video in chunks
   - Frontend tracks watch time
   - Periodic updates: POST /api/progress (60 seconds)

6. Student completes lesson
   - Frontend: Mark lesson as complete
   - API: POST /api/progress/complete
   - Update progress record

7. Student takes quiz
   - Query: GET /api/quiz/789
   - Returns: Questions (don't reveal answers yet)

8. Student submits answers
   - API: POST /api/quiz/submit
   - Server grades automatically
   - Returns: Score, correct answers, explanations

9. Student views grade
   - Query: GET /api/grades/123 (course)
   - Calculates: Quiz average, assignment average
   - Returns: Final grade, performance summary

10. Student completes course
    - All lessons completed + quiz passed
    - Generate certificate
    - POST /api/certificates
    - Email certificate link
```

---
