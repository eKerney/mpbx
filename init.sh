#!/bin/bash
# 1. Clone the source repo
git clone https://github.com/user/source-repo.git my-new-repo
# 2. Enter the directory
cd my-new-repo
# 3. Remove the old remote
git remote remove origin
# 4. Create a new empty repo on GitHub (via CLI or web)
gh repo create my-new-repo --public --source=. --remote=origin --push
Option B: Clean start (no history)
# 1. Clone the source repo
git clone https://github.com/user/sough repo create my-new-repo --public --source=. --remote=origin --pushrce-repo.git my-new-repo
# 2. Enter the directory
cd my-new-repo
# 3. Remove the old git history
rm -rf .git
# 4. Initialize a fresh git repo
git init
git add .
git commit -m "Initial commit"
# 5. Create new repo on GitHub and push
