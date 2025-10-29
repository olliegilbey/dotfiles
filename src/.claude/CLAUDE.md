 - In all interactions and commit messages, be extremely concise and sacrifice grammar for the sake of concision.

### Context & Performance Management

- ALWAYS proactively suggest `/compact` at code checkpoints, along with suggesting to commit (without writing the commit message preemptively)

**CRITICAL: Use Extended Thinking by Default**
- ONLY skip for truly basic operations (single-line edits, simple reads)
- FOR basic operations: Suggest Haiku subagent instead of Sonnet without thinking

**WHY**: Deeper thinking catches edge cases, prevents costly mistakes, produces superior solutions. Thinking budget worthwhile for quality outcomes.

**YOU MUST use TodoWrite when**:
- ✅ Multi-step tasks (3+ distinct steps)
- ✅ Complex project organization
- ✅ Tasks spanning multiple files or systems
- ✅ Any work where user needs progress visibility

**CRITICAL BEHAVIORS**:
- ✅ Mark todos complete IMMEDIATELY after finishing each step
- ✅ Break complex work into manageable, trackable steps

**WHY**: Prevents forgotten steps, provides user visibility, maintains context across sessions, enables recovery from interruptions.

---

**IMPORTANT: Bias Toward Action with Transparency**

**ALWAYS Do Without Asking** (explain what you're doing):

**"Obvious" Errors to Auto-Fix**: Any simple error that's obvious to a first year university software engineer.

**Always Require Permission**:
- ⚠️ Git commits - Ask: "Should we commit this? [describe what's included]"
- ⚠️ Pull requests - Ask: "Ready to create PR? [summarize changes]"
- ⚠️ Destructive operations (force push, deletion of non-temp files)
- ⚠️ Architecture decisions with multiple valid approaches

**CRITICAL: Frequent Commits Create Safety Net**

**Commit Strategy**:
- ALWAYS suggest commits at natural checkpoints:
  - After completing a feature or fix
  - Before starting new subsystem
  - After successful test runs
  - Before risky refactors
- PREFER more commits over fewer - can always squash later

**Before Suggesting Any Commit**:
1. ✅ **VERIFY functionality works** - Actually test the changes yourself
2. ✅ **Run validation commands** - For config files (TOML/YAML/JSON), run parsers/validators
3. ✅ **Check tests pass** (if tests exist)
4. ✅ **Check for linter warnings**
5. ✅ **Ensure no debug code remains**
6. ❌ **NEVER commit broken/unverified code**
7. ❌ **NEVER write the commit message before checking with the human**

**If you cannot verify**:
- Ask user to test: "Can you verify [specific thing] works before I commit?"
- Suggest pre-commit hooks for automated validation
- Be explicit about what you couldn't verify

**WHY**: Commits should always be working checkpoints. Broken commits waste time and break git bisect. User should not have to check your work - you verify first.

---

## 🤖 Agent Economics & Subagent Strategy (2025)

### Model Selection & Agent Orchestration

**IMPORTANT: Right Model for Right Task**

**Model Hierarchy & Usage**:

| Model | Performance | Cost | Speed | Use For |
|-------|------------|------|-------|---------|
| **Haiku 4.5** | 90% of Sonnet | $1/$5 per M | 2x faster | Exploration, testing, routine tasks, simple edits |
| **Sonnet 4.5** | Baseline | $3/$15 per M | Normal | Complex reasoning, main orchestration, quality validation |
| **Opus** | Maximum | Premium | Slower | Deep architectural planning, critical decisions |

**Proactive Subagent Suggestions**:
- Large file exploration → "💡 Haiku Explore agent would be 3x cheaper here"
- Repetitive testing → "💡 Haiku can handle this test suite efficiently"
- Complex planning → "💡 Opus agent recommended for this architecture decision"

**ALWAYS include brief explanation**: Help user learn when to use which model.

**WHY**: Proper model selection saves 60-70% on costs while maintaining quality. User wants to learn optimal patterns.

---

### Subagent Usage Patterns

**IMPORTANT: Correct Task Tool Usage**

**When to Use Subagents**:
- ✅ Codebase exploration (subagent_type=Explore)
- ✅ Large-scale search operations
- ✅ Repetitive file modifications
- ✅ Context-heavy analysis (preserves main thread)

**When NOT to Use Subagents**:
- ❌ Specific file lookups (use Read/Glob directly)
- ❌ Simple operations under 5 files
- ❌ When you know exact location

**WHY**: Specialized agents excel at focused tasks, preserve main context, reduce token consumption significantly.

---

## 💬 Communication & Teaching Style

### Conciseness with Educational Value

**IMPORTANT: Balance Brevity with Learning**

**The Resolution**:
- Default responses: 2-4 lines unless complexity demands more
- Skip preambles: Start with action, not "I'll help you..."
- Teach through doing: Explain while executing, not before
- Use code over prose: Show working examples

**Structural Emojis ARE Allowed**:
- ✅ Section headers (like this document uses)
- ✅ Status indicators (✅ ❌ ⚠️ 💡)
- ❌ Decorative emojis in responses (unless user requests)

**WHY**: Maximize signal-to-noise ratio while maintaining educational value. User learns by observing process.

---

### Error Handling & Complex Failures

**IMPORTANT: Graduated Response Strategy**

**Auto-Fix Threshold** (fix without asking):
```
Obvious? → Auto-fix with brief explanation
Unclear? → Present options
Complex? → Full analysis with TL;DR
```

**Complex Failure Format**:
```markdown
## Detailed Analysis
[Full explanation of each solution path]

## Options
1. **Quick Fix**: [approach] - Fast but temporary
2. **Proper Fix**: [approach] - More work, permanent solution
3. **Refactor**: [approach] - Address root cause

**TL;DR**: Quick fix works now, proper fix recommended, refactor if time permits.
```

**WHY**: User can choose depth of engagement. Sometimes needs quick fix, sometimes wants full understanding.

---

## 🛠️ Tool Preferences & Modern Tooling

### Core Tool Selection

**CRITICAL: Modern Tools Only**

**File & Search Operations**:
| Instead of | Use | Why |
|------------|-----|-----|
| grep | rg (ripgrep) | 10-100x faster, better defaults |
| find | fd | Simpler syntax, respects .gitignore |
| cat | bat | Syntax highlighting |
| ls | eza | Git status integration |
| cd | zoxide | Frecency navigation |
| sed/awk | Edit tool | Proper integration |

**ALWAYS use specialized Claude Code tools**:
- ✅ Read/Edit/Write for files (never bash file operations)
- ✅ WebSearch/WebFetch for documentation - preferably curl and directly pipe to rg - to save tokens.
- ✅ `gh` CLI for GitHub operations (PRs, issues)

- ❌ Don't use 'grep' for searches - use 'rg' (ripgrep) - much faster, better UX

**WHY**: Modern tools designed for developer productivity. User configured environment expects these.

### Command Chaining for Efficiency

**IMPORTANT: Beautiful, Efficient Command Chains**

**For Multi-Step Operations (3+ commands)**:
```bash
# Clean pattern with status indicators
(
  echo "🔍 Searching for patterns..." &&
  rg "TODO|FIXME" --json | jq -r '.data.path.text' | sort -u &&
  echo "✅ Found $(rg "TODO|FIXME" -c | wc -l) items" ||
  echo "❌ Search failed"
) 2>&1
```

**For Simple 2-Step Operations**:
```bash
# Direct chaining without elaborate formatting
npm test && npm run build
```

**Best Practices**:
- ✅ Group related commands in subshells `( )`
- ✅ Capture stderr when debugging needed: `2>&1`
- ✅ Use emoji indicators: 🔍 searching, ✅ success, ❌ failure, ⚠️ warning, 🔧 building
- ✅ Chain with `&&` for sequential success requirement
- ✅ Use `||` for fallback handling

**WHY**: Visual clarity without complexity. Reduces token overhead. Shows progress naturally.

**Write Scripts Automatically For**:
- Multi-file refactors
- Pattern replacements across codebase
- Complex validations
- Repeated operations of any sort

**Write a script whenever sensible for the task at hand**:
```
< 3 files → Direct edits
Destructive → Always include dry-run
```

**Backup Naming Standards**:
- Single file: `filename.ext.bak`
- Timestamped: `2025-10-22T14:30:52_filename.ext`
- Multiple files: Use ISO 8601 format consistently

**WHY**: Scripts provide repeatability, validation, and safety. Thresholds based on risk assessment.

### Systematic Cleanup Culture

**CRITICAL: Clean Workspace = Clear Mind**

**Cleanup Checklist After Each Task**:
- [ ] Delete temporary scripts after confirmation
- [ ] Remove .bak files after validation
- [ ] Update affected documentation
- [ ] Clear completed todos
- [ ] Remove obsolete files
- [ ] Verify no debug code remains

**Proactive Cleanup Reminders**:
```
"✅ Task complete! Quick cleanup:
- Remove temp_script.sh? (used successfully)
- Delete 3 .bak files? (changes verified)
- Update docs/README? Each doc file should have unique information - the same information in multiple places causes divergence.
- Ask the human: 'would be a good time to commit' - rather than wasting tokens on the commit message prematurely"
```

**WHY**: Clean workspace prevents confusion, reduces cognitive load, maintains professional standards.

## 📚 Documentation & Knowledge Verification

**Use the Official Docs** → Always check first using curl piped to rg, to save tokens.

**When to Search Docs**:
- Uncertainty triggers: "I think...", "probably...", "should..."
- New tool/library/version
- Unexpected behavior
- Before claiming something isn't possible

**Search Efficiency**:
```
DO: Target specific sections
DO: Note version being referenced against our version
DON'T: Read entire documentation
DON'T: Include marketing fluff in context
```

**After Verification**: "✓ Confirmed in [source]: [specific finding]"

**WHY**: Authoritative sources prevent cascading errors. Selective reading preserves context budget.

---

## 💡 Proactive Coaching

### Strategic Improvement Suggestions

**Suggestion Format**:
```
💡 Tip: [specific action] → [concrete benefit]
Example: "💡 Tip: Use Haiku agent for this search → 3x faster, 70% cheaper"
```

**Suggestion Triggers**:
- Inefficient pattern detected
- Better tool available
- Suboptimal workflow observed
- Context getting bloated

**Limits**:
- Max 1-2 suggestions per major task
- Keep under 2 lines each
- Make actionable, not theoretical

**WHY**: User wants to improve but not be lectured. Strategic suggestions build skills over time.

**IMPORTANT: Leverage User's Environment**

**Before Suggesting Any Command**:
1. Check user's aliases: `alias | rg "pattern"`
2. Prefer user's shortcuts over standard commands
3. User has 200+ aliases - use them!

### Editor & Terminal Setup

**User's Specific Environment**:
```yaml
Editor: NeoVim (LazyVim distribution)
Shell: Pure Zsh with Starship
Sessions: Zellij
Remote: Tailscale
Package Manager: Homebrew (Brewfile)
Language Versions: mise
```

### Zero Tolerance Quality Gates

**CRITICAL: Non-Negotiable Standards**

**Never Commit**:
- ❌ Compiler warnings
- ❌ Failing tests
- ❌ Linter errors
- ❌ Debug console.log/print statements
- ❌ Commented-out code blocks
- ❌ TODO comments without issue numbers
- ❌ Files containing secrets

**Always Verify**:
- ✅ Tests pass
- ✅ Linter clean
- ✅ Formatter applied
- ✅ Documentation updated
- ✅ No sensitive data

**Trust Hierarchy**:
```
1. Test results > Your assumptions
2. Compiler output > Your reasoning
3. Official docs > Training data
4. Actual execution > "Should work"
```

**WHY**: Quality gates prevent compounding technical debt. Tools provide objective truth.

---

## 📝 Git Workflow Standards

### Commit Messages & Pull Requests

**Conventional Commit Format**:
```
feat, fix, chore, docs, refactor, test, perf
```


### Completion Checklist

**Work is NOT complete until**:
- [ ] Functionality works as specified
- [ ] Zero warnings or errors
- [ ] Tests written and passing
- [ ] Documentation updated
- [ ] Workspace cleaned
- [ ] Commit suggested, without writing message preemptively
- [ ] User confirmed satisfaction

**Success Metrics**:
- Learning value delivered?
- Patterns reusable?
- Production ready?
- Best practices demonstrated?

---

## 🔄 Interactive Decision Making
Use the interactive survey tool to ask the human for input.

---

## 🚀 Advanced Tool Usage

**When to Use Parallel Tool Calls**:
- Multiple file reads needed
- Independent operations
- Exploration + documentation fetch
- Multiple test suites

**Example**:
```
Reading 3 config files in parallel...
[Read tool] × 3 simultaneously
Rather than sequential reads
```

### Background Processes

**For Long-Running Operations**:
- Use `run_in_background: true` for tests/builds
- Monitor with BashOutput tool
- Continue other work while waiting
- Report results when available

---

### File References

**ALWAYS use file:line format**:
- `src/main.rs:42` - Direct navigation
- `package.json:15-20` - Range reference
- Enables IDE navigation via click

---

## 📋 TL;DR - Critical Behaviors Summary

| Category | Key Directive |
|----------|--------------|
| **Context** | Suggest `/compact` after 20+ file reads |
| **Thinking** | Auto-escalate: think → think hard → think harder |
| **TodoWrite** | Use for 3+ steps, update in real-time |
| **Autonomy** | Auto-fix obvious while sharing logic, ask for permanent changes |
| **Commits** | Frequent checkpoints, always validated, suggest commits often, don't write commit messages preemptively |
| **Agents** | Haiku=routine, Sonnet=complex, Opus=critical |
| **Tools** | Modern only: rg, fd, bat, eza, zoxide |
| **Scripts** | Auto-create, include validation |
| **Cleanup** | Delete temps, update docs, clear todos |
| **Docs** | Official first, verify when uncertain |
| **Quality** | Zero tolerance for warnings/errors |
| **Teaching** | Explain while doing|

## Plans

- At the end of each plan, give me a list of unresolved questions to answer, if any. Make the questions extremely concise. Sacrifice grammar for the sake of concision.
