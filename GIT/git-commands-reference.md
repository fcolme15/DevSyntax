# Git Commands Reference

A comprehensive guide to essential Git commands every developer should know.

---

## Table of Contents
- [Setup & Configuration](#setup--configuration)
- [Repository Initialization](#repository-initialization)
- [Basic Workflow](#basic-workflow)
- [Branching](#branching)
- [Merging](#merging)
- [Remote Repositories](#remote-repositories)
- [Viewing History & Status](#viewing-history--status)
- [Undoing Changes](#undoing-changes)
- [Stashing](#stashing)
- [Tagging](#tagging)
- [Advanced Operations](#advanced-operations)

---

## Setup & Configuration

### Set Your Identity
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### View Configuration
```bash
git config --list
git config user.name  # View specific setting
```

### Set Default Branch Name
```bash
git config --global init.defaultBranch main
```

### Set Default Editor
```bash
git config --global core.editor "code --wait"  # VS Code
git config --global core.editor "vim"          # Vim
```

---

## Repository Initialization

### Initialize a New Repository
```bash
git init
```
Creates a new Git repository in the current directory.

### Clone an Existing Repository
```bash
git clone <repository-url>
git clone <repository-url> <directory-name>  # Clone into specific directory
```

---

## Basic Workflow

### Check Repository Status
```bash
git status
```
Shows modified files, staged files, and untracked files.

### Stage Files
```bash
git add <file>              # Stage specific file
git add <file1> <file2>     # Stage multiple files
git add .                   # Stage all changes in current directory
git add -A                  # Stage all changes in entire repository
git add *.js                # Stage all JS files
```

### Unstage Files
```bash
git reset <file>            # Unstage specific file
git reset                   # Unstage all files
```

### Commit Changes
```bash
git commit -m "Commit message"
git commit -am "Message"    # Stage and commit all tracked files
git commit --amend          # Modify the last commit
git commit --amend -m "New message"  # Change last commit message
```

### Remove Files
```bash
git rm <file>               # Remove file and stage deletion
git rm --cached <file>      # Remove from Git but keep in filesystem
```

### Move/Rename Files
```bash
git mv <old-name> <new-name>
```

---

## Branching

### List Branches
```bash
git branch                  # List local branches
git branch -r               # List remote branches
git branch -a               # List all branches (local + remote)
```

### Create a Branch
```bash
git branch <branch-name>    # Create branch (doesn't switch to it)
```

### Switch Branches
```bash
git checkout <branch-name>          # Switch to existing branch
git checkout -b <branch-name>       # Create and switch to new branch
git switch <branch-name>            # Modern way to switch branches
git switch -c <branch-name>         # Modern way to create and switch
```

### Delete a Branch
```bash
git branch -d <branch-name>         # Delete branch (safe - prevents if unmerged)
git branch -D <branch-name>         # Force delete branch
git push origin --delete <branch-name>  # Delete remote branch
```

### Rename a Branch
```bash
git branch -m <old-name> <new-name>     # Rename any branch
git branch -m <new-name>                # Rename current branch
```

---

## Merging

### Merge a Branch into Current Branch
```bash
git merge <branch-name>
```
Merges the specified branch into your current branch.

### Fast-Forward Merge
```bash
git merge --ff-only <branch-name>
```
Only merge if it can be fast-forwarded (no divergent changes).

### No Fast-Forward Merge
```bash
git merge --no-ff <branch-name>
```
Always create a merge commit, even if fast-forward is possible.

### Abort a Merge
```bash
git merge --abort
```
Cancel the merge and return to pre-merge state.

### Handling Merge Conflicts

When conflicts occur:

1. **View conflicted files:**
```bash
git status
```

2. **Open conflicted files** - Look for conflict markers:
```
<<<<<<< HEAD
Your changes
=======
Their changes
>>>>>>> branch-name
```

3. **Resolve conflicts** - Edit files to resolve, removing conflict markers

4. **Stage resolved files:**
```bash
git add <resolved-file>
```

5. **Complete the merge:**
```bash
git commit  # Opens editor with default merge message
```

### View Merge Conflicts
```bash
git diff                    # View unstaged changes
git diff --staged           # View staged changes
git diff <branch1> <branch2>  # Compare branches
```

---

## Remote Repositories

### View Remotes
```bash
git remote                  # List remotes
git remote -v               # List remotes with URLs
git remote show origin      # Show details about remote
```

### Add a Remote
```bash
git remote add <name> <url>
git remote add origin https://github.com/user/repo.git
```

### Remove a Remote
```bash
git remote remove <name>
```

### Rename a Remote
```bash
git remote rename <old-name> <new-name>
```

### Fetch Changes
```bash
git fetch                   # Fetch all remotes
git fetch origin            # Fetch specific remote
git fetch origin <branch>   # Fetch specific branch
```
Downloads changes but doesn't merge them.

### Pull Changes
```bash
git pull                    # Fetch and merge current branch
git pull origin <branch>    # Pull specific branch
git pull --rebase           # Fetch and rebase instead of merge
```

### Push Changes
```bash
git push                    # Push current branch to remote
git push origin <branch>    # Push specific branch
git push -u origin <branch> # Push and set upstream tracking
git push --all              # Push all branches
git push --tags             # Push all tags
git push --force            # Force push (dangerous - overwrites remote)
git push --force-with-lease # Safer force push (checks remote state)
```

### Set Upstream Branch
```bash
git branch --set-upstream-to=origin/<branch> <local-branch>
git push -u origin <branch>  # Push and set upstream
```

---

## Viewing History & Status

### View Commit History
```bash
git log                     # Full commit history
git log --oneline           # Condensed view
git log --graph             # Show branch graph
git log --all --graph --oneline  # Full graph of all branches
git log -n 5                # Show last 5 commits
git log --since="2 weeks ago"
git log --author="Name"
git log <file>              # History of specific file
git log <branch>            # History of specific branch
```

### View Commit Details
```bash
git show <commit-hash>      # Show commit details
git show HEAD               # Show last commit
git show HEAD~2             # Show 2 commits ago
```

### View Changes
```bash
git diff                    # Unstaged changes
git diff --staged           # Staged changes
git diff HEAD               # All changes since last commit
git diff <commit1> <commit2>  # Compare commits
git diff <branch1> <branch2>  # Compare branches
```

### View File at Specific Commit
```bash
git show <commit>:<file>
```

### Search Commits
```bash
git log --grep="keyword"    # Search commit messages
git log -S "code"           # Search for code changes
```

---

## Undoing Changes

### Discard Unstaged Changes
```bash
git checkout -- <file>      # Discard changes in specific file
git checkout .              # Discard all unstaged changes
git restore <file>          # Modern way (Git 2.23+)
git restore .               # Restore all files
```

### Unstage Files
```bash
git reset <file>            # Unstage specific file
git reset                   # Unstage all
git restore --staged <file> # Modern way
```

### Undo Commits

**Keep changes in working directory:**
```bash
git reset --soft HEAD~1     # Undo last commit, keep changes staged
git reset HEAD~1            # Undo last commit, keep changes unstaged
git reset --mixed HEAD~1    # Same as above (default)
```

**Discard changes completely:**
```bash
git reset --hard HEAD~1     # Undo last commit and discard changes
git reset --hard <commit>   # Reset to specific commit
```

### Revert a Commit
```bash
git revert <commit-hash>    # Create new commit that undoes changes
git revert HEAD             # Revert last commit
```
Creates a new commit that reverses changes (safer for shared branches).

### Clean Untracked Files
```bash
git clean -n                # Dry run (show what would be deleted)
git clean -f                # Delete untracked files
git clean -fd               # Delete untracked files and directories
```

---

## Stashing

### Save Work Temporarily
```bash
git stash                   # Stash changes
git stash save "message"    # Stash with description
git stash -u                # Include untracked files
git stash --all             # Include untracked and ignored files
```

### View Stashes
```bash
git stash list              # List all stashes
git stash show              # Show latest stash changes
git stash show stash@{0}    # Show specific stash
```

### Apply Stashes
```bash
git stash apply             # Apply latest stash (keeps stash)
git stash apply stash@{2}   # Apply specific stash
git stash pop               # Apply and remove latest stash
git stash pop stash@{1}     # Apply and remove specific stash
```

### Delete Stashes
```bash
git stash drop              # Delete latest stash
git stash drop stash@{1}    # Delete specific stash
git stash clear             # Delete all stashes
```

### Create Branch from Stash
```bash
git stash branch <branch-name>  # Create branch and apply stash
```

---

## Tagging

### List Tags
```bash
git tag                     # List all tags
git tag -l "v1.*"           # List tags matching pattern
```

### Create Tags
```bash
git tag <tag-name>          # Lightweight tag
git tag -a <tag-name> -m "message"  # Annotated tag (recommended)
git tag <tag-name> <commit-hash>    # Tag specific commit
```

### View Tag Details
```bash
git show <tag-name>
```

### Delete Tags
```bash
git tag -d <tag-name>       # Delete local tag
git push origin --delete <tag-name>  # Delete remote tag
```

### Push Tags
```bash
git push origin <tag-name>  # Push specific tag
git push origin --tags      # Push all tags
```

### Checkout Tags
```bash
git checkout <tag-name>     # Checkout tag (detached HEAD)
git checkout -b <branch-name> <tag-name>  # Create branch from tag
```

---

## Advanced Operations

### Rebase

**Rebase current branch onto another:**
```bash
git rebase <branch>         # Rebase onto branch
git rebase main             # Rebase onto main
```

**Interactive rebase (edit, squash, reorder commits):**
```bash
git rebase -i HEAD~3        # Interactive rebase last 3 commits
git rebase -i <commit-hash>
```

**Abort/Continue rebase:**
```bash
git rebase --abort          # Cancel rebase
git rebase --continue       # Continue after resolving conflicts
git rebase --skip           # Skip current commit
```

### Cherry-Pick
```bash
git cherry-pick <commit-hash>  # Apply specific commit to current branch
git cherry-pick <commit1> <commit2>  # Cherry-pick multiple commits
```

### Bisect (Find Bug-Introducing Commit)
```bash
git bisect start
git bisect bad              # Mark current commit as bad
git bisect good <commit>    # Mark known good commit
# Git checks out middle commit - test and mark as good or bad
git bisect good             # or git bisect bad
# Repeat until bug-introducing commit is found
git bisect reset            # End bisect session
```

### Reflog (Recovery)
```bash
git reflog                  # View reference logs (history of HEAD)
git reflog show <branch>    # Reflog for specific branch
git reset --hard <commit>   # Recover to specific reflog entry
```

### Submodules
```bash
git submodule add <url> <path>  # Add submodule
git submodule init          # Initialize submodules
git submodule update        # Update submodules
git submodule update --init --recursive  # Clone with submodules
```

### Blame (Find Who Changed Lines)
```bash
git blame <file>            # Show who last modified each line
git blame -L 10,20 <file>   # Blame specific line range
```

### Archive
```bash
git archive --format=zip HEAD > archive.zip  # Create zip of current branch
git archive --format=tar <branch> | gzip > archive.tar.gz
```

---

## Common Workflows

### Feature Branch Workflow
```bash
# Create and switch to feature branch
git checkout -b feature/new-feature

# Make changes and commit
git add .
git commit -m "Add new feature"

# Push feature branch
git push -u origin feature/new-feature

# Switch back to main and merge
git checkout main
git merge feature/new-feature

# Delete feature branch
git branch -d feature/new-feature
git push origin --delete feature/new-feature
```

### Update Your Branch with Latest Main
```bash
# Option 1: Merge
git checkout main
git pull
git checkout your-branch
git merge main

# Option 2: Rebase (cleaner history)
git checkout main
git pull
git checkout your-branch
git rebase main
```

### Fix Conflicts During Pull
```bash
git pull
# Conflicts occur
git status                  # See conflicted files
# Edit and resolve conflicts
git add <resolved-files>
git commit                  # Complete merge
```

### Undo Public Commit (Shared Branch)
```bash
git revert <commit-hash>    # Create new commit that undoes changes
git push                    # Push the revert commit
```

### Sync Forked Repository
```bash
# Add upstream remote (original repo)
git remote add upstream <original-repo-url>

# Fetch upstream changes
git fetch upstream

# Merge upstream changes into your main
git checkout main
git merge upstream/main

# Push to your fork
git push origin main
```

---

## Quick Reference

### Git States
- **Working Directory**: Your local files
- **Staging Area (Index)**: Changes ready to commit
- **Repository**: Committed snapshots
- **Remote**: Shared repository (e.g., GitHub)

### Commit References
- `HEAD`: Current commit
- `HEAD~1`: One commit before HEAD
- `HEAD~2`: Two commits before HEAD
- `HEAD^`: Parent of HEAD
- `<commit-hash>`: Specific commit by SHA

### Best Practices
- Write clear, descriptive commit messages
- Commit often with logical chunks of work
- Pull before pushing to avoid conflicts
- Use branches for new features and bug fixes
- Never force push to shared branches (main/master)
- Review changes before committing (`git diff`)
- Keep commits atomic (one logical change per commit)

---

## Help & Documentation

```bash
git help                    # General help
git help <command>          # Help for specific command
git <command> --help        # Alternative help
git <command> -h            # Quick help summary
```

---

## Aliases (Optional Setup)

Add shortcuts to your Git config:

```bash
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.lg 'log --oneline --graph --all'
```

Then use: `git co`, `git br`, `git ci`, etc.

---

**End of Reference** - This covers the essential Git commands you'll use daily as a developer. Practice these commands to build muscle memory and confidence with Git!