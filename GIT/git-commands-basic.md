# Git Basics
--

## Starting a Repository

### Create a New Repository
```bash
git init
```
Turns your current folder into a Git repository.

### Clone an Existing Repository
```bash
git clone <repository-url>
```
Downloads a copy of an existing repository from GitHub/GitLab/etc.

---

## Basic Workflow: Status & Add & Commit

### Check What Changed
```bash
git status
```
Shows which files you've modified, added, or deleted.

### Stage Files (Prepare to Commit)
```bash
git add <filename> ... <filename>   # Add one or many files
git add .                           # Add everything in current folder
git add -A                          # Add everything changed in project
```

Staging is choosing what to include in your next commit.

### Commit Changes (Save a Snapshot)
```bash
git commit -m "Your message"  # Commit with a message
git commit -am "Message"      # Stage and commit all tracked files with a message
```

A commit is a saved snapshot of your project at a specific point in time.

---

## Branching

Branches let you work on new features without affecting the main code.

### See All Branches
```bash
git branch
```
The branch with a `*` is your current branch.

### Create a New Branch
```bash
git branch <branch-name>
```

### Switch to a Branch
```bash
git checkout <branch-name>
```

### Create AND Switch in One Command
```bash
git checkout -b <branch-name>
```

### Delete a Branch
```bash
git branch -d <branch-name>
```

---

## Merging Branches

Merging combines changes from one branch into another.

### Merge a Branch into main
```bash
git checkout main              # Switch to the branch you want to update
git merge <branch-name>        # Bring in changes from another branch
```

### When Conflicts Happen

If Git can't automatically merge, you'll see conflict markers in your files:

```
<<<<<<< HEAD
Your current code
=======
Incoming code from the other branch
>>>>>>> feature-login
```

**To fix:**
1. Open the conflicted file
2. Choose which code to keep (or combine them)
3. Delete the conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
4. Save the file
5. Stage and commit:
```bash
git add <filename>
git commit -m "Resolved merge conflict"
```

---

## Complete Workflow Example

```bash
# 1. Create a new branch for your feature
git checkout -b work-branch

# 2. Make changes to your files
# ... edit ...

# 3. Stage and commit your changes
git add <filename>
git commit -m "Comment"

# 4. Make more changes and commit again
# ... edit ...
git add <filename>
git commit -m "Comment 2"

# 5. Switch back to main
git checkout main

# 6. Merge your feature into main
git merge work-branch

# 7. Delete the feature branch
git branch -d add-contact-form

# 8. Push changes
git push origin main
```

---

## Working with Remote Repositories (GitHub/GitLab)

### See Remote Connections
```bash
git remote -v
```

### Push Your Changes to Remote
```bash
git push origin <branch-name>
git push -u origin <branch-name>   #Pushing a new branch for the first time
```

Push sends your commits to GitHub/GitLab so others can see them.

### Pull Changes from Remote
```bash
git pull
```

Pull downloads new changes from the remote repository and merges them into your current branch.

---

## Quick Reference Card

| Command | What It Does |
|---------|-------------|
| `git init` | Start a new repository |
| `git clone <url>` | Download a repository |
| `git status` | See what changed |
| `git add <file>` | Stage files for commit |
| `git add .` | Stage all changes in repo |
| `git add -A` | Stage all changes in project |
| `git commit -m "message"` | Save a snapshot |
| `git branch` | List branches |
| `git branch <name>` | Create branch |
| `git checkout <branch>` | Switch branches |
| `git checkout -b <name>` | Create and switch to branch |
| `git merge <branch>` | Merge branch into current |
| `git push origin <branch>` | Upload to remote |
| `git pull` | Download from remote |

---

## Mental Model

- **Repository**: Your project folder with full history
- **Branch**: A parallel version of your code
- **Commit**: A saved checkpoint you can return to
- **Main/Master**: The primary branch (the "official" version)
- **Merge**: Combining changes from different branches
- **Remote**: The version on GitHub/GitLab (shared with team)

---

## Practice Exercise

```bash
# 1. Create a test repository
mkdir git-practice
cd git-practice
git init

# 2. Create a file and commit it
echo "Hello Git" > readme.txt
git add readme.txt
git commit -m "Initial commit"

# 3. Create a branch and make changes
git checkout -b test-branch
echo "Testing branches" >> readme.txt
git add readme.txt
git commit -m "Update readme"

# 4. Switch back and merge
git checkout main
git merge test-branch

# 5. Check your work
git log --oneline
```

---