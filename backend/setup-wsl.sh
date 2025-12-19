#!/bin/bash
# Setup script for WSL environment

echo "Setting up WSL environment for MindMate..."

# Update apt
sudo apt update

# Install Python venv
sudo apt install -y python3.12-venv python3-full

# Navigate to backend directory
cd "$(dirname "$0")"

# Create virtual environment
echo "Creating virtual environment..."
python3 -m venv venv

# Activate and install requirements
echo "Installing Python packages..."
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

echo "Setup complete!"
echo ""
echo "To use this environment, run:"
echo "  cd backend"
echo "  source venv/bin/activate"
echo "  jac serve app.jac"
