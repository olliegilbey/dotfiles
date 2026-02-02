# CLAUDE.md Best Practices Report (2026)

> Research compiled from official Anthropic documentation, community discoveries, and prompt engineering research (Nov 2025 - Feb 2026)

---

## Executive Summary

CLAUDE.md files have evolved from simple project documentation to critical context engineering artifacts. Key findings:

1. **Token Budget is Finite**: ~150-200 instructions max for frontier LLMs; Claude Code's system prompt already uses ~50
2. **Less is More**: Shorter files outperform bloated ones; aim for <300 lines, ideally <100
3. **Iterate Like Prompts**: Treat as living prompt engineering, not static documentation
4. **Claude 4.x Changed the Game**: More literal instruction-following, less "helpful guessing"

---

## Part 1: Architecture & Placement

### File Hierarchy (Priority Order)

```
~/.claude/CLAUDE.md              # User-level (all projects)
./CLAUDE.md                      # Project root (team-shared, git tracked)
./CLAUDE.local.md                # Personal overrides (.gitignore'd)
./.claude/CLAUDE.md              # Organized subdirectory approach
./subdir/CLAUDE.md               # Loaded on-demand when working in subdir
```

### Actionable Directives

- ✅ **DO** commit `CLAUDE.md` to git - creates team alignment and history
- ✅ **DO** use `CLAUDE.local.md` for personal preferences (gitignore it)
- ✅ **DO** use `@path/to/file.md` syntax to import external docs
- ❌ **DON'T** gitignore main CLAUDE.md - loses cross-machine sync and team benefits

---

## Part 2: Content Guidelines

### The Three Essential Sections

| Section | Purpose | Example |
|---------|---------|---------|
| **WHAT** | Tech stack, architecture, project structure | "Monorepo: apps/ (Next.js), packages/ (shared)" |
| **WHY** | Project purpose, component goals | "Auth service handles SSO for all apps" |
| **HOW** | Commands, workflows, verification | "Run `bun test` before commits" |

### What to Include

```markdown
# Include These (Claude Can't Infer)
- Bash commands Claude can't guess (`bun run dev:local`)
- Code style rules differing from defaults
- Testing instructions and preferred runners
- Repository etiquette (branch naming, PR conventions)
- Architectural decisions specific to project
- Developer environment quirks (required env vars)
- Common gotchas or non-obvious behaviors
```

### What to Exclude

```markdown
# Exclude These (Wastes Tokens)
- Anything Claude can figure out by reading code
- Standard language conventions (Claude already knows)
- Detailed API documentation (link to docs instead)
- Information that changes frequently
- Long explanations or tutorials
- File-by-file codebase descriptions
- Self-evident practices like "write clean code"
```

### Progressive Disclosure Pattern

Instead of embedding everything:

```markdown
# CLAUDE.md (keep minimal)
See @docs/architecture.md for system design.
See @docs/api-conventions.md for REST patterns.
```

Reference files rather than embedding - Claude reads on-demand.

---

## Part 3: Instruction Optimization

### The Token Budget Reality

| Model Tier | Reliable Instruction Limit | Implication |
|------------|---------------------------|-------------|
| Frontier (Opus 4.5) | ~150-200 instructions | Linear degradation past limit |
| Mid-tier (Sonnet) | ~100-150 instructions | Moderate degradation |
| Small (Haiku) | ~50-80 instructions | Exponential decay |

**Claude Code's system prompt uses ~50 instructions** → Your CLAUDE.md should contain the minimum necessary.

### Emphasis Words (Use Sparingly)

```markdown
# Effective emphasis (increases adherence ~20-30%)
IMPORTANT: Never modify the migrations folder directly.
YOU MUST run tests before committing.

# Less effective in Claude 4.x (context > caps)
CRITICAL: ALWAYS USE SEMANTIC COMMIT MESSAGES!!!
```

**Key finding**: Claude 4.x prioritizes *context and logic* over emphasis. Explain *why* for better adherence than shouting.

### Format for Clarity

```markdown
# Good: Scannable, specific
- Use ES modules (import/export), not CommonJS (require)
- Destructure imports: `import { foo } from 'bar'`
- Run `bun typecheck` after code changes

# Bad: Vague, verbose
- Please make sure to format code properly according to our standards
- When you write code, try to follow best practices
```

