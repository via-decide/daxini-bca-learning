# Project Management System (Jira Clone)

## 🏗️ Architecture: Design Before Coding

**The Problem:**
Managing a project involves tracking tasks, but unlike a simple To-Do list, enterprise tasks have dependencies (Task B cannot start until Task A is done), sprints (time-boxed cycles), and milestones. 

**The Solution:**
We need an architecture that supports a directed acyclic graph (DAG) for dependencies, and hierarchical data (Workspace -> Project -> Sprint -> Task -> Subtask).

**Database Architecture:**
```text
Users
├─ id
└─ email

Projects
├─ id
├─ name
└─ owner_id

Sprints
├─ id
├─ project_id
├─ start_date
└─ end_date

Tasks
├─ id
├─ sprint_id (nullable)
├─ title
├─ status (ENUM: backlog, in_progress, review, done)
└─ assignee_id

Task_Dependencies
├─ parent_task_id
└─ child_task_id
```
