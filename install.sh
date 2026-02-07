#!/usr/bin/env bash
set -euo pipefail

# north-starr installer
# Usage: curl -fsSL https://raw.githubusercontent.com/selcukyucel/north-starr/main/install.sh | bash

REPO="selcukyucel/north-starr"
INSTALL_DIR="$HOME/.north-starr"
BIN_DIR="$HOME/.local/bin"

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

echo ""
echo -e "${CYAN}    ★ ${BOLD}north-starr installer${NC}"
echo -e "${DIM}    Your North Star for Friction-Free Development${NC}"
echo ""

# Check for git
if ! command -v git &>/dev/null; then
  echo -e "${RED}  ✗${NC} git is required. Please install git first."
  exit 1
fi

# Clone or update
if [[ -d "$INSTALL_DIR" ]]; then
  echo -e "${GREEN}  ✓${NC} Updating existing installation..."
  cd "$INSTALL_DIR"
  git pull --quiet origin main
else
  echo -e "${GREEN}  ✓${NC} Cloning north-starr..."
  git clone --quiet "https://github.com/$REPO.git" "$INSTALL_DIR"
fi

# Make CLI executable
chmod +x "$INSTALL_DIR/bin/north-starr"

# Create bin directory and symlink
mkdir -p "$BIN_DIR"
ln -sf "$INSTALL_DIR/bin/north-starr" "$BIN_DIR/north-starr"

echo -e "${GREEN}  ✓${NC} Installed to $INSTALL_DIR"
echo -e "${GREEN}  ✓${NC} Linked to $BIN_DIR/north-starr"

# Check if BIN_DIR is in PATH
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
  echo ""
  echo -e "  ${BOLD}Add to your PATH:${NC}"

  shell_name="$(basename "$SHELL")"
  case "$shell_name" in
    zsh)
      echo -e "    echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.zshrc"
      echo -e "    source ~/.zshrc"
      ;;
    bash)
      echo -e "    echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc"
      echo -e "    source ~/.bashrc"
      ;;
    *)
      echo -e "    export PATH=\"\$HOME/.local/bin:\$PATH\""
      ;;
  esac
fi

echo ""
echo -e "${GREEN}${BOLD}  Done!${NC}"
echo ""
echo -e "  ${BOLD}Quick start:${NC}"
echo -e "    ${DIM}cd your-project${NC}"
echo -e "    ${DIM}north-starr init${NC}"
echo ""
echo -e "  ${DIM}https://github.com/$REPO${NC}"
echo ""
