# Multi-Agent Coordination Workflow

**Purpose:** This document explains how multiple Claude agents coordinate over multi-phase projects without losing context or breaking each other's work.

---

## The Coordination System

### Two-Role Architecture

This project uses a **Coordinator + Worker Agent** pattern:

**COORDINATOR CLAUDE (talks to user):**
- Maintains `PROJECT_PROGRESS.md` (big picture: phases, metrics, status)
- Spawns worker agents for specific tasks via Task tool
- Reviews `ACTIVE.md` after agent completes work
- Updates `PROJECT_PROGRESS.md` with progress
- Reports to user

**WORKER AGENT (spawned by Coordinator):**
- Reads `ACTIVE.md` at start (hook enforces)
- Implements specific task from "NEXT UP"
- Updates `ACTIVE.md` at end (hook enforces)
- Returns completion report to Coordinator

```
User ←→ Coordinator Claude ←→ [spawns] ←→ Worker Agent
         ↓                                    ↓
    PROJECT_PROGRESS.md                   ACTIVE.md
    (big picture)                         (current sprint)
```

**Benefits:**
- **Separation of concerns:** Strategic (Coordinator) vs Tactical (Worker)
- **No cognitive overload:** Workers don't track long-term progress
- **Single point of contact:** User always talks to Coordinator
- **Automatic tracking:** Coordinator updates big picture systematically

---

## Context Loading Guide

**Know what to read and when:**

### 🔄 Loaded Every Session (Automatic)
- **`ACTIVE.md`** - Current sprint state, recent work, next tasks
  - Session-start hook displays this automatically
  - ~200 lines, all signal
  - You MUST read this to start work

### 📖 Read When Implementing
- **`VISION.md`** - Architecture principles, layer definitions, design philosophy
  - Read when: Making architectural decisions, structuring new components
- **`ROADMAP.md`** - Phase-by-phase implementation plan
  - Read when: Understanding task context, seeing big picture

### 🎯 Read When Coordinating (Coordinator Role)
- **`CLAUDE.md`** (this file) - Workflow patterns, role definitions, coordination examples
  - Read when: Spawning agents, managing reviews, transitioning states
- **`PROJECT_PROGRESS.md`** - Phase completion, metrics, blockers
  - Read when: Updating progress, reporting to user
- **`.claude/agents/*.md`** - Agent persona definitions
  - Read when: Spawning worker/review agents (load → customize → spawn)

**Golden Rule:** Don't load what you don't need. Context is precious. Load on-demand.

---

## Context Management

**For long-term projects:**

1. **Bounded Context**
   - `ACTIVE.md` stays ~200 lines (only current work)
   - Completed work documented in `PROJECT_PROGRESS.md` as summaries
   - Active phase stays detailed; completed phases = brief summaries

2. **Session Boundaries**
   - End Coordinator session after major milestones
   - Next session: Fresh context, continuous state via `ACTIVE.md` + `PROJECT_PROGRESS.md`
   - Use `/clear` between unrelated tasks

3. **Auto-Compact Guidance**
   - When auto-compact triggers: Focus on current task, `ACTIVE.md` state
   - Preserve: Recent decisions, current task context
   - Compress: Historical discussion, completed phase details

---

## Core Workflow: DETERMINISTIC HANDOVER

Worker agents follow a simple 3-step workflow:

```
1. SESSION START → Read ACTIVE.md (automatic via hook)
2. DO WORK → Implement task, commit frequently
3. SESSION END → Update ACTIVE.md (handover checklist)
```

**Result:** Continuous context flow, no memory loss between agents

---

## Step 1: Session Start (Automatic)

**What happens:**
- Session-start hook automatically displays `ACTIVE.md`
- You see: what's in progress, what's next, recent completions, key decisions, project rules

**Your action:**
```
Type: "Read ACTIVE.md - working on [brief task description]"
```

**Why this matters:**
- Prevents context amnesia (forgetting past decisions)
- Ensures you start with full context
- DETERMINISTIC - you can't skip this step

---

## Step 2: Do Your Work

