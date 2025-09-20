@echo off
setlocal enabledelayedexpansion

REM Setup script for blink detector Python environment (Windows)
REM This script creates a virtual environment and installs dependencies

echo Setting up blink detector Python environment...

REM Get the directory of this script
set "SCRIPT_DIR=%~dp0"

REM Check if Python 3.9 is available
python3.9 --version >nul 2>&1 || (
    echo ERROR: Python 3.9 is not installed or not in PATH
    echo.
    echo To install Python 3.9, you have these options:
    echo.
    echo Option 1 - Direct download:
    echo   Download Python 3.9 from: https://www.python.org/downloads/release/python-390/
    echo   Make sure to check "Add Python 3.9 to PATH" during installation
    echo.
    echo Option 2 - Using pyenv-win (recommended for multiple versions):
    echo   1. Install pyenv-win: https://github.com/pyenv-win/pyenv-win
    echo   2. Install Python 3.9: pyenv install 3.9.0
    echo   3. Set local version: pyenv local 3.9.0
    echo.
    echo After installation, run this script again.
    exit /b 1
)

REM Check if virtual environment already exists (from cache)
if exist "%SCRIPT_DIR%venv" (
    echo Virtual environment already exists, checking if it's complete...
    
    REM Activate virtual environment to test
    call "%SCRIPT_DIR%venv\Scripts\activate.bat"
    
    REM Test if key packages are installed
    python -c "import cv2, numpy, dlib, PyInstaller" 2>nul && (
        echo OK: Virtual environment is complete and ready to use
        echo SUCCESS: Setup complete (using cached environment)!
        goto end
    ) || (
        echo Virtual environment exists but packages are missing, reinstalling...
        deactivate
        rmdir /s /q "%SCRIPT_DIR%venv"
    )
)

REM Create virtual environment with Python 3.9
echo Creating virtual environment with Python 3.9...
python3.9 -m venv "%SCRIPT_DIR%venv"

REM Activate virtual environment
echo Activating virtual environment...
call "%SCRIPT_DIR%venv\Scripts\activate.bat"

REM Upgrade pip
echo Upgrading pip...
python -m pip install --upgrade pip

REM Install dependencies
echo Installing dependencies...
pip install -r "%SCRIPT_DIR%requirements.txt"

echo SUCCESS: Setup complete!
echo.
echo Next steps:
echo 1. Run build_and_install.bat to build the standalone binary
echo 2. Test the binary with test_binary.py
echo 3. The binary will be installed to electron/resources/
echo.
echo To activate the environment manually:
echo    call python\venv\Scripts\activate.bat

:end 