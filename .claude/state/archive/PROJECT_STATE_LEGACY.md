# Project State - READ THIS FIRST

**Last Updated:** 2025-11-10 (Initial Setup)
**Current Phase:** Phase 1 - Foundation (Week 0/8)
**Status:** Setting up coordination infrastructure

---

## WHAT'S DONE ✅

- [x] VISION.md - System architecture and product vision defined
- [x] ROADMAP.md - 6-month implementation plan created
- [x] Coordination infrastructure - Session hooks and workflow established

---

## WHAT'S NEXT ⏭️

**Phase 1, Week 1-2: Event Store Setup**

**Tasks:**
1. Create project structure (src/, tests/, config/)
2. Set up Poetry (pyproject.toml with dependencies)
3. Implement SQLite event store schema
   - Table: `events(id, aggregate_id, event_type, version, data_json, timestamp, trace_id, trace_url)`
   - Indexes on aggregate_id, event_type, timestamp
4. Create BaseEvent Pydantic model
5. Implement append/replay logic
6. Write tests (aim for 80%+ coverage)
7. Update this file when complete

**Owner:** Next agent
**Estimated Duration:** 2 weeks
**Dependencies:** None (starting fresh)

---

## KEY DECISIONS

Track important architectural and implementation decisions here.

**Format:** `[Date] Decision: Rationale`

### [2025-11-10] Coordination via PROJECT_STATE.md
- **Decision:** Use living document (PROJECT_STATE.md) + session hooks for agent coordination
- **Rationale:** Simple, deterministic, forces context load and handover discipline
- **Impact:** Every agent must read state at start, update at end

### [2025-11-10] Phase 1 Focus: Foundation Layer
- **Decision:** Start with event store, domain models, config framework
- **Rationale:** Core infrastructure needed before services/agents
- **Impact:** Sequential - must complete Layer 1 before Layer 2

---

## PROJECT RULES

These are principles to follow as code develops. Early on, focus on architecture. As system matures, these become more critical.

### 1. Financial Precision
- Use `Decimal` type for money, prices, quantities, P&L (NOT `float`)
- Applies to: `src/domain/`, `src/services/`, `src/broker/`
- Rationale: Float has precision errors unacceptable for financial calculations
- **Check:** Will be validated by type hints and tests as code develops

### 2. No Hardcoded Values
- Configuration goes in config system (not constants in code)
- Rationale: System needs to be highly configurable (see VISION.md)
- **Check:** Look for magic numbers, suggest moving to config

### 3. Event Sourcing
- All state changes must emit events
- Events are immutable (never delete/update)
- Pattern: `event_store.append(Event(...))`
- Rationale: Complete audit trail, time-travel debugging
- **Check:** State-changing functions should append events

### 4. Type Safety
- Use enums for signals/decisions (e.g., `Signal.BUY` not `"buy"`)
- Use type hints throughout
- Rationale: Prevents magic strings, enables type checking
- **Check:** Run `mypy` when type checking is set up

### 5. Testing Standards
- Target: 80%+ overall coverage
- Critical paths (trading, risk, broker): 100% coverage
- Write tests as you develop (not after)
- Rationale: Financial system needs reliability
- **Check:** `pytest --cov=src --cov-fail-under=80`

### 6. Layer Boundaries (Architecture)
- **Layer 1** (domain, events, config): No dependencies
- **Layer 2** (services): Can import Layer 1
- **Layer 3** (agents): Can import Layers 1-2
- **Layer 4** (api): Can import Layers 1-3
- **Layer 5** (ui): Can import Layer 4 ONLY
- Rationale: Prevents spaghetti, enables parallel development
- **Check:** Don't import from higher layers

### 7. Dependency Management
- Use Poetry (`pyproject.toml`)
- No `requirements.txt`
- Rationale: Better dependency resolution, lockfile support
- **Check:** Ensure Poetry is used for new dependencies

---

## PHASE ROADMAP (High-Level Context)

**Phase 1 (Weeks 1-8):** Foundation ← WE ARE HERE
- Event store, domain models, config framework, basic API
- **Deliverable:** Layer 1 complete, ready for services

**Phase 2 (Weeks 9-22):** Multi-Agent AI Engine
- LangGraph workflow, 5 agents, RAG memory, consensus algorithms
- **Deliverable:** Agents can analyze and debate

**Phase 3 (Weeks 23-32):** Integration
- Market data, broker API, paper trading execution
- **Deliverable:** End-to-end workflow operational

**Phase 4 (Weeks 33-46):** UI & Observability
- WebUI, dashboards, config UI, audit tools
- **Deliverable:** Complete system with user interface

**Phase 5 (Months 7-9):** Paper Trading Validation
- 3+ months of paper trading, prompt iteration
- **Deliverable:** Validated system ready for live trading

**Phase 6 (Month 10+):** Live Trading
- Real trades with small capital, gradual scaling
- **Deliverable:** Production system

See ROADMAP.md for detailed week-by-week breakdown.

---

## OPEN QUESTIONS / BLOCKERS

Track any blockers or questions that need user input.

**Format:** `[ID] Question/Blocker: Description (Status: OPEN/RESOLVED)`

- None currently

---

## HANDOVER CHECKLIST

**When you complete your task, you MUST:**

- [ ] Update "WHAT'S DONE" section (mark your task complete)
- [ ] Add any important decisions to "KEY DECISIONS"
- [ ] Update "WHAT'S NEXT" (define next logical task)
- [ ] List key files created/modified
- [ ] Update "Last Updated" header (date + brief description)
- [ ] Ensure all code is committed
- [ ] Ensure all changes are pushed to remote

**The session-start hook will remind the next agent to read this file.**
**Your handover creates their starting context.**

---

## REFERENCE DOCUMENTS

- **VISION.md** - Product vision, architecture, design principles
- **ROADMAP.md** - Detailed 6-month implementation plan
- **CLAUDE.md** - Agent workflow and coordination process (how to use this system)
- **.claude/hooks/session-start.sh** - Hook that displays this file at session start

---

## TIPS FOR SUCCESS

**Starting a session:**
1. Read this entire file (especially "WHAT'S NEXT")
2. Check "KEY DECISIONS" for important context
3. Review "PROJECT RULES" relevant to your task
4. Acknowledge you understand the task

**During work:**
1. Follow PROJECT RULES (especially layer boundaries)
2. Write tests as you go (not after)
3. Commit frequently with clear messages: `[Phase N] Brief description`
4. Document decisions as you make them

**Ending a session:**
1. Complete the HANDOVER CHECKLIST above
2. Ensure next agent has clear task in "WHAT'S NEXT"
3. Commit and push all changes

**When stuck:**
1. Check VISION.md for architectural guidance
2. Check ROADMAP.md for phase details
3. Add blocker to "OPEN QUESTIONS / BLOCKERS"
4. Ask user for clarification

---

**Last Updated:** 2025-11-10 - Initial setup of coordination infrastructure
