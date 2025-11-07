# 🧭 GIT CHEAT SHEET — Everyday Commands for Ruby / Rails Projects

## 🔍 Check the Current State of Your Project

git status

## ➕ Stage Changes (All or Specific Files)

git add .
git add app/controllers/notes_controller.rb

## 💬 Commit Your Staged Changes with a Message

git commit -m "Describe what you changed"

## 🌿 Check and Manage Branches

git branch # See all branches
git switch -c feature/add-notes # Create and switch to a new branch
git switch main # Switch back to main
git branch -d feature/add-notes # Delete a local branch after merging

## 🔀 Merge a Branch into Main

git switch main
git merge feature/add-notes

## ⬆️ Push Your Changes to GitHub

git push origin main
git push origin feature/add-notes # Push a specific branch

## ⬇️ Pull the Latest Changes from GitHub

git pull origin main

## 📜 View Your Commit History (Short and Clean)

git log --oneline

## 🧹 Undo or Fix Mistakes

git restore --staged filename.rb # Unstage a file
git restore filename.rb # Discard local changes
git reset --soft HEAD~1 # Undo the last commit (keep changes)

## 💡 Pro Tips

git diff # Show unstaged file changes
git branch -m new-name # Rename the current branch
git push origin --delete branch-name # Delete a remote branch
git remote -v # Show remote repo connections

## 🧱 Example: Full Feature Branch Workflow

git switch -c feature/add-reviews

# (Edit your Rails files)

git add .
git commit -m "Add reviews controller"
git push origin feature/add-reviews

git switch main
git merge feature/add-reviews
git push origin main