**Implementation:**
1. Work on the task defined in "NEXT UP"
2. Follow "PROJECT RULES" (in `ACTIVE.md`)
3. Write tests as you develop
4. Commit frequently: `git commit -m "[phase N] Brief description"`
5. Document decisions as you make them

**Key practices:**

### Commit Early and Often
```bash
# Good commit pattern:
git commit -m "[phase 1] Add database schema"
git commit -m "[phase 1] Implement data access layer"
git commit -m "[phase 1] Add integration tests"
```

### Follow Project Architecture
- Respect architectural boundaries defined in `VISION.md` (if it exists)
- Follow dependency rules (e.g., only import from lower layers)
- Keep concerns separated (business logic vs infrastructure)

### Use Type Safety
```python
# Good - enum for constants
from enum import Enum

class Status(str, Enum):
    PENDING = "PENDING"
    ACTIVE = "ACTIVE"
    COMPLETE = "COMPLETE"

# Bad - magic string
status = "pending"  # ❌ Don't do this
```

---

## Step 3: Session End (Manual - Your Responsibility)

**Before ending your session, complete the HANDOVER CHECKLIST:**

### 1. Update ACTIVE.md

**Required changes:**
```markdown
## ✅ RECENTLY COMPLETED (Last 3)
- [Date] Your completed task

## ⏭️ NEXT UP (Top Priority)
**Task:** [Define next logical task]
**Owner:** UNCLAIMED or next agent
**Dependencies:** [What needs to be done first]

## 🔑 KEY DECISIONS (Last 5)
### [Date] Your important decision
- Decision: What you decided
- Rationale: Why you decided it
- Impact: What this affects

**Last Updated:** [Today's date] - [Brief description]
```

### 2. Verify Your Work
```bash
# Check what you're committing
git status

# Commit ACTIVE.md update
git add ACTIVE.md
git commit -m "[workflow] Update active state - completed [task]"

# Push everything
git push origin [your-branch]
```

### 3. Final Checklist
- [ ] `ACTIVE.md` updated with your work
- [ ] Key decisions documented
- [ ] Next task clearly defined
- [ ] All code committed and pushed
- [ ] Tests passing (if applicable)

---

## Project Rules

**Project-specific rules should be defined in `ACTIVE.md`** under the "PROJECT RULES" section. This keeps them visible to all agents and easy to update as your project evolves.

**Common patterns across projects:**

1. **Testing:** Write tests as you develop (define coverage targets in `ACTIVE.md`)
2. **Type Safety:** Use type hints and enums for better error checking
3. **No Hardcoded Values:** Use configuration system for constants and thresholds
4. **Architecture:** Respect layer boundaries and separation of concerns
5. **Documentation:** Document complex logic and key decisions as you code
6. **Dependencies:** Use your project's dependency management system consistently

**To customize for your project:**
- Add specific rules to `ACTIVE.md` → PROJECT RULES section
- Include language-specific guidelines (e.g., Decimal for financial data in Python)
- Define architectural patterns to follow (e.g., event sourcing, CQRS)
- Set testing standards (coverage targets, testing approach)
- Specify tooling requirements (linters, formatters, type checkers)

---

## Coordinator Role Guide

**If you are the COORDINATOR** (the Claude instance talking directly to the user):

### Your Responsibilities:

1. **Strategic Planning:**
   - Check `PROJECT_PROGRESS.md` to understand current phase/week
   - Decide what work needs to be done next
   - Break down user requests into specific tasks

2. **Agent Spawning:**
   - Spawn worker agents via Task tool for specific work
   - Provide clear task descriptions
   - Worker agents will read `ACTIVE.md` automatically (hook)

3. **Progress Tracking:**
   - After worker agent completes, review `ACTIVE.md` updates
   - Update `PROJECT_PROGRESS.md`:
     - Check off completed tasks
     - Update phase completion percentage
     - Update metrics (test coverage, type safety, documentation, technical debt, hook compliance)
     - Note any blockers/risks

4. **User Communication:**
   - Report progress clearly
   - Ask for decisions when needed
   - Explain what was done and what's next

### Spawning Agents via Task Tool:

**The Claude-Native Way:**

