/*
## 🗄️ Database: Design, Don't Code

### Schema Design (Think Before SQL)

*No database required for this specific microservice!*

### Design Questions

1. **Why is it dangerous to send the raw password to the HIBP API?**
   If Have I Been Pwned is monitoring network traffic, or gets hacked, the attacker would see exactly what password your user is trying to set. 

2. **How does k-Anonymity solve this?**
   You hash the password using SHA-1. You only send the *first 5 characters* of the hash to the API. The API returns thousands of passwords that happen to start with those 5 characters. Your server then checks the list locally to see if your full hash is on it. The external API never knows which of the thousands of passwords you were actually checking.

---

*/