#!/usr/bin/env bash

# This script installs command-line tools using Homebrew.
echo "Starting the installation process..."

echo "Requesting administrative privileges..."
# Request the user's password at the start of the script
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do
	sudo -n true
	sleep 60
	kill -0 "$$" || exit
done 2>/dev/null &

echo "Updating Homebrew..."
# Ensure we’re using the latest version of Homebrew
brew update

echo "Upgrading any already-installed formulae..."
# Upgrade any already-installed formulae to their latest version
brew upgrade

# Install Zsh via Homebrew
if command -v zsh &>/dev/null; then
	echo "Zsh is already installed."
else
	echo "Installing Zsh..."
	brew install zsh
fi

# The following tools are commonly used across both MacOS and Linux environments
echo "Installing commonly used tools..."
# Bash is a shell that interprets commands. Upgrading for newer features and enhancements.
brew install bash
# Autocompletion script for bash. Helps in auto-completing commands and filenames.
brew install bash-completion
# GitHub CLI, allows you to interact with GitHub from the command line.
brew install gh
# Distributed version control system to track changes in source code.
brew install git
brew install lazygit
# Useful git extensions that make some common Git tasks easier to perform.
brew install git-extras
# The Go programming language
brew install go
# File and directory search tool
brew install findutils
# Image manipulation utilities. Useful for converting and resizing images.
brew install imagemagick
# Lightweight, high-performance programming language.
brew install lua
# Neovim is a text editor. A modern enhancement from Vim.
brew install neovim
# Network exploration tool and security scanner.
brew install nmap
# Recursive line-oriented search tool. Extremely fast and powerful.
brew install ripgrep
# language server for rust
brew install rust-analyzer
# Minimalistic command line shell prompt.
brew install starship
# Recursive directory listing command. Helps in getting an overview of a directory tree.
brew install tree
# A highly configurable and robust text editor.
brew install vim
# Network utility to retrieve files from the web.
brew install wget
# Finds files, used by LazyVim, alternative to find. But faster and written in Rust.
brew install fd
# zoxide to change cd command to the more powerful one https://www.youtube.com/watch?v=aghxkpyRVDY
brew install zoxide
# fuzzy finder to work with zoxide based on above video
brew install fzf

# Conditionally install tools based on the operating system
case "$OSTYPE" in
linux-gnu*)
	# Linux specific installations
	echo "Linux environment detected. Installing Linux-specific tools..."
	# Clipboard utility for accessing the clipboard in terminal
	brew install xclip
	;;
darwin*)
	# MacOS specific installations
	echo "MacOS environment detected. Installing MacOS-specific tools..."
	# pbcopy and pbpaste are pre-installed on MacOS for clipboard interaction
	# Install GNU core utilities (those that come with OS X are outdated).
	brew install coreutils
	# Link sha256sum for compatibility
	sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum
	# Platform for developing, shipping, and running applications in containers.
	brew install docker
	;;
*)
	echo "Unsupported OS type: $OSTYPE"
	;;
esac

echo "Cleaning up outdated versions from Homebrew..."
# Clean up outdated versions from the Homebrew cellar
brew cleanup
echo "Installation complete!"
