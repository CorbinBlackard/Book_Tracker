# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...

# 🧭 GIT CHEAT SHEET — Everyday Commands for Ruby / Rails Projects

# 🔍 Check the current state of your project

git status

# ➕ Stage changes (all or specific files)

git add .
git add app/controllers/notes_controller.rb

# 💬 Commit your staged changes with a message

git commit -m "Describe what you changed"

# 🌿 Check and manage branches

git branch # See all branches
git switch -c feature/add-notes # Create and switch to a new branch
git switch main # Switch back to main
git branch -d feature/add-notes # Delete a local branch after merging

# 🔀 Merge a branch into main

git switch main
git merge feature/add-notes

# ⬆️ Push your changes to GitHub

git push origin main
git push origin feature/add-notes # Push a specific branch

# ⬇️ Pull the latest changes from GitHub

git pull origin main

# 📜 View your commit history (short and clean)

git log --oneline

# 🧹 Undo or fix mistakes

git restore --staged filename.rb # Unstage a file
git restore filename.rb # Discard local changes
git reset --soft HEAD~1 # Undo the last commit (keep changes)

# 💡 Pro tips

git diff # Show unstaged file changes
git branch -m new-name # Rename the current branch
git push origin --delete branch-name # Delete a remote branch
git remote -v # Show remote repo connections

# 🧱 Example: Full Feature Branch Workflow

git switch -c feature/add-reviews

# (edit your Rails files)

git add .
git commit -m "Add reviews controller"
git push origin feature/add-reviews
git switch main
git merge feature/add-reviews
git push origin main
