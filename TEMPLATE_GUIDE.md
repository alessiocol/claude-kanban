# Template Customization Guide

This guide shows you how to customize the Multi-Agent Coordination Template for your specific project.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Step 1: Install Hooks](#step-1-install-hooks)
3. [Step 2: Create VISION.md](#step-2-create-visionmd)
4. [Step 3: Create ROADMAP.md](#step-3-create-roadmapmd)
5. [Step 4: Create PROJECT_PROGRESS.md](#step-4-create-project_progressmd)
6. [Step 5: Customize ACTIVE.md](#step-5-customize-activemd)
7. [Step 6: Customize Commit Message Validation](#step-6-customize-commit-message-validation)
8. [Step 7: (Optional) Customize Agent Personas](#step-7-optional-customize-agent-personas)
9. [Step 8: Start Your First Sprint](#step-8-start-your-first-sprint)

---

## Prerequisites

- Git repository initialized
- Claude Code (or Claude in another environment)
- Bash shell (for hooks)

---

## Step 1: Install Hooks

The template includes git hooks and session hooks that enforce the coordination workflow.

### Install Script

First, create the hook installation script:

**Run:**
```bash
./.claude/workflow/install-hooks.sh
```

This will:
- Symlink `.claude/hooks/git/commit-msg` → `.git/hooks/commit-msg`
- Set executable permissions
- Validate installation

### Verify Installation

```bash
# Check git hooks
ls -la .git/hooks/

# Test session hook (should display ACTIVE.md)
cat .claude/hooks/session-start.sh
```

---

## Step 2: Create VISION.md

**Purpose:** Define your project's architecture, design principles, and technical vision.

### Template

Create `VISION.md` in your project root:

```markdown
# Project Vision

**Purpose:** [One-line description of your project]

---

## Product Vision

### What We're Building

[Describe what you're building and why]

### Target Users

[Who will use this?]

### Key Features

1. [Feature 1]
2. [Feature 2]
3. [Feature 3]

---

## Architecture Principles

### 1. [Principle Name]
- **What:** [Description]
- **Why:** [Rationale]
- **How:** [Implementation approach]

### 2. [Principle Name]
- ...

---

## Technical Stack

- **Language:** [e.g., Python 3.11+, TypeScript, etc.]
- **Framework:** [e.g., FastAPI, React, etc.]
- **Database:** [e.g., PostgreSQL, MongoDB, etc.]
- **Testing:** [e.g., pytest, Jest, etc.]
- **Dependencies:** [e.g., Poetry, npm, etc.]

---

## Layer Architecture

### Layer 1: [Domain/Core]
- **Purpose:** [Description]
- **Dependencies:** [None or list]
- **Location:** [src/domain/, etc.]

### Layer 2: [Services/Business Logic]
- **Purpose:** [Description]
- **Dependencies:** [Layer 1 only]
- **Location:** [src/services/, etc.]

[Continue for all layers...]

---

## Design Patterns

### [Pattern Name]
- **When to use:** [Description]
- **Example:** [Code or pseudocode]

---

## Quality Standards

- **Test Coverage:** [Target percentage, e.g., 80%+]
- **Critical Path Coverage:** [e.g., 100% for auth, payments, etc.]
- **Type Safety:** [How enforced]
- **Documentation:** [What requires docs]

---
```

### Example

For a web application:
```markdown
## Layer Architecture

### Layer 1: Domain Models
- **Purpose:** Core business entities and value objects
- **Dependencies:** None
- **Location:** src/models/

### Layer 2: Services
- **Purpose:** Business logic and use cases
- **Dependencies:** Layer 1 only
- **Location:** src/services/

### Layer 3: API
- **Purpose:** HTTP endpoints and API contracts
- **Dependencies:** Layers 1-2
- **Location:** src/api/

### Layer 4: Infrastructure
- **Purpose:** Database, external services, file system
- **Dependencies:** Layers 1-2
- **Location:** src/infrastructure/
```

---

## Step 3: Create ROADMAP.md

**Purpose:** Define your project's phases and implementation plan.

### Template

Create `ROADMAP.md` in your project root:

```markdown
# Implementation Roadmap

**Duration:** [e.g., 6 months, 12 weeks, etc.]
**Phases:** [e.g., 6 phases]

---

## Phase 1: Foundation (Week 0-4)

**Goal:** [What you'll accomplish]

**Deliverables:**
- [ ] [Deliverable 1]
- [ ] [Deliverable 2]
- [ ] [Deliverable 3]

**Technical Details:**
- [Detail 1]
- [Detail 2]

**Definition of Done:**
- [ ] [Criteria 1]
- [ ] [Criteria 2]
- [ ] Test coverage: [Target]%

---

## Phase 2: [Name] (Week 5-8)

**Goal:** [What you'll accomplish]

**Dependencies:** Phase 1 complete

**Deliverables:**
- [ ] [Deliverable 1]
- [ ] [Deliverable 2]

[Continue...]

---

## Phase N: Production (Final Phase)

**Goal:** Production-ready deployment

**Deliverables:**
- [ ] Production deployment
- [ ] Monitoring and logging
- [ ] Documentation complete
- [ ] User guides

---
```

### Tips

- **Be specific:** Instead of "Build authentication", say "JWT-based authentication with refresh tokens, email verification, and password reset"
- **Include metrics:** Test coverage targets, performance requirements
- **Define dependencies:** What must be done before this phase can start
- **Estimate time:** Week ranges or sprint numbers

---

## Step 4: Create PROJECT_PROGRESS.md

**Purpose:** Track your actual project progress (big picture view maintained by Coordinator).

### Template

Create `PROJECT_PROGRESS.md` in your project root:

```markdown
# Project Progress Tracking

**Last Updated:** [Date] by Coordinator
**Current Phase:** Phase 1 - Foundation
**Current Week:** Week 1
**Overall Completion:** 0%

---

## Executive Summary

**Status:** 🟢 On Track / 🟡 At Risk / 🔴 Blocked

**Current Focus:** [What you're working on now]

**Recent Milestones:**
- [Date] [Milestone description]

**Upcoming Milestones:**
- [Date] [Milestone description]

---

## Phase 1: Foundation (Week 0-4)

**Completion:** 0%
**Status:** 🟢 In Progress

### Week 0-2: Project Setup
- [ ] Git repository initialized
- [ ] Hook system installed
- [ ] VISION.md created
- [ ] ROADMAP.md created
- [ ] First task defined in ACTIVE.md

### Week 3-4: [Next Tasks]
- [ ] [Task 1]
- [ ] [Task 2]

---

## Metrics Dashboard

### Code Quality
- **Test Coverage:** 0% (target: 80%+)
- **Critical Path Coverage:** 0% (target: 100%)
- **Type Safety:** [Tool] configured: ✅/❌
- **Linting:** [Tool] passing: ✅/❌

### Documentation
- **Architecture Docs:** VISION.md ✅
- **Implementation Plan:** ROADMAP.md ✅
- **API Documentation:** 0% complete
- **User Guides:** 0% complete

### Technical Debt
- **Known Issues:** 0
- **TODOs:** 0
- **Refactoring Needed:** None

### Process Compliance
- **Hook Usage:** 100% (enforced)
- **ACTIVE.md Updates:** Current
- **Review Completion Rate:** N/A (no reviews yet)

---

## Blockers & Risks

### Active Blockers
None

### Risks
| Risk | Impact | Mitigation |
|------|--------|------------|
| [Risk description] | [High/Med/Low] | [How you'll mitigate] |

---

## Completed Phases

(Empty - phases will be compressed here after completion)

---

## Notes for Next Session

[Coordinator notes for next time]

---
```

### Coordinator Responsibilities

The **Coordinator** updates this file after each major milestone:
- Check off completed tasks
- Update completion percentages
- Update metrics dashboard
- Note blockers and risks
- Compress completed phases to summaries

---

## Step 5: Customize ACTIVE.md

**Purpose:** Define your project-specific rules and first task.

### Update PROJECT RULES Section

Open `.claude/state/ACTIVE.md` (or `ACTIVE.md` in root) and update:

```markdown
## 📋 PROJECT RULES (Quick Reference)

1. **Testing:** Write tests as you develop (target: 80%+ coverage)
2. **Type Safety:** Use type hints and [your type checking tool]
3. **Documentation:** Document public APIs and complex logic
4. **Code Quality:** Run [your linter] before committing
5. **Dependencies:** Use [Poetry/npm/etc.] for dependency management

**📖 Deep Dives:**
- Full workflow guide → `CLAUDE.md`
- Architecture principles → `VISION.md`
- Implementation plan → `ROADMAP.md`
```

### Example: Python Project

```markdown
## 📋 PROJECT RULES (Quick Reference)

1. **Testing:** Write tests as you develop (pytest, 80%+ coverage overall, 100% for auth)
2. **Type Safety:** Use type hints + mypy strict mode
3. **Decimal Precision:** Use Decimal for financial/currency values (not float)
4. **Documentation:** Docstrings for all public functions (Google style)
5. **Dependencies:** Use Poetry (`poetry add <package>`)
6. **Code Quality:** Run `black` and `ruff` before committing
7. **Async:** Use async/await for I/O operations

**📖 Deep Dives:**
- Architecture → `VISION.md` (FastAPI + PostgreSQL + Redis)
- Full workflow guide → `CLAUDE.md`
```

### Example: TypeScript Project

```markdown
## 📋 PROJECT RULES (Quick Reference)

1. **Testing:** Jest + React Testing Library (80%+ coverage)
2. **Type Safety:** TypeScript strict mode, no `any` types
3. **Components:** Functional components with hooks only
4. **State Management:** Redux Toolkit for global state
5. **Dependencies:** npm (keep package-lock.json updated)
6. **Code Quality:** ESLint + Prettier before committing
7. **Performance:** React.memo for expensive re-renders

**📖 Deep Dives:**
- Architecture → `VISION.md` (React + TypeScript + Redux)
- Full workflow guide → `CLAUDE.md`
```

### Define Your First Task

Update the "NEXT UP" section in ACTIVE.md:

```markdown
## ⏭️ NEXT UP (Top Priority)

**[TASK-001] Project Setup**
- Estimate: 2-4 hours
- State: UNCLAIMED
- Owner: None
- Dependencies: None
- Tasks:
  1. Initialize project structure (src/, tests/, config/)
  2. Set up dependency management ([Poetry/npm/etc.])
  3. Configure linting and formatting tools
  4. Add .gitignore for [language]
  5. Create basic README for project (not template)
- Review required: Staff Engineer (light review to validate structure)
```

---

## Step 6: Customize Commit Message Validation

The template includes a commit-msg hook that validates commit message format.

### Edit Hook

Edit `.claude/hooks/git/commit-msg`:

```bash
# Require [phase N] or [workflow] or [setup] or [docs] prefix (all lowercase)
if ! echo "$MSG" | grep -qE "^\[(phase [0-9]+|workflow|setup|docs|feat|fix|refactor|test|chore)\]"; then
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "❌ INVALID COMMIT MESSAGE FORMAT"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "Commit message must start with one of (all lowercase):"
  echo "  [phase N]    - Implementation work (e.g., [phase 1] Add database schema)"
  echo "  [workflow]   - Workflow/coordination changes"
  echo "  [setup]      - Project setup"
  echo "  [docs]       - Documentation only"
  echo "  [feat]       - New feature"
  echo "  [fix]        - Bug fix"
  echo "  [refactor]   - Code refactoring"
  echo "  [test]       - Test additions"
  echo "  [chore]      - Maintenance"
  # ... add your own tags here
fi
```

### Customize Tags

Add project-specific tags:
```bash
if ! echo "$MSG" | grep -qE "^\[(phase [0-9]+|workflow|setup|docs|feat|fix|refactor|test|chore|deploy|hotfix)\]"; then
```

Then update the error message to show your tags.

---

## Step 7: (Optional) Customize Agent Personas

The default agent personas are generic and work for most projects. However, you can customize them:

### When to Customize

- You have domain-specific review criteria (e.g., HIPAA compliance, real-time systems)
- You want additional review roles (e.g., UX Reviewer, Accessibility Reviewer)
- You want to add project-specific anti-patterns to check for

### How to Customize

1. **Edit existing personas:** `.claude/agents/*.md`
2. **Add new personas:** Create new `.md` files following the same format
3. **Update Coordinator guidance:** Edit CLAUDE.md to reference your new reviewers

### Example: Add Accessibility Reviewer

Create `.claude/agents/accessibility-reviewer.md`:

```markdown
# Accessibility Reviewer Agent Persona

**Version:** 1.0.0
**Role:** Accessibility & WCAG Compliance Reviewer
**Purpose:** Review for accessibility issues, WCAG compliance

---

## Agent Prompt Template

```
You are an ACCESSIBILITY REVIEWER AGENT with expertise in web accessibility.

[...rest of persona definition...]
```
```

Then update CLAUDE.md to mention this reviewer in the "Review Roles Available" section.

---

## Step 8: Start Your First Sprint

### 1. Coordinator Starts

As the **Coordinator** (the Claude instance talking directly to the user):

1. Read ACTIVE.md (session hook displays it)
2. Read VISION.md to understand architecture
3. Read ROADMAP.md to understand the plan
4. Confirm first task in ACTIVE.md is correct

### 2. Spawn Worker Agent

Coordinator spawns a worker agent:

**Step 1:** Read `.claude/agents/worker.md`

**Step 2:** Customize the prompt template:
- Replace `{TASK_DESCRIPTION}` with "Project Setup"
- Replace `{TASK_REQUIREMENTS}` with the task list from ACTIVE.md
- Replace `{TASK_NAME}` with "[TASK-001] Project Setup"

**Step 3:** Use Task tool to spawn:
```
Tool: Task
subagent_type: "general-purpose"
description: "Project Setup"
prompt: [customized prompt from Step 2]
```

### 3. Worker Implements

Worker agent:
1. Reads ACTIVE.md (automatic via hook)
2. Implements the task
3. Commits frequently with proper format: `[phase 1] Initialize project structure`
4. Updates ACTIVE.md before ending session:
   - Moves task to "RECENTLY COMPLETED"
   - Adds decisions to "KEY DECISIONS"
   - Defines "NEXT UP"
5. Returns completion report to Coordinator

### 4. Coordinator Updates Progress

Coordinator:
1. Reads updated ACTIVE.md
2. Updates PROJECT_PROGRESS.md:
   - Check off completed tasks
   - Update metrics (test coverage, etc.)
   - Update phase completion percentage
3. Reports to user

### 5. Continue!

Repeat the cycle:
- Coordinator spawns worker for next task
- Worker implements, updates ACTIVE.md
- Coordinator updates PROJECT_PROGRESS.md
- Spawn review agents for critical work

---

## Best Practices

### 1. Keep ACTIVE.md Current

- Update at end of EVERY session (enforced by process)
- Keep "RECENTLY COMPLETED" to last 3 items only
- Keep "KEY DECISIONS" to last 5 items only
- Archive older items to `.claude/state/archive/`

### 2. Compress PROJECT_PROGRESS.md

When a phase completes:
- Archive detailed checklist to `.claude/state/archive/phase-N-checklist.md`
- Replace with 3-4 line summary in PROJECT_PROGRESS.md
- This keeps file size constant (~200-300 lines)

### 3. Use Reviews Strategically

**Phase 1 (Foundation):**
- Review ALL tasks
- Staff Engineer + TDD Expert minimum
- Sets quality standards for project

**Phase 2+ (Features):**
- Review critical business logic
- Add Security + Performance for sensitive areas
- Skip reviews for minor changes

**Production:**
- Review ALL changes

### 4. State Transitions

Always use the transition command:
```bash
.claude/workflow/transition TASK-001 UNCLAIMED IN_PROGRESS
.claude/workflow/transition TASK-001 IN_PROGRESS IN_REVIEW
.claude/workflow/transition TASK-001 IN_REVIEW COMPLETED
```

This validates state machine and prevents errors.

### 5. Commit Frequently

```bash
# Good: Atomic commits
git commit -m "[phase 1] Add user model"
git commit -m "[phase 1] Add user service layer"
git commit -m "[phase 1] Add user API endpoints"

# Bad: Monolithic commit
git commit -m "[phase 1] Implement entire user module"
```

---

## Troubleshooting

### Hook Not Running

```bash
# Check hook exists and is executable
ls -la .git/hooks/commit-msg
chmod +x .git/hooks/commit-msg

# Test hook manually
.git/hooks/commit-msg .git/COMMIT_EDITMSG
```

### Session Hook Not Displaying ACTIVE.md

- Check `.claude/settings.json` has correct hook path
- Verify `.claude/hooks/session-start.sh` is executable
- Check Claude Code settings for session hooks enabled

### Transition Command Failing

```bash
# Check current state of task in ACTIVE.md
grep -A 10 "TASK-001" .claude/state/ACTIVE.md

# Verify FROM_STATE matches actual state
.claude/workflow/transition TASK-001 <ACTUAL_STATE> <TO_STATE>
```

---

## Next Steps

1. **Read CLAUDE.md:** Understand the full workflow
2. **Start your first task:** Follow Step 8 above
3. **Iterate:** After a few tasks, reflect and refine your process
4. **Scale:** Add more agent personas as needed

---

## Support

- **Workflow Questions:** See [CLAUDE.md](CLAUDE.md)
- **Hook System:** See [.claude/README.md](.claude/README.md)
- **Agent Personas:** See [.claude/agents/README.md](.claude/agents/README.md)

---

**Good luck with your project!** 🚀
