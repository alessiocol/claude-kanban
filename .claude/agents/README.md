# Agent Persona Definitions

This directory contains reusable agent persona definitions for the multi-agent coordination system.

## Purpose

Instead of writing agent prompts inline every time, these personas provide:
- **Consistency:** Same prompts used across sessions
- **Versioning:** Agent behavior is tracked in git
- **Reusability:** Load and customize for specific tasks
- **Maintainability:** Update agent behavior in one place

## Available Personas

### Implementation Agents

**worker.md** - Tactical implementation agent
- Implements specific tasks from ACTIVE.md
- Follows project rules
- Updates state before ending session
- **Use for:** All implementation work (Phase 1-6)

### Review Agents

**staff-engineer.md** - Architecture & code quality reviewer
- Reviews SOLID principles, design patterns
- Checks layer boundaries
- Validates alignment with VISION.md
- **Use for:** All Phase 1 tasks, complex implementations

**tdd-expert.md** - Test quality & coverage reviewer
- Checks test coverage (80%+ overall, 100% critical)
- Reviews test quality (clarity, independence, AAA pattern)
- Identifies missing edge cases
- **Use for:** All Phase 1 tasks, testing-critical work

**qa-engineer.md** - Quality assurance & integration reviewer
- End-to-end functionality testing
- Edge cases and boundary conditions
- Integration points
- **Use for:** Complex implementations, Phase 2+ critical work

**security-reviewer.md** - Security & data protection reviewer
- OWASP Top 10 vulnerabilities
- Data protection (credentials, PII, financial data)
- Input validation
- **Use for:** Trading logic, broker integration, API endpoints

**performance-reviewer.md** - Performance & scalability reviewer
- Algorithm complexity
- Database query optimization
- Scalability concerns
- **Use for:** Event store, database queries, trading loops

## Usage by Coordinator

### Step 1: Read Persona File

```python
# Read the persona definition
with open(".claude/agents/worker.md", "r") as f:
    worker_persona_template = f.read()

# Extract just the prompt section
prompt_template = extract_prompt_section(worker_persona_template)
```

### Step 2: Customize with Task Details

```python
# Replace placeholders with actual values
prompt = prompt_template.replace("{TASK_DESCRIPTION}", "Implement SQLite Event Store")
prompt = prompt.replace("{TASK_REQUIREMENTS}", """
1. Create project structure (src/, tests/)
2. Set up Poetry (pyproject.toml)
3. Implement SQLite event store
4. Create BaseEvent Pydantic model
5. Write tests (80%+ coverage)
""")
prompt = prompt.replace("{TASK_NAME}", "Event Store Setup")
```

### Step 3: Spawn Agent

```python
# Use Task tool with customized prompt
Task(
  subagent_type="general-purpose",
  description="Implement Event Store",
  prompt=prompt
)
```

## Template Variables

All personas support these template variables:

### Worker Agent
- `{TASK_DESCRIPTION}` - High-level task description
- `{TASK_REQUIREMENTS}` - Specific requirements (numbered list)
- `{TASK_NAME}` - Short task name for acknowledgment

### Review Agents
- `{TASK_NAME}` - Task being reviewed
- `{CODE_LOCATION}` - Path to implementation
- `{TEST_LOCATION}` - Path to tests (for TDD/QA)
- `{COMMIT_HASH}` - Git commit hash of implementation
- `{DATE}` - Review date (YYYY-MM-DD)

## Example: Complete Workflow

```python
# 1. Coordinator spawns worker with persona
worker_prompt = load_and_customize(
    ".claude/agents/worker.md",
    {
        "TASK_DESCRIPTION": "Implement Event Store",
        "TASK_REQUIREMENTS": "1. Create src/...\n2. Setup Poetry...",
        "TASK_NAME": "Event Store Setup"
    }
)

Task(subagent_type="general-purpose", prompt=worker_prompt)

# 2. Worker completes, Coordinator transitions state
.claude/workflow/transition TASK-001 IN_PROGRESS IN_REVIEW

# 3. Coordinator spawns review agents in parallel
staff_engineer_prompt = load_and_customize(
    ".claude/agents/staff-engineer.md",
    {
        "TASK_NAME": "Event Store Setup",
        "CODE_LOCATION": "src/event_store/",
        "COMMIT_HASH": "abc123f",
        "DATE": "2025-11-12"
    }
)

tdd_expert_prompt = load_and_customize(
    ".claude/agents/tdd-expert.md",
    {
        "TASK_NAME": "Event Store Setup",
        "TEST_LOCATION": "tests/event_store/",
        "COMMIT_HASH": "abc123f",
        "DATE": "2025-11-12"
    }
)

# Spawn both in parallel
Task(subagent_type="general-purpose", prompt=staff_engineer_prompt)
Task(subagent_type="general-purpose", prompt=tdd_expert_prompt)

# 4. Reviews complete, Coordinator checks ACTIVE.md
# 5. If all approved: transition to COMPLETED
# 6. If changes needed: transition to ADDRESSING_FEEDBACK, spawn worker again
```

## Maintaining Personas

### When to Update Personas:

**Update immediately:**
- Project rules change (new rule added to ACTIVE.md)
- Review criteria change (new standards)
- Critical issues found in agent behavior

**Batch updates:**
- Minor wording improvements
- Additional examples
- Clarifications

### Version Control:

All personas are tracked in git, so:
- Changes are versioned
- Can see history of agent evolution
- Can revert if agent behavior regresses

## Adding New Personas

To add a new agent persona:

1. **Create file:** `.claude/agents/new-agent-name.md`
2. **Follow template:**
   - Role, Purpose, Spawned by section
   - Agent Prompt Template section (what agent sees)
   - Usage by Coordinator section (how to spawn)
3. **Define variables:** Document all `{VARIABLE}` placeholders
4. **Test:** Spawn the agent and verify behavior
5. **Document:** Update this README

## Benefits

✅ **Consistency:** Same prompts across sessions
✅ **Maintainability:** Update behavior in one place
✅ **Versioning:** Agent evolution tracked in git
✅ **Reusability:** Easy to spawn agents
✅ **Clarity:** Agent roles and criteria documented
✅ **Flexibility:** Can customize per-task while maintaining core persona

---

**See CLAUDE.md for complete coordination workflow including how to use these personas.**
