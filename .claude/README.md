# Multi-Agent Coordination System

This directory contains the coordination infrastructure that ensures agents work together effectively across the 6-month project.

## Overview

The coordination system enforces workflow discipline through **hooks** that run automatically at key checkpoints:

```
Session Start → Work → Commit → Work → Commit → Session End
     ↓           ↓        ↓       ↓        ↓          ↓
 SessionStart  PreCommit CommitMsg PostCommit PreCommit  StopHook
   (displays)  (validates) (format) (reminds) (validates) (validates)
```

---

## Quick Start

### First Time Setup (Run Once After Clone)

```bash
# Install git hooks
./.claude/setup-hooks.sh
```

This will:
- Make all hook scripts executable
- Create symlinks from `.git/hooks/` to `.claude/hooks/git/`
- Verify installation

### That's It!

Hooks now run automatically:
- **SessionStart**: Shows ACTIVE.md when you start
- **PreCommit**: Validates code before commit
- **CommitMsg**: Enforces commit message format
- **PostCommit**: Reminds to update state after 5 commits
- **SessionEnd**: Validates handover before session ends

---

## Hook Details

### 1. SessionStart Hook ✅ (Automatic)

**When:** Agent starts new session
**What:** Displays ACTIVE.md content
**File:** `.claude/hooks/session-start.sh`

