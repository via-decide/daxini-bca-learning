# ✉️ Email Scheduler API: Learn By Building

**"Build a background job system that accepts email content, schedules it for a specific time, and uses cron jobs or a worker queue to deliver it reliably."**

---

## 📚 Resources

**Background Workers & Cron:**
- Node-cron (for running scheduled tasks in Node): https://www.npmjs.com/package/node-cron
- setInterval in Node.js: https://developer.mozilla.org/en-US/docs/Web/API/setInterval
- Why `setTimeout` is bad for jobs: https://blog.logrocket.com/understanding-node-js-event-loop/

**Email Sending (SMTP):**
- Nodemailer (The standard Node.js email library): https://nodemailer.com/about/
- Mailtrap (Free fake SMTP server for testing, absolutely essential so you don't spam real people): https://mailtrap.io/

**Database & Concurrency:**
- Transactional Outbox Pattern: https://microservices.io/patterns/data/transactional-outbox.html
- Postgres `SELECT ... FOR UPDATE SKIP LOCKED` (How real queues work at scale): https://www.2ndquadrant.com/en/blog/what-is-select-skip-locked-for-in-postgresql-9-5/

**Dates & Timezones:**
- Working with UTC in JavaScript: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/toISOString

---
