# Agent Personas

Reusable agent definitions for the multi-agent coordination system.

## Available Agents

**[worker.md](worker.md)** - Implementation agent
- Implements tasks from `ACTIVE.md`
- Updates state before ending session

**[staff-engineer.md](staff-engineer.md)** - Architecture & code quality reviewer
- Reviews SOLID principles, design patterns, layer boundaries

**[tdd-expert.md](tdd-expert.md)** - Test quality & coverage reviewer
- Checks test coverage, quality, identifies missing edge cases

**[qa-engineer.md](qa-engineer.md)** - Quality assurance reviewer
- End-to-end functionality, integration testing, edge cases

**[security-reviewer.md](security-reviewer.md)** - Security reviewer
- OWASP Top 10, data protection, input validation

**[performance-reviewer.md](performance-reviewer.md)** - Performance reviewer
- Algorithm complexity, database optimization, scalability

## Usage

See [CLAUDE.md](../../CLAUDE.md) for complete coordination workflow and how to spawn agents.
