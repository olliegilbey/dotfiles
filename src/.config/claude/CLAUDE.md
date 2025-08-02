# Ollie's Global Development Environment & AI Collaboration Style

## Personal Development Philosophy

### Core Principles
- **Craft over Speed**: Build things properly the first time, with attention to architecture and long-term maintainability
- **Teaching-First Code**: Write code that teaches patterns and demonstrates best practices
- **Incremental Excellence**: Start simple, add sophistication thoughtfully
- **Learning Projects First**: Real-world utility second - prioritize understanding and skill development

### Technical Values
- **Modern Tooling**: Always use bleeding-edge, stable versions of tools and dependencies
- **Zero Warnings Policy**: Clean code with no compiler warnings, lints, or technical debt
- **Comprehensive Testing**: Tests as specification and AI guardrails against context drift
- **Beautiful Interfaces**: Whether CLI, web, or API - prioritize excellent user experience

## Technical Environment & Preferences

### Primary Tools & Environment
- **Terminal-First Workflow**: NeoVim with LazyVim distribution, terminal-based development
- **macOS Development**: Darwin 24.5.0 with Brewfile-managed package system
- **Shell Environment**: Zsh with Oh My Zsh, Warp terminal (native prompting, no starship)
- **Editor**: NeoVim as primary editor (`$EDITOR="nvim"`), LazyVim with modern plugins
- **Git SSH Authentication**: 1Password integration with commit signing, delta for enhanced diffs
- **Navigation**: Enhanced with `zoxide` (replaces cd), `fzf` (fuzzy finder), `ripgrep` (fast search)

### Dotfiles Architecture
- **Symlinked Configuration**: All dotfiles managed via `/Users/olivergilbey/dotfiles/bootstrap.sh`
- **Configuration Location**: `~/dotfiles/src/` contains all config files, symlinked to home directory
- **Automated Setup**: Complete environment bootstrap with `init.sh`, `brew.sh`, `language_installs.sh`
- **Version Control**: Git-managed dotfiles with backup system during setup

### Language Preferences & Patterns
- **Rust**: Primary language - leverage zero-cost abstractions, type-driven design, functional composition (managed via rustup)
- **Go**: Secondary systems language - latest version via mise, clean GOPATH configuration
- **TypeScript/JavaScript**: For web development - bun runtime, Node.js LTS via mise, modern ES features
- **Python**: For data/ML work - uv for package/project management, latest version via mise, clean typing
- **Shell/Bash**: For automation and tooling - enhanced with modern alternatives (eza, bat, ripgrep, fd, delta)

### Development Tools Ecosystem
- **Version Control**: Git with git-extras, lazygit for TUI interface, delta for enhanced diffs
- **Search & Navigation**: ripgrep (rg), fd (find alternative), fzf (fuzzy finder), eza (modern ls)
- **Language Tooling**: rust-analyzer (Rust LSP), Node.js via mise, Go toolchain, comprehensive NeoVim LSP setup
- **Container Development**: Docker with docker-compose support
- **Package Managers**: Brewfile (declarative system), Cargo (Rust), mise (universal), bun (JavaScript), uv (Python)
- **Terminal Enhancement**: Warp native prompting, zoxide (smart cd), alias tips system, health checking

### Zsh Configuration Details
- **Plugin Ecosystem**: nvm, node, golang, rust, git-extras, macos, yarn, docker, vi-mode  
- **Enhanced Completions**: zsh-completions, zsh-autosuggestions, zsh-syntax-highlighting
- **Workflow Tools**: wd (warp directory), colorize, history, compleat
- **Vi Mode**: Terminal editing with vim keybindings enabled

### NeoVim Configuration
- **Distribution**: LazyVim - modern Neovim configuration with sensible defaults
- **Plugin Management**: lazy.nvim for efficient plugin loading and configuration
- **Language Support**: Integrated language servers, completion, and debugging
- **File Navigation**: Enhanced with telescope, tree-sitter, and modern navigation plugins

### Code Style Standards
- **Language-Specific Formatting**: Use standard formatters (rustfmt, prettier, black)
- **Explicit Error Handling**: Avoid unwrap() and similar panic-prone patterns
- **Descriptive Naming**: Clear variable and function names over brevity
- **Comprehensive Documentation**: Examples, reasoning, and context in code comments
- **Import Organization**: Standard groupings (std, external, internal)

### Custom Aliases & Shortcuts
- **Navigation**: `..`, `...`, `....`, `.....` for directory traversal, `ll` (enhanced ls with git status), `lt` (tree view)
- **Development**: `dev` (jump to code directory), `dots` (jump to dotfiles), `lg` (lazygit), `env-info` (environment summary)
- **Search**: `search` (smart ripgrep), `searchcode` (code files only), `recent` (files modified today)
- **Git Integration**: `g` alias for git, `git-summary` (repository overview), extensive git-extras functionality
- **System Utilities**: `timer` (stopwatch), `ip`/`localip` (addresses), `chromekill`, `flushDNS`, `afk` (lock screen)
- **AI Context**: `proj-context` (project overview), `dotfiles-health` (environment validation)
- **Modern Tools**: `cat` → `bat` (syntax highlighting), `ls` → `eza` (icons/git status)
- **Claude Code Access**: `claude` alias pointing to `/Users/olivergilbey/.claude/local/claude`
- **Alias Tips**: Random startup reminders from `alias-descriptions.txt` (2 tips per session)

