@echo off
setlocal

set VENV_DIR=venv

if not exist %VENV_DIR% (
    echo Virtual environment not found. Creating one...
    python -m venv %VENV_DIR%
    if errorlevel 1 (
        echo Failed to create virtual environment. Make sure Python is installed and added to the PATH.
        exit /b 1
    )
) else (
    echo Virtual environment already exists.
)

call %VENV_DIR%\Scripts\activate.bat

pip install -r requirements.txt

if errorlevel 1 (
    echo Failed to install packages.
    exit /b 1
)

pyinstaller --name=lipsync2markers --onefile main.py

echo Build completed!
pause

endlocal
