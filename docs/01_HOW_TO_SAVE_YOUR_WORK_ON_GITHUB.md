# 💾 How to Use Git & GitHub for This Repository

Since you are learning from the `daxini-bca-learning` repository, you need a way to write your code, save it safely, and potentially showcase it on the **Community Leaderboard**.

Because you don't have direct write-access to the main `via-decide` repository, you cannot just push code directly to it. Instead, you will use a standard open-source workflow called **Fork and Pull**.

Here is exactly how to utilize GitHub for this specific repository.

---

## 🔁 Step 1: Fork the Repository

A "Fork" is simply a personal copy of this entire repository that lives on your own GitHub account. You have full control over your fork.

1. Go to the top right of this repository page: [via-decide/daxini-bca-learning](https://github.com/via-decide/daxini-bca-learning)
2. Click the **Fork** button.
3. Leave the settings as default and click **Create fork**.

You now have a copy of the repo at `https://github.com/YOUR-USERNAME/daxini-bca-learning`.

---

## 💻 Step 2: Clone Your Fork Locally

Now you need to download your fork to your laptop so you can start writing code.

1. Open your Terminal or Command Prompt.
2. Navigate to where you want to save your work (e.g., `cd Documents/Projects`).
3. Run the clone command (replace with your username):
   ```bash
   git clone https://github.com/YOUR-USERNAME/daxini-bca-learning.git
   ```
4. Enter the folder:
   ```bash
   cd daxini-bca-learning
   ```

---

## 🌿 Step 3: Create a Branch for Your Project

Never write code directly on the `main` branch. Always create a new branch for the specific project you are building. This keeps your work organized.

For example, if you are starting the Gym Management project:
```bash
git checkout -b build-gym-management
```
*(`checkout -b` creates a new branch and switches you to it immediately).*

---

## 🏗️ Step 4: Write Your Code & Save (The 3-Step Process)

Now, navigate to the `projects/02-gym-management/` folder and start writing your code based on the `LEARNING_GUIDE.md`.

When you finish a feature (e.g., building the database schema), save your work using the standard Git flow:

### 1. Stage the files
```bash
git add .
```
*(This tells Git: "Get ready to save everything I just changed.")*

### 2. Commit the snapshot
```bash
git commit -m "feat: created database tables for members and attendance"
```
*(This tells Git: "Save this snapshot permanently with this descriptive message.")*

### 3. Push to your Fork
```bash
git push -u origin build-gym-management
```
*(This uploads your saved snapshot from your laptop to your GitHub fork.)*

---

## 🏆 Step 5: Get on the Leaderboard (Pull Request)

Once you have successfully built a project, you might want to show it off to the world! We track student progress on our main repository's **Leaderboard**.

To add your name to the Leaderboard:
1. Go to your fork on GitHub (`https://github.com/YOUR-USERNAME/daxini-bca-learning`).
2. You will see a banner saying your branch is ahead of `via-decide:main`. Click **Contribute** -> **Open Pull Request**.
3. In the PR description, explain which project you built and provide a link to your live hosted version (see [Where to Host Your Projects](./02_WHERE_TO_HOST_YOUR_PROJECTS.md)).
4. Submit the PR. 

Once approved by a maintainer, your work is merged into the official repository, and you are officially an open-source contributor! 🎉

---

## 🔄 Step 6: Keep Your Fork Updated

As the `via-decide` team adds new projects (up to 115!), your fork will fall behind. You need to "sync" it.

1. Switch back to your main branch:
   ```bash
   git checkout main
   ```
2. Add the original repository as an "upstream" source (you only do this once):
   ```bash
   git remote add upstream https://github.com/via-decide/daxini-bca-learning.git
   ```
3. Download the latest updates from the main repo:
   ```bash
   git fetch upstream
   ```
4. Merge those updates into your local main branch:
   ```bash
   git merge upstream/main
   ```
5. Push the updated main branch to your own fork:
   ```bash
   git push origin main
   ```

---

## 🚫 Critical Git Rule: The `.gitignore` file

**Stop! Do not commit everything!**
When building backend projects, some files should **never** be pushed to GitHub:
- Passwords, Database URIs, API Keys, and Secrets (e.g., `.env` files).
- Huge folders full of downloaded libraries (e.g., `node_modules/`, `venv/`).

**How to stop them?**
Ensure the `.gitignore` file in the root of the repository includes these sensitive files. If you add a new framework, make sure its junk files are ignored.

```text
# Example additions to .gitignore
node_modules/
.env
*.sqlite3
__pycache__/
```
