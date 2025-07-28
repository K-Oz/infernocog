#!/bin/bash
# Installation script for InfernoCog via GNU Guix

set -e

echo "Installing InfernoCog (Inferno OS) via GNU Guix..."

# Check if guix is available
if ! command -v guix &> /dev/null; then
    echo "Error: GNU Guix is not installed or not in PATH."
    echo "Please install GNU Guix from https://guix.gnu.org/"
    exit 1
fi

# Install the package using the local guix.scm file
echo "Installing from local guix.scm file..."
guix install -f guix.scm

echo "Installation complete!"
echo ""
echo "InfernoCog has been installed as 'opencog'."
echo "You can now use the following commands:"
echo "  mk       - The Inferno make tool"
echo "  iyacc    - Inferno yacc parser generator"
echo ""
echo "Libraries installed in your Guix profile under lib/"
echo "Headers installed in your Guix profile under include/"
echo ""
echo "For more information, see the documentation in:"
echo "  ~/.guix-profile/share/doc/opencog/"