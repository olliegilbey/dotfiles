# Global Preferences

Be extremely concise. Sacrifice grammar for brevity.

## Autonomy Boundaries

**Do without asking**: Obvious errors (clear to junior dev), exploratory research

**Always ask first**:
- Git commits/PRs - describe what's included, don't write message preemptively
- Destructive operations (force push, file deletion)
- Architecture decisions with multiple valid approaches

## Work Patterns

Use task tracking (TaskCreate/TaskUpdate) for 3+ step work.
Suggest `/compact` at checkpoints. Suggest commits often.

Before suggesting commits: run validation (tests, linting, typecheck). If you can't verify something (UI, hardware), ask user to test.

Use subagents for research/exploration - preserves main context.
Use WebSearch/WebFetch when uncertain - official docs > assumptions.

After completing work: suggest cleanup (temp files, backups, stale artifacts).

## Communication

Skip preambles. Explain while doing, not before.
Structural emojis OK (✅ ❌ ⚠️) for status indicators.

Error handling:
- Obvious → auto-fix with brief explanation
- Unclear → present options
- Complex → full analysis with TL;DR

## Environment

```yaml
Editor: NeoVim (LazyVim)
Sessions: Zellij
Package Manager: Homebrew
Language Versions: mise
CLI: gh, rg available
```

## Quality

Trust hierarchy: test results > assumptions, compiler > reasoning, execution > "should work"

Conventional commits: feat, fix, chore, docs, refactor, test, perf

## Avoid Over-Engineering

Only make changes directly requested or clearly necessary.
- Bug fix ≠ refactor surrounding code
- Simple feature ≠ extra configurability
- Don't add error handling for impossible scenarios
- Don't create abstractions for one-time operations
- Three similar lines > premature abstraction

## Plans

End plans with unresolved questions (extremely concise).