---

## Part 4: Claude 4.x Specific Practices

### The Over-Engineering Problem

Claude Opus 4.5 tends to create extra files, add unnecessary abstractions, and build unneeded flexibility.

**Required prompt addition for Opus 4.5:**

```markdown
# In CLAUDE.md
Avoid over-engineering. Only make changes directly requested or clearly necessary.
- Don't add features, refactor, or make "improvements" beyond what was asked
- A bug fix doesn't need surrounding code cleaned up
- Don't add error handling for scenarios that can't happen
- Don't create helpers/utilities/abstractions for one-time operations
- Trust internal code and framework guarantees
```

### Tool Usage Changes

**Before (Claude 3.x)**: "CRITICAL: You MUST use this tool when..."
**After (Claude 4.x)**: "Use this tool when..."

Claude 4.x overtriggers with aggressive prompting. Dial back emphasis.

### Literal Instruction Following

```markdown
# Claude 4.x interprets literally
"Can you suggest changes?" → Will ONLY suggest, not implement
"Change this function" → Will implement changes

# Be explicit about action vs. advice
"Implement X" not "Could you maybe look at X?"
```

---

## Part 5: Anti-Patterns to Avoid

### ❌ The Kitchen Sink CLAUDE.md

**Problem**: 500+ lines of every possible instruction
**Result**: Claude ignores critical rules buried in noise
**Fix**: Ruthlessly prune. Ask: "Would removing this cause mistakes?"

### ❌ Linter Instructions in CLAUDE.md

**Problem**: "Use 2 spaces, semicolons, single quotes..."
**Result**: Wastes tokens; formatters do this better
**Fix**: Use hooks/pre-commit for style. Claude learns from codebase patterns.

### ❌ Auto-Generated Without Editing

**Problem**: `/init` creates reasonable starting point
**Result**: Unreviewed content wastes context
**Fix**: Edit every line manually. Delete generic content.

### ❌ Never Updating After Creation

**Problem**: Static file becomes stale
**Result**: Instructions don't match reality
**Fix**: Update after every "Claude made that mistake again" moment

### ❌ Correcting in Conversation Instead of CLAUDE.md

**Problem**: Same corrections repeated across sessions
**Result**: Wasted tokens each session
**Fix**: After correcting twice, add to CLAUDE.md

---

## Part 6: Optimization Workflow

### The Feedback Loop

```
Claude makes mistake
    ↓
Developer notices
    ↓
Ask: "How can you modify CLAUDE.md to prevent this?"
    ↓
Add pattern to CLAUDE.md
    ↓
Commit to git
    ↓
Claude reads next session
    ↓
Mistake doesn't recur
```

### Research-Backed Optimization

From Arize's prompt learning research:

| Optimization Type | Improvement |
|------------------|-------------|
| General prompt optimization | +5.19% on SWE Bench |
| Repository-specific training | +10.87% improvement |

**Method**: Train on historical issues from your codebase, use LLM feedback to refine.

### Pruning Checklist

For each instruction, ask:
1. Does Claude already do this correctly without the instruction? → **Delete**
2. Is this task-specific rather than universal? → **Move to skill/hook**
3. Can a linter/formatter/hook handle this? → **Remove and automate**
4. Does removing this cause measurable mistakes? → **Keep**

---

## Part 7: Advanced Patterns

### Hooks vs CLAUDE.md

| Use CLAUDE.md For | Use Hooks For |
|-------------------|---------------|
| Context Claude needs to understand | Actions that MUST happen every time |
| Guidelines with flexibility | Deterministic operations |
| "Prefer X over Y" | "Run X after every edit" |
| Style preferences | Linting, formatting, testing |

### Skills for Domain Knowledge

```markdown
# .claude/skills/api-conventions/SKILL.md
---
name: api-conventions
description: REST API design conventions
---
# API Conventions
- Use kebab-case for URL paths
- Use camelCase for JSON properties
- Always include pagination for list endpoints
```

Claude loads skills on-demand, keeping CLAUDE.md lean.

### Modular Organization (Large Projects)

