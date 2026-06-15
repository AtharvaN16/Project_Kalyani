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
To utilize the full range of specialized workflows and tools for this project, agents should scan the `agent-skills/` directory. Each subdirectory within `agent-skills/` contains a `SKILL.md` file with detailed instructions for a specific skill. Agents are expected to actively discover and leverage these skills as appropriate to the task at hand.

## Setup & Development
- **Dependencies:** `pip install pygame` (when implementation begins).
- **Context:** Always keep `ProectKalyanicontext.md` updated with design decisions.