**Purpose:**
- Forces context loading (can't skip)
- Shows what's in progress, what's next, recent completions, key decisions
- Ensures agent starts with full context
- Context-efficient: stays ~200 lines

**Example Output:**
```
🚨 SESSION START - MANDATORY READING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Full ACTIVE.md content displayed]

✅ ACKNOWLEDGMENT REQUIRED
Type: "Read ACTIVE.md - working on [task]"
```

---

### 2. Pre-Commit Hook ✅ (Git)

**When:** Before `git commit` completes
**What:** Validates code quality
**File:** `.git/hooks/pre-commit` → `.claude/hooks/git/pre-commit`

**Checks:**
- ✅ Tests exist for code changes (warns if missing)
- ✅ Tests pass (blocks if failing)

**Example Output (Success):**
```
🔍 Pre-commit validation...
Running tests...
✅ Tests passed
✅ Pre-commit checks passed
```

**Example Output (Failure):**
```
🔍 Pre-commit validation...
Running tests...
❌ BLOCKED: Tests failed
Fix failing tests before committing:
  pytest -v  # See detailed output
```

---

### 3. Commit-Msg Hook ✅ (Git)

**When:** Before `git commit` completes
**What:** Validates commit message format
**File:** `.git/hooks/commit-msg` → `.claude/hooks/git/commit-msg`

**Enforces Format:**
```
[phase N] <description>     # Implementation work (N can be multi-digit)
[workflow] <description>    # Workflow changes
[setup] <description>       # Project setup
[docs] <description>        # Documentation
[feat] <description>        # New feature
[fix] <description>         # Bug fix
[refactor] <description>    # Code refactor
[test] <description>        # Tests
[chore] <description>       # Maintenance
```

**Example Output (Blocked):**
```
❌ INVALID COMMIT MESSAGE FORMAT

Commit message must start with one of:
  [phase N], [workflow], [feat], [fix], etc.

Your message:
  bad commit message

Example valid messages:
  [phase 1] Implement SQLite event store
  [feat] Add event replay functionality
```

---

### 4. Post-Commit Hook (Git)

**When:** After successful `git commit`
**What:** Reminds to update ACTIVE.md
**File:** `.git/hooks/post-commit` → `.claude/hooks/git/post-commit`

**Triggers After:** 5 commits without updating ACTIVE.md

**Example Output:**
```
⏰ REMINDER: Consider Updating ACTIVE.md

You've made 5 commits since last updating ACTIVE.md

Consider updating with your progress:
  • What tasks you've completed (RECENTLY COMPLETED)
  • Any important decisions made (KEY DECISIONS)
  • Current status and next steps (NEXT UP)
```

---

### 5. SessionEnd Hook ✅ (Automatic)

**When:** Agent tries to end session
**What:** Validates handover checklist
**File:** `.claude/hooks/stop-hook.sh`

**Checks:**
- ❌ BLOCKS if uncommitted changes exist
- ❌ BLOCKS if ACTIVE.md not updated (when code changed)
- ⚠️ WARNS if unpushed commits exist

**Example Output (Blocked):**
```
🛑 SESSION END CHECKLIST

1️⃣  Checking for uncommitted changes...
   ❌ UNCOMMITTED CHANGES FOUND

      M  src/event_store/store.py

   Action required: Commit your work before ending session

2️⃣  Checking for unpushed commits...
   ✅ All commits pushed to remote

3️⃣  Checking ACTIVE.md updates...
   ❌ ACTIVE.md NOT UPDATED

   You modified code but didn't update ACTIVE.md

❌ SESSION END BLOCKED (2 error(s))

Please fix the errors above before ending your session
```

**Example Output (Success):**
```
🛑 SESSION END CHECKLIST

1️⃣  Checking for uncommitted changes...
   ✅ No uncommitted changes

2️⃣  Checking for unpushed commits...
   ✅ All commits pushed to remote

3️⃣  Checking ACTIVE.md updates...
   ✅ ACTIVE.md is up to date

✅ HANDOVER COMPLETE

All checks passed! Session can end safely.
Next agent will receive clean context via ACTIVE.md
```

---

## File Structure

```
.claude/
├── README.md                      # This file
├── settings.json                  # Hook registration (SessionStart, SessionEnd)
├── setup-hooks.sh                 # Installation script (run once)
├── hooks/
│   ├── session-start.sh          # SessionStart hook (displays state)
│   ├── stop-hook.sh              # SessionEnd hook (validates handover)
│   └── git/
│       ├── pre-commit            # Git pre-commit hook
│       ├── commit-msg            # Git commit-msg hook
│       └── post-commit           # Git post-commit hook
```

---

## Troubleshooting

### Hooks Not Running

**Problem:** Git hooks don't run when you commit

**Solution:**
```bash
# Re-run setup script
./.claude/setup-hooks.sh

# Verify hooks are installed
ls -la .git/hooks/ | grep -E "(pre-commit|commit-msg|post-commit)"

# Should see symlinks pointing to .claude/hooks/git/
```

---

### Commit Blocked by Pre-Commit Hook

**Problem:** Can't commit because tests fail

**Solution:**
```bash
# Run tests to see what's failing
pytest -v

# Fix the failing tests, then commit again
```

**Skip hook (emergency only):**
```bash
# NOT RECOMMENDED - bypasses quality checks
git commit --no-verify -m "[fix] Your message"
```

---

### Commit Blocked by Commit-Msg Hook

**Problem:** Commit message format rejected

**Solution:**
```bash
# Use proper format
git commit -m "[Phase 1] Your description here"

# OR
git commit -m "[feat] Your description here"
```

---

### Session End Blocked

**Problem:** Can't end session due to uncommitted work

**Solution:**
```bash
# Check what's uncommitted
git status

# Commit your work
git add .
git commit -m "[Phase N] Your changes"

# Update ACTIVE.md
# - Mark tasks done in RECENTLY COMPLETED
# - Add decisions to KEY DECISIONS
# - Update NEXT UP
# - Update "Last Updated"

git add .claude/state/ACTIVE.md
git commit -m "[workflow] Update active state"

# Push everything
git push origin <your-branch>

# Now you can end session
```

---

## Maintenance

### Updating Hooks

Hooks are stored in `.claude/hooks/git/` and **symlinked** to `.git/hooks/`.

**To update a hook:**
1. Edit the file in `.claude/hooks/git/`
2. Commit the change
3. Changes apply immediately (due to symlink)
4. Push to share with other agents

**Example:**
```bash
# Edit hook
vim .claude/hooks/git/pre-commit

# Test it
git commit -m "[test] Testing hook changes"

# Commit hook update
git add .claude/hooks/git/pre-commit
git commit -m "[workflow] Update pre-commit hook validation"
git push
```

---

### Disabling Hooks (Temporary)

**Not recommended**, but if needed:

```bash
# Disable specific git hook
mv .git/hooks/pre-commit .git/hooks/pre-commit.disabled

# Re-enable
mv .git/hooks/pre-commit.disabled .git/hooks/pre-commit

# Disable all git hooks (use --no-verify flag)
git commit --no-verify -m "message"
```

**Note:** Session hooks (SessionStart, SessionEnd) cannot be easily disabled.

---

## Benefits

### ✅ Can't Forget to Commit
- Pre-commit validates before allowing commit
- Session-end blocks if uncommitted work

### ✅ Can't Forget to Update State
- Post-commit reminds after 5 commits
- Session-end blocks if state stale

### ✅ Can't Leave Broken Code
- Pre-commit runs tests
- Blocks commit if tests fail

### ✅ Can't Skip Handover
- Session-end enforces checklist
- Blocks if handover incomplete

### ✅ Consistent Workflow
- All agents follow same process
- Deterministic, not relying on goodwill

---

## See Also

- **.claude/state/ACTIVE.md** - Active sprint state (updated by agents)
- **.claude/state/archive/** - Historical state and completed work
- **CLAUDE.md** - Agent workflow guide
- **VISION.md** - Project vision and architecture
- **ROADMAP.md** - 6-month implementation plan
