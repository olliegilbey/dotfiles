#!/usr/bin/env bash

# Strict error handling
set -e          # Exit on any error
set -u          # Exit on undefined variables
set -o pipefail # Exit on pipe failures

# Script validation and setup
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SRC_DIR="$SCRIPT_DIR/src"
readonly TRASH_DIR="$SCRIPT_DIR/trash"
readonly HOME_DIR="$HOME"

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}" >&2
}

# Validation functions
validate_environment() {
    log_info "Validating environment..."
    
    # Check if we're in the right directory
    if [[ ! -d "$SRC_DIR" ]]; then
        log_error "Source directory not found: $SRC_DIR"
        log_error "Please run this script from the dotfiles directory"
        exit 1
    fi
    
    # Check if HOME is set
    if [[ -z "${HOME:-}" ]]; then
        log_error "HOME environment variable is not set"
        exit 1
    fi
    
    # Check if we have write permissions to HOME
    if [[ ! -w "$HOME_DIR" ]]; then
        log_error "No write permission to home directory: $HOME_DIR"
        exit 1
    fi
    
    log_success "Environment validation passed"
}

# Create trash directory safely
setup_trash_dir() {
    log_info "Setting up trash directory..."
    
    if [[ -d "$TRASH_DIR" ]]; then
        log_warning "Existing trash directory found, archiving with timestamp"
        mv "$TRASH_DIR" "${TRASH_DIR}.$(date +%Y%m%d_%H%M%S)" || {
            log_error "Failed to archive existing trash directory"
            exit 1
        }
    fi
    
    mkdir -p "$TRASH_DIR" || {
        log_error "Failed to create trash directory: $TRASH_DIR"
        exit 1
    }
    
    log_success "Trash directory ready: $TRASH_DIR"
}

# Symlink creation with validation
create_symlink() {
    local src_file="$1"
    local target_file="$HOME_DIR/$src_file"
    local source_path="$SRC_DIR/$src_file"
    
    # Validate source file exists
    if [[ ! -e "$source_path" ]]; then
        log_error "Source file does not exist: $source_path"
        return 1
    fi
    
    # Skip if target is already correctly symlinked
    if [[ -L "$target_file" ]] && [[ "$(readlink "$target_file")" == "$source_path" ]]; then
        log_success "~/$src_file already correctly symlinked"
        return 0
    fi
    
    # Backup existing file/directory if it exists
    if [[ -e "$target_file" ]]; then
        log_warning "Backing up existing ~/$src_file"
        mv "$target_file" "$TRASH_DIR/$src_file" || {
            log_error "Failed to backup ~/$src_file"
            return 1
        }
    fi
    
    # Create the symlink
    log_info "Creating symlink ~/$src_file -> $source_path"
    ln -s "$source_path" "$target_file" || {
        log_error "Failed to create symlink for ~/$src_file"
        return 1
    }
    
    log_success "Successfully linked ~/$src_file"
    return 0
}

# Main execution
main() {
    log_info "🔗 Starting dotfiles bootstrap process..."
    
    validate_environment
    setup_trash_dir
    
    log_info "Creating dotfiles symlinks..."
    
    local failed_links=0
    local total_links=0
    
    # Process each file in src directory
    while IFS= read -r -d '' file; do
        local basename_file="$(basename "$file")"
        ((total_links++))
        
        if ! create_symlink "$basename_file"; then
            ((failed_links++))
            log_error "Failed to process: $basename_file"
        fi
    done < <(find "$SRC_DIR" -maxdepth 1 -type f -print0)
    
    # Process each directory in src directory
    while IFS= read -r -d '' dir; do
        local basename_dir="$(basename "$dir")"
        ((total_links++))
        
        if ! create_symlink "$basename_dir"; then
            ((failed_links++))
            log_error "Failed to process: $basename_dir"
        fi
    done < <(find "$SRC_DIR" -maxdepth 1 -type d -not -path "$SRC_DIR" -print0)
    
    # Summary
    log_info "Bootstrap summary:"
    log_info "  Total items processed: $total_links"
    log_info "  Successful links: $((total_links - failed_links))"
    
    if [[ $failed_links -eq 0 ]]; then
        log_success "✨ Bootstrap completed successfully!"
        exit 0
    else
        log_warning "Bootstrap completed with $failed_links failures"
        log_warning "Check the error messages above for details"
        exit 1
    fi
}

# Run main function
main "$@"
