# AGENTS.md - EMPIRE OF RUINS (Agent-Agnostic Instructions)

## Project Overview
A slow, single-player empire-builder game focusing on organic growth and internal management.
**Tech Stack:** Python 3, Pygame, JSON data/save formats.
**Current State:** Design Phase (see `ProectKalyanicontext.md`).

## Core Conventions
1. **Design First:** Always brainstorm and plan before modifying the design document or code.
2. **Organic Growth:** All game systems must support the "enable growth, don't force it" philosophy.
3. **Agent Agnosticism:** This project is designed to be worked on by any AI agent (Claude, Cursor, Copilot, Gemini). Follow the instructions in this file and `agent-skills/`.

## Agent Skills & Triggers
Refer to the individual `SKILL.md` files in `agent-skills/` for full instructions on these specialized workflows. Each skill is contained in its own directory:

### Engineering Rigor (Matt Pocock)
- **grill-me:** `agent-skills/grill-me/SKILL.md` - "Use `/grill-me` to resolve all decision tree branches before coding."
- **tdd:** `agent-skills/tdd/SKILL.md` - "Always use Test-Driven Development for implementation."
- **diagnose:** `agent-skills/diagnose/SKILL.md` - "Systematically diagnose bugs before proposing fixes."
- **improve-architecture:** `agent-skills/improve-architecture/SKILL.md` - "Refactor for architectural clarity as the project grows."

### Workflow Process (Superpowers)
- **brainstorming:** `agent-skills/brainstorming/SKILL.md` - "Always `brainstorm` a design before implementation."
- **writing-plans:** `agent-skills/writing-plans/SKILL.md` - "Execute all work via bite-sized `writing-plans`."
- **subagents:** `agent-skills/subagent-development/SKILL.md` - "Use subagents for batch tasks and high-volume output."
- **debugging:** `agent-skills/systematic-debugging/SKILL.md` - "Use systematic debugging for complex issues."
- **save-context:** `agent-skills/save-context/SKILL.md` - "Automate saving context to the `context/` directory while respecting file limits."

### Extensibility (Vercel Labs)
- **find-skills:** `agent-skills/find-skills/SKILL.md` - "Use `npx skills find [query]` to discover modular tools for new requirements."

## Setup & Development
- **Dependencies:** `pip install pygame` (when implementation begins).
- **Context:** Always keep `ProectKalyanicontext.md` updated with design decisions.