## AI Collaboration Guidelines

### Claude Code Usage Patterns
- **Proactive Tool Usage**: Use TodoWrite, Task agents, and specialized tools frequently
- **Direct Communication**: Concise responses (under 4 lines unless detail requested)
- **No Unnecessary Preamble**: Get straight to the point, avoid "Here's what I'll do" explanations
- **Show, Don't Tell**: Demonstrate with code rather than explaining in prose
- **Modern Tooling**: Leverage bun over npm, eza over ls, bat over cat, delta for git diffs

### Task Management & Planning
- **TodoWrite Usage**: Always use for multi-step tasks and project organization
- **Real-Time Updates**: Mark tasks complete immediately, don't batch updates
- **Comprehensive Planning**: Break complex tasks into manageable, trackable steps
- **Context Preservation**: Maintain task context across sessions

### Problem-Solving Approach
- **Understand First**: Read existing code, understand patterns before making changes
- **Follow Conventions**: Mimic existing code style, use project's libraries and patterns
- **Test-Driven Development**: Write tests frequently, use as guardrails for AI agents
- **Iterative Refinement**: Start working, refine based on results

## Project Management Philosophy

### Starting New Projects
- **Architecture First**: Spend time on proper project structure and dependencies
- **Documentation Driven**: README and architecture docs before significant coding  
- **Testing Strategy**: Establish testing patterns early, use as development guardrails
- **Dependency Hygiene**: Bleeding-edge stable versions, avoid dependency bloat
- **Python Projects**: Use `uv init` for new projects, `uv add` for dependencies, `uv run` for execution

### Collaboration with AI
- **Memory Management**: Maintain comprehensive project documentation for context
- **Nested Documentation**: Use project-specific CLAUDE.md files for complex projects
- **Clear Requirements**: Specific, actionable tasks rather than vague requests
- **Quality Gates**: Code must pass formatting, linting, and testing before acceptance

### Code Review Standards
- **Zero Tolerance**: No warnings, no dead code, no unaddressed comments in committed code
- **Pattern Consistency**: Follow established patterns within the codebase
- **Performance Awareness**: Consider performance implications, but prioritize clarity
- **Security Conscious**: Never commit secrets, follow security best practices

## Communication Preferences

### Response Style
- **Concise and Direct**: Get to the point quickly, avoid unnecessary elaboration
- **Show Results**: Code examples and working solutions over explanations
- **Professional Tone**: Friendly but focused, avoid excessive emojis unless requested
- **Problem-Solving Focus**: Address the specific issue at hand

### Information Density
- **High Signal-to-Noise**: Maximize useful information per response
- **Structured Output**: Use formatting, lists, and headers for clarity
- **Context Aware**: Reference previous work and maintain conversation continuity
- **Actionable Content**: Every response should move the work forward

## Learning & Development Goals

### Continuous Improvement
- **Stay Current**: Keep up with latest developments in chosen technologies
- **Deep Understanding**: Prefer understanding patterns over memorizing syntax
- **Cross-Pollination**: Apply patterns from one domain to improve others
- **Teaching Others**: Explain concepts clearly, write self-documenting code

### Technical Growth Areas
- **Systems Programming**: Low-level understanding to inform high-level decisions
- **Distributed Systems**: Scalability, reliability, and performance patterns
- **Developer Experience**: Tools, workflows, and processes that enhance productivity
- **AI Integration**: Effective collaboration patterns with AI development tools

## Project Success Metrics

### Definition of Done
- **Functionality**: Works as specified with proper error handling
- **Quality**: Zero warnings, comprehensive tests, clean formatting
- **Documentation**: Clear README, architecture docs, code comments
- **Maintainability**: Future developers (including AI) can understand and extend

### Long-term Value
- **Learning Achieved**: Did the project teach new patterns or concepts?
- **Reusable Patterns**: Can components/approaches be applied elsewhere?
- **Production Ready**: Could this be deployed and used by others?
- **Educational Value**: Does the code demonstrate best practices?

---

## Dynamic Environment Context

### Dotfiles Reference
For the most current development environment configuration, Claude Code should reference:
- **Dotfiles Location**: `/Users/olivergilbey/dotfiles/src/` (symlinked to home directory)
- **Shell Configuration**: `~/.zshrc` for current aliases, paths, and environment variables
- **Aliases**: `~/.aliases` for navigation shortcuts and development utilities
- **NeoVim Config**: `~/.config/nvim/` for current editor plugins and keybindings
- **Tool Versions**: Check `~/.zshrc` for current Node.js (mise), Go, Rust, and other toolchain versions

### Environment Discovery Commands
When working on projects, Claude Code can check:
```bash
# Environment overview
dotfiles-health
env-info
proj-context

# Current tool versions
cargo --version
go version
node --version
nvim --version
mise --version
bun --version

# Available aliases and functions
alias | grep -E "(dev|git|search|proj)"
grep -E "^(alias|function)" ~/.aliases

# Project and git context
git-summary
ls -la | head -10
```

---

*This global configuration helps Claude Code understand Ollie's development style, preferences, and collaboration patterns across all projects. Project-specific CLAUDE.md files should extend these principles with domain-specific context.*

*For real-time environment details, Claude Code should reference the dotfiles at `/Users/olivergilbey/dotfiles/src/` to understand current tool versions, aliases, and configuration preferences.*