Agent persona definitions are stored in `.claude/agents/` for consistency. Here's the workflow:

**Step 1:** Read the persona file
```
Use Read tool: .claude/agents/worker.md
```

**Step 2:** Extract the "Agent Prompt Template" section from the tool result

**Step 3:** Customize the template:
- Replace `{TASK_DESCRIPTION}` with task details
- Replace `{TASK_REQUIREMENTS}` with specific requirements
- Replace `{TASK_NAME}` with task name

**Step 4:** Spawn agent with Task tool
```
Tool: Task
subagent_type: "general-purpose"
description: "Implement [Task Name]"
prompt: [the customized prompt from Step 3]
```

**Available Agent Personas:**
- `.claude/agents/worker.md` - Implementation agent
- `.claude/agents/staff-engineer.md` - Architecture reviewer
- `.claude/agents/tdd-expert.md` - Test quality reviewer
- `.claude/agents/qa-engineer.md` - Quality assurance reviewer
- `.claude/agents/security-reviewer.md` - Security reviewer
- `.claude/agents/performance-reviewer.md` - Performance reviewer

See `.claude/agents/README.md` for complete persona documentation.

### Don't Confuse Roles:

❌ **Coordinator should NOT:**
- Write implementation code directly
- Get lost in tactical details
- Forget to update `PROJECT_PROGRESS.md`

✅ **Coordinator SHOULD:**
- Maintain big picture view
- Spawn agents for implementation
- Keep `PROJECT_PROGRESS.md` current
- Communicate clearly with user

---

## Worker Agent Guide

**If you are a WORKER AGENT** (spawned by Coordinator):

### Your Responsibilities:

1. **Read Context:** `ACTIVE.md` displayed automatically (hook)
2. **Implement Task:** Do the specific work from "NEXT UP"
3. **Follow Rules:** PROJECT RULES in `ACTIVE.md`
4. **Update State:** Mark done in `ACTIVE.md` before ending
5. **Report Back:** Return completion summary to Coordinator

### Worker Workflow:

See "Step 1: Session Start", "Step 2: Do Your Work", "Step 3: Session End" sections above.

---

## Multi-Role Review Workflow

**Purpose:** Critical work (Phase 1 foundation, core business logic, integration points) requires peer review before marking complete.

### Review Roles Available:

1. **Staff Engineer** - Architecture, design patterns, code structure
2. **QA Engineer** - Test coverage, edge cases, quality standards
3. **TDD Expert** - Test-driven development practices, test quality
4. **Security Reviewer** - Security vulnerabilities, data protection
5. **Performance Reviewer** - Efficiency, scalability concerns

### Review State Machine:

```
UNCLAIMED → IN_PROGRESS (Worker implements)
              ↓
         IN_REVIEW (Reviewers work in parallel)
              ↓
    ┌─── All APPROVED? ───→ COMPLETED
    │
    └─── REQUEST_CHANGES? ───→ ADDRESSING_FEEDBACK
                                      ↓
                              (back to IN_REVIEW)
```

### State Transition Command (Coordinator Tool)

**IMPORTANT:** As Coordinator, you must use the transition command to change task states. This enforces the state machine deterministically.

**Usage:**
```bash
.claude/workflow/transition <task-id> <from-state> <to-state>
```

**Example:**
```bash
# Worker completes implementation
.claude/workflow/transition TASK-001 UNCLAIMED IN_PROGRESS

# Implementation done, move to review
.claude/workflow/transition TASK-001 IN_PROGRESS IN_REVIEW

# All reviews approved
.claude/workflow/transition TASK-001 IN_REVIEW COMPLETED

# Changes needed
.claude/workflow/transition TASK-001 IN_REVIEW ADDRESSING_FEEDBACK

# Fixes done, back to review
.claude/workflow/transition TASK-001 ADDRESSING_FEEDBACK IN_REVIEW
```

**Valid Transitions:**
- `UNCLAIMED → IN_PROGRESS` (spawn worker)
- `IN_PROGRESS → IN_REVIEW` (worker done, spawn reviewers)
- `IN_REVIEW → COMPLETED` (all approved)
- `IN_REVIEW → ADDRESSING_FEEDBACK` (changes needed)
- `ADDRESSING_FEEDBACK → IN_REVIEW` (fixes done)

