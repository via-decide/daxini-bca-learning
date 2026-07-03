# 💾 How to Save & Upload Your Work (Git & GitHub)

You've finished coding your project locally on your laptop. Congratulations! 🎉

But if your laptop crashes, your code is gone. And if you want to show your code to an employer or teacher, you can't just hand them your laptop.

You need to save your work to **GitHub**. Here is exactly how to do it.

---

## The 3-Step Process (Add, Commit, Push)

Open your terminal or command prompt inside your project folder and run these three commands every time you finish working on a feature:

### Step 1: `git add .`
**What it does:** Stages your files.
**Analogy:** Imagine you are taking photos. `git add .` is like selecting which photos you want to put into a photo album. The `.` means "select all photos (files) that have changed."

### Step 2: `git commit -m "your message here"`
**What it does:** Saves a snapshot of your staged files.
**Analogy:** This is writing a caption for the photos and officially gluing them into the album. The message should explain *what* you changed.
*Example:* `git commit -m "built the login page"`

### Step 3: `git push`
**What it does:** Uploads your commits to the internet (GitHub).
**Analogy:** This is taking your physical photo album and putting a copy of it in a secure cloud drive so everyone can see it and it's safe from fire.

---

## The Full Workflow (From Scratch)

If this is a brand new project and you haven't linked it to GitHub yet:

1. Go to [GitHub.com](https://github.com) and create a **New Repository**. Do not initialize it with a README.
2. Open your terminal in your project folder.
3. Run these commands:
   ```bash
   git init
   git add .
   git commit -m "initial commit: project started"
   git branch -M main
   git remote add origin https://github.com/YourUsername/YourRepoName.git
   git push -u origin main
   ```

*(You only have to do this once per project! After this, just use the 3-Step Process above).*

---

## 🚫 Stop! Don't commit everything!
Some things should **never** be pushed to GitHub:
- Passwords, API Keys, and Secrets (e.g., `.env` files).
- Huge folders full of downloaded libraries (e.g., `node_modules`).

**How to stop them?**
Create a file named `.gitignore` in your project folder and type the names of the files/folders you want Git to ignore.

```text
# Example .gitignore
node_modules/
.env
```
