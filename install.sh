#!/bin/bash

#################################################################################
# install.sh - Installer for create-project CLI
#
# Installation options:
# 1. curl -sSL https://raw.githubusercontent.com/wyliethomas/skeletons/master/install.sh | bash
# 2. wget -qO- https://raw.githubusercontent.com/wyliethomas/skeletons/master/install.sh | bash
# 3. git clone https://github.com/wyliethomas/skeletons.git && cd skeletons && ./install.sh
#################################################################################

set -e

# Colors
BOLD="\033[1m"
RESET="\033[0m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
CYAN="\033[36m"

# Configuration
REPO_URL="https://github.com/wyliethomas/skeletons"
RAW_URL="https://raw.githubusercontent.com/wyliethomas/skeletons/master"
INSTALL_DIR="$HOME/.local/bin"
TEMPLATES_DIR="$HOME/.local/share/project-skeletons"

print_banner() {
    echo ""
    echo -e "${CYAN}${BOLD}"
    cat << "EOF"
 ██████╗ ██████╗ ██████╗ ███████╗
██╔════╝██╔═══██╗██╔══██╗██╔════╝
██║     ██║   ██║██║  ██║█████╗
██║     ██║   ██║██║  ██║██╔══╝
╚██████╗╚██████╔╝██████╔╝███████╗
 ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝

████████╗███████╗███╗   ███╗██████╗ ██╗      █████╗ ████████╗███████╗███████╗
╚══██╔══╝██╔════╝████╗ ████║██╔══██╗██║     ██╔══██╗╚══██╔══╝██╔════╝██╔════╝
   ██║   █████╗  ██╔████╔██║██████╔╝██║     ███████║   ██║   █████╗  ███████╗
   ██║   ██╔══╝  ██║╚██╔╝██║██╔═══╝ ██║     ██╔══██║   ██║   ██╔══╝  ╚════██║
   ██║   ███████╗██║ ╚═╝ ██║██║     ███████╗██║  ██║   ██║   ███████╗███████║
   ╚═╝   ╚══════╝╚═╝     ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚══════╝
EOF
    echo -e "${RESET}"
    echo ""
    echo "  Installer - Fast, opinionated templates for modern projects"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓ $1${RESET}"
}

print_error() {
    echo -e "${RED}✗ Error: $1${RESET}" >&2
}

print_info() {
    echo -e "${BLUE}ℹ $1${RESET}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${RESET}"
}

check_dependencies() {
    print_info "Checking dependencies..."

    local missing_deps=()

    if ! command -v git &> /dev/null; then
        missing_deps+=("git")
    fi

    if ! command -v curl &> /dev/null; then
        missing_deps+=("curl")
    fi

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        echo ""
        echo "Please install them first:"
        echo "  • Debian/Ubuntu: sudo apt-get install ${missing_deps[*]}"
        echo "  • macOS: brew install ${missing_deps[*]}"
        echo "  • Fedora: sudo dnf install ${missing_deps[*]}"
        echo "  • Arch: sudo pacman -S ${missing_deps[*]}"
        exit 1
    fi

    print_success "All dependencies found"
}

create_directories() {
    print_info "Creating installation directories..."

    # Create bin directory
    if [[ ! -d "$INSTALL_DIR" ]]; then
        mkdir -p "$INSTALL_DIR"
        print_success "Created $INSTALL_DIR"
    fi

    # Create templates directory
    if [[ ! -d "$TEMPLATES_DIR" ]]; then
        mkdir -p "$TEMPLATES_DIR"
        print_success "Created $TEMPLATES_DIR"
    fi
}

install_cli() {
    print_info "Installing create-project CLI..."

    # Download the main script
    if curl -sSL "$RAW_URL/create-project" -o "$INSTALL_DIR/create-project"; then
        chmod +x "$INSTALL_DIR/create-project"
        print_success "CLI installed to $INSTALL_DIR/create-project"
    else
        print_error "Failed to download create-project script"
        exit 1
    fi
}