---

### Coordinator Review Workflow:

**Step 1: Worker Completes Implementation**
```
Worker reports: "Authentication module implementation complete"

Coordinator actions:
1. Read ACTIVE.md to see what was done
2. Transition state: `.claude/workflow/transition TASK-001 IN_PROGRESS IN_REVIEW`
3. Move task block from "IN PROGRESS" to "IN REVIEW" section in ACTIVE.md
4. Determine which reviewers needed (based on task criticality)
5. Spawn review agents in parallel
```

**Step 2: Spawn Review Agents (Parallel)**

1. Read persona files: `.claude/agents/staff-engineer.md` and `.claude/agents/tdd-expert.md`
2. Extract "Agent Prompt Template" sections from both
3. Customize each with task details
4. Spawn both agents in parallel (single message, multiple Task tool calls)

**Step 3: Collect Review Feedback**
```
Reviews complete. Coordinator checks ACTIVE.md:

Scenario A: All reviews APPROVED
→ Coordinator: `.claude/workflow/transition TASK-001 IN_REVIEW COMPLETED`
→ Moves task to "RECENTLY COMPLETED" section
→ Updates PROJECT_PROGRESS.md
→ Reports to user

Scenario B: Some reviews REQUEST_CHANGES
→ Coordinator: `.claude/workflow/transition TASK-001 IN_REVIEW ADDRESSING_FEEDBACK`
→ Spawns worker agent to fix issues
→ After fixes: `.claude/workflow/transition TASK-001 ADDRESSING_FEEDBACK IN_REVIEW`
→ Re-spawns reviewers

Scenario C: Any review BLOCKED
→ Coordinator escalates to user
→ User and Coordinator decide next steps
```

**Step 4: Feedback Loop (If Changes Needed)**

1. Read `.claude/agents/worker.md` using Read tool
2. Extract the "Agent Prompt Template" section
3. Customize for feedback addressing
4. Spawn worker using Task tool with customized prompt
5. After worker completes, transition back to `IN_REVIEW`

### Review Agent Workflow:

**If you are a REVIEW AGENT:**

1. **Session Start:** Read `ACTIVE.md` (automatic)
2. **Find Your Task:** Check "IN REVIEW" section
3. **Review the Code:** Read implementation + tests thoroughly
4. **Add Feedback:** Update `ACTIVE.md` with your review
5. **Mark Status:** APPROVED, REQUEST_CHANGES, or BLOCKED
6. **Report to Coordinator:** Completion summary

**Review Feedback Format:**
```markdown
## 🔍 IN REVIEW

**[TASK-001] Authentication Module**
- State: `IN_REVIEW`
- Reviewers: Staff Engineer, TDD Expert
- Implementation commit: abc123f

### Reviews:

#### Staff Engineer Review - 2025-11-12
- **Status:** APPROVED
- **Issues found:** None
- **Recommendations:**
  - Consider adding token refresh mechanism
- **Blocking concerns:** None

#### TDD Expert Review - 2025-11-12
- **Status:** REQUEST_CHANGES
- **Test coverage:** 78% (target: 80%+)
- **Issues found:**
  - Missing tests for token expiration
  - Error case for invalid credentials not tested
- **Blocking concerns:** None (can be fixed quickly)
```

### When to Require Reviews:

**Phase 1 (Foundation):** Reviews for ALL tasks
- Foundation is critical, sets quality standards

**Phase 2+ (Core Features):** Reviews for:
- New core services or modules
- Critical business logic
- External integrations
- Critical bug fixes

**Phase 5+ (Production):** Reviews for ALL changes

### Review Decision Criteria:

**APPROVED:**
- Code meets standards
- Tests adequate
- No blocking issues

**REQUEST_CHANGES:**
- Issues found that should be fixed
- Missing tests or documentation
- NOT blocking, but should be addressed

**BLOCKED:**
- Critical flaw found
- Architecture violation
- Security vulnerability
- Requires immediate attention

---

## Common Scenarios

