#!/usr/bin/env bash
# SIFRO Installation Script
# Team: AHMED EMAD | MOHAMED NAGY | ABDALLAH NEGEADA | ABDALLAH SALMAN

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  SIFRO - Installation Script${NC}"
echo -e "${GREEN}========================================${NC}"

# Check for Python 3
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Error: Python 3 is not installed.${NC}"
    echo "Please install Python 3.6 or higher and try again."
    exit 1
fi

PYTHON_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
echo -e "${GREEN}Found Python ${PYTHON_VERSION}${NC}"

# Check for pip
if ! command -v pip3 &> /dev/null; then
    echo -e "${YELLOW}pip3 not found. Trying to install...${NC}"
    python3 -m ensurepip --upgrade || {
        echo -e "${RED}Failed to install pip. Please install pip manually.${NC}"
        exit 1
    }
fi

# Install pyperclip (optional but recommended)
echo -e "\n${GREEN}Installing optional dependency 'pyperclip' for clipboard support...${NC}"
pip3 install pyperclip --quiet || {
    echo -e "${YELLOW}Warning: Could not install pyperclip. Clipboard functionality will not work.${NC}"
}

# Determine installation directories
PRIMARY_DIR="/usr/local/bin"
SECONDARY_DIR="/usr/bin"
SCRIPT_NAME="sifro"
SOURCE_FILE="sifro"

if [ ! -f "$SOURCE_FILE" ]; then
    echo -e "${RED}Error: $SOURCE_FILE not found in current directory.${NC}"
    echo "Please run this script from the directory containing the sifro script."
    exit 1
fi

# Install to primary location (/usr/local/bin)
echo -e "\n${GREEN}Installing SIFRO to $PRIMARY_DIR/$SCRIPT_NAME...${NC}"
sudo cp "$SOURCE_FILE" "$PRIMARY_DIR/$SCRIPT_NAME"
sudo chmod +x "$PRIMARY_DIR/$SCRIPT_NAME"

# Create symlink in /usr/bin so sudo can find it
echo -e "${GREEN}Creating symlink in $SECONDARY_DIR/$SCRIPT_NAME...${NC}"
sudo ln -sf "$PRIMARY_DIR/$SCRIPT_NAME" "$SECONDARY_DIR/$SCRIPT_NAME"

# Verify installation (normal user)
if command -v sifro &> /dev/null; then
    echo -e "\n${GREEN}✅ SIFRO installed successfully!${NC}"
    echo -e "You can now run it by typing: ${YELLOW}sifro${NC}"
else
    echo -e "\n${YELLOW}Installation completed, but 'sifro' command may not be in your PATH.${NC}"
    echo "You can run it with: $PRIMARY_DIR/$SCRIPT_NAME"
    echo "Or add $PRIMARY_DIR to your PATH if not already."
fi

# Verify sudo access
if sudo -n true 2>/dev/null; then
    if sudo command -v sifro &> /dev/null; then
        echo -e "${GREEN}✅ 'sudo sifro' will also work.${NC}"
    else
        echo -e "${YELLOW}⚠️  'sudo sifro' might still not work. Try: sudo /usr/bin/sifro${NC}"
    fi
else
    echo -e "${YELLOW}Note: If you need 'sudo sifro', ensure /usr/bin is in sudo's secure_path.${NC}"
fi

echo -e "\n${GREEN}Thank you for installing SIFRO!${NC}"
echo -e "Stay secure! 🔐"
