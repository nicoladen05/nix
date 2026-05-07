---
name: clean-code
description: Pragmatic coding standards - concise, direct, no over-engineering, no unnecessary comments.
priority: CRITICAL
---

# Clean Code - Pragmatic AI Coding Standards

## Priority

**CRITICAL**

Be concise, direct, and solution-focused.

## Core Principles

| Principle | Rule |
|---|---|
| SRP | Single Responsibility: each function or class does one thing. |
| DRY | Don't Repeat Yourself: extract duplicates and reuse logic. |
| KISS | Keep It Simple: prefer the simplest solution that works. |
| YAGNI | You Aren't Gonna Need It: don't build unused features. |
| Boy Scout | Leave code cleaner than you found it. |

## Naming Rules

| Element | Convention |
|---|---|
| Variables | Reveal intent: `userCount`, not `n`. |
| Functions | Use verb + noun: `getUserById()`, not `user()`. |
| Booleans | Use question form: `isActive`, `hasPermission`, `canEdit`. |
| Constants | Use `SCREAMING_SNAKE_CASE`: `MAX_RETRY_COUNT`. |

If a name needs a comment to explain it, rename it.

## Function Rules

| Rule | Description |
|---|---|
| Small | Keep functions under 20 lines; ideally 5-10 lines. |
| One Thing | Each function should do one thing well. |
| One Level | Keep one level of abstraction per function. |
| Few Arguments | Use at most 3 arguments; prefer 0-2. |
| No Side Effects | Do not mutate inputs unexpectedly. |

## Code Structure

| Pattern | Apply |
|---|---|
| Guard Clauses | Return early for edge cases. |
| Flat > Nested | Avoid deep nesting; max 2 levels. |
| Composition | Build behavior from small functions. |
| Colocation | Keep related code close together. |
