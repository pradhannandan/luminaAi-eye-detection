#!/bin/bash

# Check if Python 3.9 is available
if ! command -v python3.9 &> /dev/null; then
    echo "ERROR: Python 3.9 is not installed or not in PATH"
    echo "Please install Python 3.9 and try again"
    echo "On Ubuntu/Debian: sudo apt install python3.9 python3.9-venv"
    echo "On macOS: brew install python@3.9"
    exit 1
fi

# Create virtual environment with Python 3.9 if it doesn't exist
if [ ! -d "venv" ]; then
    python3.9 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Upgrade pip first
pip install --upgrade pip

# Install setuptools and wheel first
pip install setuptools wheel

# Install requirements
pip install -r requirements.txt

# Deactivate virtual environment
deactivate 