@echo off
setlocal
cd /d "%~dp0"

where node >nul 2>nul
if errorlevel 1 (
    echo Node.js is not installed or is not on PATH.
    echo Install Node.js 20 or newer, then reopen this window.
    pause
    exit /b 1
)

where npm >nul 2>nul
if errorlevel 1 (
    echo npm is not installed or is not on PATH.
    echo Reinstall Node.js with npm, then reopen this window.
    pause
    exit /b 1
)

if not exist ".env" (
    copy ".env.example" ".env" >nul
    echo Created .env from .env.example.
    echo.
    echo Edit .env and replace SESSION_SECRET and INITIAL_ADMIN_SETUP_KEY
    echo with separate random values of at least 32 characters.
    echo Then run start-all.bat again.
    echo.
    pause
    exit /b 1
)

if not exist "node_modules" (
    echo Installing DriveVault dependencies...
    call npm install
    if errorlevel 1 (
        echo.
        echo Dependency installation failed.
        pause
        exit /b 1
    )
)

echo Starting the DriveVault API and frontend...
echo Frontend: http://localhost:5173
echo API:      http://localhost:4000
echo Press Ctrl+C to stop both services.
echo.
call npm run dev
if errorlevel 1 (
    echo.
    echo DriveVault stopped with an error. Check the output above.
    pause
)

endlocal
