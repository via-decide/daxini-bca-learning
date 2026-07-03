# 📚 Tech Stacks & Terminology Guide

This guide maps all the technologies, programming languages, and technical terms used across the 115+ projects in the `daxini-bca-learning` repository. 

As a BCA student, you shouldn't just copy code—you should understand **what** these tools are and **why** we use them. Use this document as your learning dictionary.

---

## 🛠️ Core Technologies & Languages

### 1. Backend / Server
- **Node.js**: A runtime environment that allows you to run JavaScript on the server-side (not just in the browser). Used as the primary backend engine for our projects.
- **Express.js**: A minimal and flexible Node.js web application framework that provides a robust set of features for web and mobile applications. It handles routing and HTTP requests.

### 2. Frontend / Client
- **HTML5 (HyperText Markup Language)**: The standard markup language for documents designed to be displayed in a web browser. It provides the structure.
- **CSS3 (Cascading Style Sheets)**: Used for styling and laying out web pages (colors, fonts, grids, flexbox).
- **JavaScript (ES6+)**: The programming language that enables interactive web pages. Used heavily on both the client (DOM manipulation) and server (Node.js).
- **React**: A JavaScript library for building user interfaces based on UI components. (Mentioned as an advanced frontend option in full-stack projects).

### 3. Databases
- **SQLite**: A C-language library that implements a small, fast, self-contained, high-reliability, full-featured, SQL database engine. Perfect for learning relational databases without complex setup.
- **PostgreSQL**: A powerful, open-source object-relational database system. Often discussed as the production-ready upgrade to SQLite.
- **MongoDB**: A source-available cross-platform document-oriented database program. Classified as a NoSQL database program, which uses JSON-like documents with optional schemas.

---

## 🔐 Security & Authentication

- **JWT (JSON Web Tokens)**: An open standard (RFC 7519) that defines a compact and self-contained way for securely transmitting information between parties as a JSON object. Used for user login sessions.
- **bcrypt / bcryptjs**: A password-hashing function. Used to securely store user passwords in the database so that even if the database is hacked, the passwords remain unreadable.
- **RBAC (Role-Based Access Control)**: An approach to restricting system access to authorized users based on their role (e.g., Admin vs. Member in the Gym Management system).
- **Authorization vs. Authentication**: 
  - *Authentication*: Proving who you are (logging in).
  - *Authorization*: Checking if you have permission to do something (admin checking attendance).

---

## 🔌 Architecture & API Terms

- **API (Application Programming Interface)**: A set of rules that allows different software entities to communicate with each other. 
- **REST (Representational State Transfer)**: An architectural style for designing networked applications. RESTful APIs use HTTP requests to GET, PUT, POST, and DELETE data.
- **Endpoint**: A specific URL where an API can be accessed (e.g., `POST /api/shorten`).
- **MVC (Model-View-Controller)**: A software design pattern that divides the related program logic into three interconnected elements to separate internal representations of information from the ways information is presented to and accepted from the user.
- **HTTP Status Codes**:
  - `200 OK`: Request succeeded.
  - `301 / 302 Redirect`: The URL has moved (used heavily in the URL shortener).
  - `400 Bad Request`: The server cannot process the request due to a client error (e.g., invalid URL format).
  - `401 Unauthorized`: Authentication is required and has failed or has not yet been provided.
  - `403 Forbidden`: The client does not have access rights to the content.
  - `404 Not Found`: The server can not find the requested resource.
  - `500 Internal Server Error`: The server encountered an unexpected condition.

---

## 🗄️ Database Concepts

- **Relational Database**: A database structured to recognize relations among stored items of information (tables with rows and columns).
- **Primary Key**: A specific choice of a minimal set of attributes (columns) that uniquely specify a tuple (row) in a relation (table). E.g., `id`.
- **Foreign Key**: A column or group of columns in a relational database table that provides a link between data in two tables. E.g., `member_id` linking to the `members` table.
- **UNIQUE Constraint**: Ensures that all values in a column are different.
- **Database Transaction**: A unit of work performed within a database management system against a database, treated in a coherent and reliable way independent of other transactions. Used to ensure data integrity (e.g., creating a User and Member record simultaneously).
- **Normalization**: The process of structuring a database to reduce data redundancy and improve data integrity.

---

## 💻 General Engineering Terms

- **Pseudocode**: A plain language description of the steps in an algorithm or another system. Used in this repo to plan logic before writing actual code.
- **Base62 Encoding**: A way to convert numbers into a short string using 62 characters (A-Z, a-z, 0-9). Often used in generating short URLs.
- **Local Storage / IndexedDB**: Web storage mechanisms provided by browsers to store data locally on the user's computer (used in our Proof of Concept static builds).
- **Git / GitHub**: Version control systems for tracking changes in computer files and coordinating work on those files among multiple people.
- **Open Source**: Software for which the original source code is made freely available and may be redistributed and modified.