### Scenario: I'm the First Agent (Phase 1, Starting Fresh)

1. Read `ACTIVE.md` (session-start hook shows it)
2. See "NEXT UP" → Set up project structure
3. Create: project structure, dependencies, initial module
4. Update `ACTIVE.md` when done
5. Next agent continues from your state

### Scenario: I'm in the Middle (Phase 2+)

1. Read `ACTIVE.md` → See what's done, what's next
2. Check "KEY DECISIONS" → Understand past choices
3. Implement your task
4. Update `ACTIVE.md` → Mark done, define next task
5. Next agent continues

### Scenario: I Found a Bug in Previous Work

1. Fix the bug
2. Add decision to `ACTIVE.md`:
   ```markdown
   ### [Date] Fixed database query bug
   - Issue: Records not ordered correctly
   - Fix: Added index on timestamp column
   - Impact: All queries now faster
   ```
3. Continue with your original task

### Scenario: I'm Blocked by Missing Information

1. Add note to `ACTIVE.md` and ask user for clarification
2. Work on unblocked tasks while waiting
3. When resolved, document decision in KEY DECISIONS

### Scenario: I Need to Change Architecture

1. Document decision in `ACTIVE.md` → KEY DECISIONS
2. Explain rationale clearly (next agent needs context)
3. Update affected areas
4. Note impact in decision log

---

## Reference Documents

### Strategic/Architectural
- `VISION.md` - Product vision, architecture, design principles
- `ROADMAP.md` - Detailed implementation plan

### Coordination
- `PROJECT_PROGRESS.md` - Big picture tracking (Coordinator maintains)
- `ACTIVE.md` - Active sprint state (Worker agents read/update)
- `.claude/agents/` - Reusable agent persona definitions
- `CLAUDE.md` - This file, explains workflow and roles

### Technical
- `.claude/hooks/session-start.sh` - Session start hook script
- `.claude/settings.json` - Hook registration

---

## Why This Works

### Problem: Context Amnesia
- Agent starts session, doesn't know what was done
- Forgets critical decisions from days ago
- Re-implements things differently
- Breaks existing code

### Solution: DETERMINISTIC Flow
- ✅ Session-start hook forces context load
- ✅ `ACTIVE.md` preserves recent decisions and current state
- ✅ Handover checklist enforces documentation
- ✅ Next agent picks up exactly where you left off
- ✅ Context-efficient: stays ~200 lines regardless of project length

### Benefits
1. **No context loss** - Every decision documented
2. **No conflicts** - Clear task ownership (NEXT UP)
3. **No rework** - Next agent knows what's done
4. **Continuous progress** - Seamless handover
5. **Constant context usage** - Bounded active state

---

## Tips for Effective Coordination

### DO:
- ✅ Read `ACTIVE.md` completely at session start
- ✅ Commit frequently with clear messages
- ✅ Document decisions as you make them
- ✅ Update `ACTIVE.md` before ending session
- ✅ Define clear "NEXT UP" for next agent
- ✅ Ask user when blocked (don't guess)

### DON'T:
- ❌ Skip reading `ACTIVE.md`
- ❌ Change architecture without documenting
- ❌ Leave session without updating state
- ❌ Make vague "NEXT UP" entries
- ❌ Assume you know what was decided before
- ❌ Work on tasks outside "NEXT UP" without good reason

---

## Validation

The coordination workflow emphasizes **process discipline**:

1. **Process discipline:** Read context, update state
2. **Architectural principles:** Respect defined boundaries, use type safety
3. **Testing mindset:** Write tests as you develop
4. **Documentation:** Decisions, handovers, blockers

As your project matures, consider adding:
- Pre-commit hooks for test coverage
- Type checking (language-specific: mypy for Python, TypeScript for JS, etc.)
- Automated contract validation
- Code quality checks (linters, formatters)

**Process discipline is the foundation** - automation supports it but doesn't replace it.

---

**Remember:** You're part of a relay race. Your handover determines how fast the next agent can run.

**Make it clean. Make it clear. Document everything.**

---

**Last Updated:** 2025-11-11 - Generalized for multi-agent coordination template