```
.claude/
├── rules/
│   ├── git-workflow.md
│   ├── testing-requirements.md
│   └── security-policies.md
├── skills/
│   └── api-design/SKILL.md
└── agents/
    └── security-reviewer.md
```

Reference in CLAUDE.md:
```markdown
See @.claude/rules/git-workflow.md for commit conventions.
```

---

## Part 8: Session Management

### Context Hygiene

```markdown
# Add to CLAUDE.md for long sessions
Run /clear between unrelated tasks.
After 2 failed corrections, /clear and start fresh with better prompt.
Use subagents for research to preserve main context.
```

### Verification Requirements

```markdown
# Always include verification paths
- Run `bun test` after code changes
- Check `bun typecheck` passes
- For UI: take screenshot and compare to mockup
- For APIs: test with `curl` examples provided
```

**Key insight**: Claude performs dramatically better when it can self-verify.

---

## Part 9: Template Structure

### Minimal Effective CLAUDE.md (~50-100 lines)

```markdown
# Project: [Name]
[One-line description]

## Commands
- `bun dev` - Start development server
- `bun test` - Run tests (run before committing)
- `bun typecheck` - Type checking

## Code Style
- ES modules (import/export), not CommonJS
- Destructure imports when possible

## Architecture
[2-3 sentences on key patterns]

## Verification
- All PRs require passing tests
- Run typecheck after changes

## Common Mistakes to Avoid
- Don't modify migrations directly
- Don't use deprecated X API, use Y instead

## Important
Avoid over-engineering. Only make requested changes.
```

### What Anthropic's Team Uses

Boris Cherny (Claude Code creator) reports their CLAUDE.md is ~2.5k tokens (~600 words). They:
- Contribute multiple times per week
- Use @.claude tag on PRs to add learnings
- Prune aggressively based on mistake rates

---

## Part 10: Actionable Checklist

### Setup Phase
- [ ] Run `/init` to generate baseline
- [ ] Delete 50%+ of generated content
- [ ] Add only universal instructions
- [ ] Commit to git for team sharing
- [ ] Create `CLAUDE.local.md` for personal prefs

### Per-Session
- [ ] `/clear` between unrelated tasks
- [ ] Use subagents for research (preserves context)
- [ ] Correct mistakes max 2x, then improve prompt

### Weekly Maintenance
- [ ] Review mistakes from week
- [ ] Add patterns to prevent recurring issues
- [ ] Prune instructions that aren't helping
- [ ] Test if removing instructions causes problems

### For Claude 4.x/Opus 4.5
- [ ] Add anti-over-engineering instructions
- [ ] Dial back CRITICAL/MUST language
- [ ] Be explicit about action vs. advice
- [ ] Explain *why* for important rules

---

## Sources

### Official Documentation
- [Claude Code Best Practices](https://code.claude.com/docs/en/best-practices)
- [Claude 4.x Prompting Best Practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-4-best-practices)
- [Opus 4.5 Migration Guide](https://github.com/anthropics/claude-code/blob/main/plugins/claude-opus-4-5-migration/)

### Community Research
- [Arize: CLAUDE.md Optimization with Prompt Learning](https://arize.com/blog/claude-md-best-practices-learned-from-optimizing-claude-code-with-prompt-learning/)
- [HumanLayer: Writing a Good CLAUDE.md](https://www.humanlayer.dev/blog/writing-a-good-claude-md)
- [Builder.io: Complete Guide to CLAUDE.md](https://www.builder.io/blog/claude-md-guide)

### Developer Experiences
- [How Claude Code's Creator Uses It](https://medium.com/@rub1cc/how-claude-codes-creator-uses-it-10-best-practices-from-the-team-e43be312836f)
- [10 Claude Code Productivity Tips](https://www.f22labs.com/blogs/10-claude-code-productivity-tips-for-every-developer/)
- [Claude Code Tips Repository](https://github.com/ykdojo/claude-code-tips)

### System Prompt Analysis
- [Claude Code System Prompts Repository](https://github.com/Piebald-AI/claude-code-system-prompts) (v2.1.29, Jan 2026)
- [Addy Osmani: LLM Coding Workflow 2026](https://addyosmani.com/blog/ai-coding-workflow/)

---

*Report generated: 2026-02-02*
