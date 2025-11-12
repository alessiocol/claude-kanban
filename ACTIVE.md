# Active Sprint State

**🎯 FOR WORKER AGENTS:** This file tracks current sprint work. You (the worker agent) read this, do your task, and update it before ending your session.

**📊 FOR BIG PICTURE:** See your project's progress tracking file (maintained by Coordinator)

---

**Last Updated:** [Date] (Template - ready for your project)
**Current Phase:** [Your Phase]
**Sprint:** [Your Sprint Name]

---

## 🔨 IN PROGRESS

None

---

## 🔍 IN REVIEW

None

**Review roles available:** Staff Engineer, QA Engineer, TDD Expert, Security Reviewer, Performance Reviewer

---

## 🔧 ADDRESSING FEEDBACK

None

---

## ⏭️ NEXT UP (Top Priority)

**[TASK-001] Your First Task**
- Estimate: TBD
- State: `UNCLAIMED`
- Owner: None
- Dependencies: None
- Tasks:
  1. Define your task requirements
  2. Break down into subtasks
  3. Implement
  4. Write tests
  5. Document
- Review required: [Choose based on task complexity]

---

## ✅ RECENTLY COMPLETED (Last 3)

(Empty - ready for your project)

---

## 🔑 KEY DECISIONS (Last 5)

(Empty - document important decisions as you make them)

---

## 📋 PROJECT RULES (Quick Reference)

1. **Testing:** Write tests as you develop (define your coverage target)
2. **Type Safety:** Use type hints and validation
3. **Documentation:** Document as you code
4. **Code Quality:** Follow your project's style guide
5. **Dependencies:** Manage dependencies properly (e.g., requirements.txt, package.json)

**📖 Deep Dives:**
- Full workflow guide → `CLAUDE.md`
- Project-specific rules → Add your own documentation

---

## 📚 REFERENCE DOCS

**Loaded every session:**
- `ACTIVE.md` - This file (current sprint state)

**Read when needed:**
- `CLAUDE.md` - Workflow guide, role definitions, coordination patterns
- `.claude/agents/*.md` - Agent persona definitions (Coordinator loads when spawning)
- `PROJECT_PROGRESS.md` - Big picture tracking (phases, metrics, blockers)

---

## 🚨 HANDOVER CHECKLIST

When you finish work:
- [ ] Mark task done in "RECENTLY COMPLETED"
- [ ] Add decisions to "KEY DECISIONS" (if any)
- [ ] Update "NEXT UP" (define next task)
- [ ] Update "Last Updated" header
- [ ] Commit and push changes

---

## 🤖 ROLE CLARITY

**If you are a WORKER AGENT (implementation):**
- Read ACTIVE.md at start (automatic via hook)
- Implement task from "IN PROGRESS" (Coordinator assigns to you)
- Update ACTIVE.md before ending session
- Report completion to Coordinator
- Coordinator moves your work to "IN REVIEW"

**If you are a REVIEW AGENT (Staff Engineer, TDD Expert, QA Engineer, Security Reviewer, or Performance Reviewer):**
- Read ACTIVE.md at start (automatic via hook)
- Review the task in "IN REVIEW" section
- Add your review feedback to the task
- Mark your review: APPROVED, REQUEST_CHANGES, or BLOCKED
- Report completion to Coordinator

**If you are the COORDINATOR (talking directly to user):**
- Move tasks between states (`UNCLAIMED` → `IN_PROGRESS` → `IN_REVIEW` → `COMPLETED`)
- Spawn worker agents for implementation
- Spawn review agents after implementation
- Coordinate feedback loops (`IN_REVIEW` → `ADDRESSING_FEEDBACK` → `IN_REVIEW`)
- Maintain project progress tracking after major milestones
- User talks to YOU, not to agents

---

## 📊 STATE TRANSITIONS (Coordinator Only)

**Task State Machine:**
```
`UNCLAIMED`: Task ready to start
    ↓ Coordinator spawns worker
`IN_PROGRESS`: Worker implementing
    ↓ Worker completes, Coordinator moves to review
`IN_REVIEW`: Review agents provide feedback (parallel)
    ↓ If all approve
`COMPLETED`: Task done
    ↓ If changes needed
`ADDRESSING_FEEDBACK`: Worker fixes issues
    ↓ Worker completes fixes
(back to `IN_REVIEW` for re-approval)
```

**Only Coordinator changes states.** Agents report completion, Coordinator transitions.

**Use the transition command:**
```bash
.claude/workflow/transition TASK-001 UNCLAIMED IN_PROGRESS
```

---

*This file stays ~200 lines. Completed work is tracked in `PROJECT_PROGRESS.md`.*