install_templates() {
    print_info "Installing project templates..."

    # Clone or update templates
    if [[ -d "$TEMPLATES_DIR/.git" ]]; then
        print_info "Updating existing templates..."
        (cd "$TEMPLATES_DIR" && GIT_TERMINAL_PROMPT=0 git pull -q)
        print_success "Templates updated"
    else
        print_info "Cloning templates repository..."
        rm -rf "$TEMPLATES_DIR"

        # Disable interactive git prompts for public repo
        # This prevents authentication prompts since the repo is public
        if GIT_TERMINAL_PROMPT=0 git clone -q "$REPO_URL" "$TEMPLATES_DIR" 2>/dev/null; then
            print_success "Templates cloned"
        else
            print_error "Failed to clone templates repository"
            echo ""
            print_info "This usually happens if:"
            echo "  1. The repository is not public"
            echo "  2. Network connectivity issues"
            echo "  3. Git configuration issues"
            echo ""
            print_info "You can manually clone instead:"
            echo -e "  ${CYAN}git clone $REPO_URL $TEMPLATES_DIR${RESET}"
            exit 1
        fi
    fi
}

update_path() {
    # Check if INSTALL_DIR is in PATH
    if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
        print_warning "$INSTALL_DIR is not in your PATH"
        echo ""
        print_info "Add this to your shell profile (~/.bashrc, ~/.zshrc, etc.):"
        echo ""
        echo -e "  ${CYAN}export PATH=\"\$HOME/.local/bin:\$PATH\"${RESET}"
        echo ""
        print_info "Then reload your shell:"
        echo ""
        echo -e "  ${CYAN}source ~/.bashrc${RESET}  # or ~/.zshrc"
        echo ""
    else
        print_success "$INSTALL_DIR is already in your PATH"
    fi
}

create_symlink() {
    # Create symlink in templates directory to make templates accessible
    if [[ ! -L "$TEMPLATES_DIR/create-project" ]]; then
        ln -sf "$INSTALL_DIR/create-project" "$TEMPLATES_DIR/create-project"
    fi
}

print_completion() {
    echo ""
    echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${BOLD}${GREEN}  🎉  Installation complete!${RESET}"
    echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
    echo -e "${BOLD}📍 Installation locations:${RESET}"
    echo "  • CLI:       $INSTALL_DIR/create-project"
    echo "  • Templates: $TEMPLATES_DIR"
    echo ""
    echo -e "${BOLD}🚀 Getting started:${RESET}"
    echo ""

    if [[ ":$PATH:" == *":$INSTALL_DIR:"* ]]; then
        echo -e "  ${CYAN}create-project${RESET}  # Run from anywhere!"
    else
        echo -e "  ${CYAN}$INSTALL_DIR/create-project${RESET}  # Or add to PATH (see warning above)"
    fi

    echo ""
    echo -e "${BOLD}📚 Available templates:${RESET}"
    echo "  • rails-api         - Rails 7 API with JWT, Docker, Redis"
    echo "  • react-app         - Vite + React + TypeScript + Tailwind"
    echo "  • go-microservice   - Go service with Chi router"
    echo ""
    echo -e "${BOLD}🔄 Update templates:${RESET}"
    echo -e "  ${CYAN}cd $TEMPLATES_DIR && git pull${RESET}"
    echo ""
    echo -e "${BOLD}Happy coding! 🎊${RESET}"
    echo ""
}

main() {
    print_banner

    # Check if running with sudo (not recommended)
    if [[ $EUID -eq 0 ]]; then
        print_error "Please don't run this installer with sudo"
        print_info "It will install to your home directory (~/.local/bin)"
        exit 1
    fi

    check_dependencies
    create_directories
    install_templates
    install_cli
    create_symlink
    update_path
    print_completion
}

main "$@"
