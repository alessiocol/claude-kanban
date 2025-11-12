# Multi-Agent Coordination Template

A deterministic workflow system for coordinating multiple Claude agents over long-term, multi-phase projects without context loss.

## What is This?

This template provides a **battle-tested coordination system** that solves the "agentic Alzheimer's" problem - where AI agents lose context between sessions, forget past decisions, and break each other's work.

**Key Benefits:**
- ✅ **Zero Context Loss:** Every decision is documented and preserved
- ✅ **Deterministic Handovers:** Agents always know what was done and what's next
- ✅ **Parallel Reviews:** Multi-role review workflow (Staff Engineer, TDD Expert, QA, Security, Performance)
- ✅ **Scalable:** Maintains constant ~200-line active context regardless of project length
- ✅ **Hook-Based Enforcement:** Git and session hooks ensure process discipline

## Architecture

**Two-Role Pattern:**
```
User ←→ Coordinator Claude ←→ Worker Agents
         ↓                      ↓
    PROJECT_PROGRESS.md     ACTIVE.md
    (big picture)           (current sprint)
```

**Core Components:**
- **ACTIVE.md** - Current sprint state (~200 lines, loaded every session via hook)
- **PROJECT_PROGRESS.md** - Big picture tracking (phases, metrics, progress)
- **CLAUDE.md** - Workflow guide (roles, coordination patterns, examples)
- **.claude/agents/** - Reusable agent personas (Worker, Staff Engineer, TDD Expert, QA, Security, Performance)
- **.claude/hooks/** - Git and session hooks for enforcement
- **.claude/workflow/** - State transition validation scripts

## Quick Start

### 1. Install Hooks

```bash
# Install pre-commit framework
pip install pre-commit

# Install hooks
./.claude/workflow/hooks --install

# To uninstall
./.claude/workflow/hooks --uninstall
```

### 2. Customize for Your Project

See [TEMPLATE_GUIDE.md](TEMPLATE_GUIDE.md) for step-by-step instructions on:
- Creating your VISION.md (architecture, design principles)
- Creating your ROADMAP.md (phase-by-phase plan)
- Creating PROJECT_PROGRESS.md (tracking your actual project)
- Defining project-specific rules in ACTIVE.md
- Customizing commit-msg validation

### 3. Start Your First Sprint

1. Update ACTIVE.md with your first task
2. Spawn a worker agent (Coordinator reads `.claude/agents/worker.md` → customizes → spawns)
3. Worker implements, updates ACTIVE.md, commits
4. Spawn review agents if needed
5. Continue!

## How It Works

**Session Start (Automatic):**
- Hook displays ACTIVE.md
- Agent sees: what's in progress, what's next, recent decisions, project rules

**Do Work:**
- Follow PROJECT RULES in ACTIVE.md
- Commit frequently
- Document decisions as you make them

**Session End (Manual):**
- Update ACTIVE.md (handover checklist)
- Commit and push
- Next agent continues from your state

## Multi-Role Reviews

For critical work, coordinate peer reviews:

**Available Reviewers:**
- **Staff Engineer:** Architecture, design patterns, code structure
- **TDD Expert:** Test quality, coverage, TDD practices
- **QA Engineer:** End-to-end functionality, edge cases
- **Security Reviewer:** Vulnerabilities, data protection
- **Performance Reviewer:** Efficiency, scalability

**State Machine:**
```
UNCLAIMED → IN_PROGRESS → IN_REVIEW → COMPLETED
                             ↓
                      ADDRESSING_FEEDBACK
                             ↓
                      (back to IN_REVIEW)
```

Use `.claude/workflow/transition` command for deterministic state changes.

## Documentation

- **[CLAUDE.md](CLAUDE.md)** - Complete workflow guide
- **[TEMPLATE_GUIDE.md](TEMPLATE_GUIDE.md)** - How to customize this template
- **[.claude/README.md](.claude/README.md)** - Hook system documentation
- **[.claude/agents/README.md](.claude/agents/README.md)** - Agent persona reference

## Why This Works

**Traditional Multi-Agent Problem:**
- ❌ Agent A starts, doesn't know what Agent B did
- ❌ Forgets critical decisions from previous sessions
- ❌ Re-implements things differently
- ❌ Breaks existing code

**This Template's Solution:**
- ✅ Hook forces context load (ACTIVE.md) every session
- ✅ Handover checklist enforces documentation
- ✅ State machine validates transitions
- ✅ Next agent picks up exactly where you left off
- ✅ Context stays constant (~200 lines) via progressive compression

## Example Use Cases

This template is suitable for:
- Long-term software projects (3-12+ months)
- Multi-phase implementations
- Projects requiring code reviews
- Teams wanting deterministic agent coordination
- Projects where context preservation is critical

## Project Structure

```
.
├── CLAUDE.md                    # Main workflow guide
├── ACTIVE.md                    # Current sprint state (template)
├── README.md                    # This file
├── TEMPLATE_GUIDE.md            # Customization instructions
├── .claude/
│   ├── agents/                  # Agent persona definitions
│   │   ├── worker.md
│   │   ├── staff-engineer.md
│   │   ├── tdd-expert.md
│   │   ├── qa-engineer.md
│   │   ├── security-reviewer.md
│   │   └── performance-reviewer.md
│   ├── hooks/
│   │   ├── git/                 # Git hooks (commit-msg, etc.)
│   │   └── session-start.sh     # Session start hook
│   ├── workflow/
│   │   ├── transition           # State transition validator
│   │   └── install-hooks.sh     # Hook installation script
│   ├── state/
│   │   ├── ACTIVE.md            # Symlink to root ACTIVE.md
│   │   └── archive/             # Completed work archives
│   ├── settings.json            # Hook configuration
│   └── README.md                # Hook system docs
└── .git/
    └── hooks/                   # Git hooks (symlinked)
```

## License

This template is provided as-is for use in your own projects. Customize freely.

## Credits

Developed for the [agentic-trader](https://github.com/alessiocol/agentic-trader) project and extracted as a reusable template.

---

**Ready to start?** See [TEMPLATE_GUIDE.md](TEMPLATE_GUIDE.md) for detailed setup instructions.
