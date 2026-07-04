## 🔌 API Design: Plan Before Coding

### 1. Add Task Dependency
**POST `/api/tasks/:id/depends-on`**
- **Body**: `{ "blocking_task_id": "uuid-123" }`
- **Logic**: Prevents circular dependencies (A blocks B, B blocks A).

### 2. Move Task Status
**PUT `/api/tasks/:id/status`**
- **Body**: `{ "status": "done" }`
- **Logic**: Check if all tasks in `task_dependencies` where `blocked_task_id = :id` have `status == 'done'`. If not, reject.
