# 🛠️ Ollie's Modern Development Environment

> **Sensible defaults for productive development** - A modern take on dotfiles with bleeding-edge tooling

## About

This repository contains my personal development environment configuration, inspired by [Mathias Bynens' legendary dotfiles](https://github.com/mathiasbynens/dotfiles) - the OG of sensible macOS defaults. Built on that foundational philosophy, this has become my own take on productive development environments.

**Key Features:**
- 🛠️ **Modern Toolchain**: Bleeding-edge development tools and package managers
- 🤖 **AI-Ready**: Integrated settings for modern AI development workflows  
- ⚡ **Performance Optimized**: Latest stable versions with speed improvements
- 📦 **Complete Setup**: One-command installation for new machines
- 🔄 **Cross-Platform Ready**: Portable configuration that travels with you

## Quick Start

### Complete Environment Setup

Clone the repository and run the main setup script:

```bash
cd ~
git clone git@github.com:olliegilbey/dotfiles.git .dotfiles
cd .dotfiles
```

```bash
./init.sh
```

### Script Structure

- **`init.sh`** - Main setup script (runs bootstrap + installs everything)
- **`bootstrap.sh`** - Creates symlinks from `src/` to your home directory  
- **`brew.sh`** - Installs Homebrew packages and tools
- **`language_installs.sh`** - Sets up programming language toolchains

### Updates

To update your dotfiles after making changes:

```bash
./bootstrap.sh
```

For a complete refresh (new tools, etc.):

```bash
./init.sh
```


### Install Dependencies
```bash
# Download oh-my-zsh (It will update itself)
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

# Download Dein Plugin Manager (It will manage itself)
git clone https://github.com/Shougo/dein.vim ~/.vim/bundle/repos/github.com/Shougo/dein.vim
```

### Install Font
Find your font at https://github.com/ryanoasis/nerd-fonts and download

### Add custom commands without creating a new fork

If `~/.extra` exists, it will be sourced along with the other files. You can use this to add a few custom commands without the need to fork this entire repository, or to add commands you don’t want to commit to a public repository.

My `~/.extra` looks something like this:

```bash
# Git credentials
# Not in the repository, to prevent people from accidentally committing under my name
GIT_AUTHOR_NAME="Ollie Gilbey"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
git config --global user.name "$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="<INSERT_EMAIL>"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
git config --global user.email "$GIT_AUTHOR_EMAIL"
```

You could also use `~/.extra` to override settings, functions and aliases from my dotfiles repository. It’s probably better to [fork this repository](https://github.com/olliegilbey/dotfiles/fork) instead, though.


### Install Homebrew formulae

Install [Homebrew](http://brew.sh/) formulae (after installing Homebrew, of course):
```bash
./brew.sh
```
