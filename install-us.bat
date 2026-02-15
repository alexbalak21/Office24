@echo off
:: --- Step 1: Check for admin rights ---
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: --- Step 2: Run the installer ---
cd /d "%~dp0"
setup.exe /configure config-us.xml

pause
