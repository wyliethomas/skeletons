#!/bin/bash

#################################################################################
# uninstall.sh - Uninstaller for create-project CLI
#
# Uninstallation options:
# 1. curl -sSL https://raw.githubusercontent.com/wyliethomas/skeletons/master/uninstall.sh | bash
# 2. wget -qO- https://raw.githubusercontent.com/wyliethomas/skeletons/master/uninstall.sh | bash
# 3. ./uninstall.sh
# 4. ./uninstall.sh --force  (skip confirmation)
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
INSTALL_DIR="$HOME/.local/bin"
TEMPLATES_DIR="$HOME/.local/share/project-skeletons"
CLI_PATH="$INSTALL_DIR/create-project"

# Parse arguments
FORCE=false
if [[ "$1" == "--force" ]] || [[ "$1" == "-f" ]]; then
    FORCE=true
fi

print_banner() {
    echo ""
    echo -e "${RED}${BOLD}"
    cat << "EOF"

.▄▄ · ▄ •▄ ▄▄▄ .▄▄▌  ▄▄▄ .▄▄▄▄▄       ▐ ▄ .▄▄ ·
▐█ ▀. █▌▄▌▪▀▄.▀·██•  ▀▄.▀·•██  ▪     •█▌▐█▐█ ▀.
▄▀▀▀█▄▐▀▀▄·▐▀▀▪▄██▪  ▐▀▀▪▄ ▐█.▪ ▄█▀▄ ▐█▐▐▌▄▀▀▀█▄
▐█▄▪▐█▐█.█▌▐█▄▄▌▐█▌▐▌▐█▄▄▌ ▐█▌·▐█▌.▐▌██▐█▌▐█▄▪▐█
 ▀▀▀▀ ·▀  ▀ ▀▀▀ .▀▀▀  ▀▀▀  ▀▀▀  ▀█▄▀▪▀▀ █▪ ▀▀▀▀

EOF
    echo -e "${RESET}"
    echo ""
    echo -e "  ${RED}Uninstaller${RESET}"
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

check_installation() {
    local found_items=()
    local missing_items=()

    if [[ -f "$CLI_PATH" ]]; then
        found_items+=("CLI: $CLI_PATH")
    else
        missing_items+=("CLI")
    fi

    if [[ -d "$TEMPLATES_DIR" ]]; then
        found_items+=("Templates: $TEMPLATES_DIR")
    else
        missing_items+=("Templates")
    fi

    if [[ ${#found_items[@]} -eq 0 ]]; then
        print_info "No installation found"
        echo ""
        print_info "Searched locations:"
        echo "  • $CLI_PATH"
        echo "  • $TEMPLATES_DIR"
        echo ""
        print_info "Nothing to uninstall!"
        exit 0
    fi

    echo -e "${BOLD}Found installation:${RESET}"
    for item in "${found_items[@]}"; do
        echo "  • $item"
    done

    if [[ ${#missing_items[@]} -gt 0 ]]; then
        echo ""
        print_warning "Not found: ${missing_items[*]}"
    fi

    echo ""
}

confirm_uninstall() {
    if [[ "$FORCE" == true ]]; then
        print_info "Force mode enabled, skipping confirmation"
        return 0
    fi

    echo -e "${BOLD}${YELLOW}This will remove:${RESET}"
    [[ -f "$CLI_PATH" ]] && echo "  • create-project CLI"
    [[ -d "$TEMPLATES_DIR" ]] && echo "  • All project templates"
    echo ""

    read -p "$(echo -e ${BOLD}${RED})Are you sure? (y/N): $(echo -e ${RESET})" -n 1 -r
    echo ""
    echo ""

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Uninstall cancelled"
        exit 0
    fi
}

remove_cli() {
    if [[ -f "$CLI_PATH" ]]; then
        print_info "Removing create-project CLI..."
        rm -f "$CLI_PATH"
        print_success "CLI removed"
    fi
}

remove_templates() {
    if [[ -d "$TEMPLATES_DIR" ]]; then
        print_info "Removing project templates..."
        rm -rf "$TEMPLATES_DIR"
        print_success "Templates removed"
    fi
}

print_completion() {
    echo ""
    echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${BOLD}${GREEN} Uninstall complete!${RESET}"
    echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
    echo -e "${BOLD}Code Skeletons has been removed from your system.${RESET}"
    echo ""
    echo "To reinstall in the future:"
    echo -e "  ${CYAN}curl -sSL https://raw.githubusercontent.com/wyliethomas/skeletons/master/install.sh | bash${RESET}"
    echo ""
    echo "Thank you for using Code Templates! 👋"
    echo ""
}

main() {
    print_banner
    check_installation
    confirm_uninstall
    remove_cli
    remove_templates
    print_completion
}

main "$@"
