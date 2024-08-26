@echo off
title Harley's TFD Tool v2
cls

:: Welcome Screen
echo ================================
echo       Welcome to the
echo     Harley's TFD Tool v2
echo ================================
echo.
echo Description: This script allows you to back up, restore keybindings, and delete/reset the 'TFD Saved' folder inside the 'M1' directory.
echo Fixes: Tutorial bug and More Coming Soon
echo Made by: HarleyTG
echo.
echo Press any key to continue...
pause >nul

:mainMenu
cls
echo ================================
echo     Harley's TFD Tool v2
echo ================================
echo.
echo [1] Backup Keybindings 
echo [2] Restore Keybindings 
echo [3] Delete/Reset 'TFD Saved' Folder 
echo [4] Check Backup Integrity
echo [5] Exit 
echo ================================
set /p choice="Enter your choice [1/2/3/4/5]: "

if "%choice%"=="1" goto :backupKeybindings
if "%choice%"=="2" goto :restoreKeybindings
if "%choice%"=="3" goto :deleteSaved
if "%choice%"=="4" goto :checkIntegrity
if "%choice%"=="5" exit /b

echo Invalid choice. Please try again.
pause
goto :mainMenu

:backupKeybindings
set "keybindingsPath=%USERPROFILE%\AppData\Local\M1\Saved\Config\Windows\GameUserSettings.ini"
set "backupPath=%USERPROFILE%\Documents\Harley's TFD\V2\%USERNAME%\Backup"

cls
echo ================================
echo     Harley's TFD Tool v2
echo ================================
echo.
echo        Backing Up Keybindings
echo ================================
echo.
echo Creating backup of keybindings...

:: Create backup directory if it doesn't exist
if not exist "%backupPath%" (
    echo Creating backup directory...
    mkdir "%backupPath%"
)

call :showLoading "Backing up Keybindings" 30 "Backup in Progress" "Creating backup directory if needed"

copy "%keybindingsPath%" "%backupPath%\GameUserSettings.ini" /y >nul
if exist "%backupPath%\GameUserSettings.ini" (
    echo.
    echo ================================
    echo     Backup Successful!
    echo ================================
    echo.
) else (
    echo.
    echo ================================
    echo     Backup Failed!
    echo ================================
    echo.
)
pause
goto :mainMenu

:restoreKeybindings
set "keybindingsPath=%USERPROFILE%\AppData\Local\M1\Saved\Config\Windows\GameUserSettings.ini"
set "backupPath=%USERPROFILE%\Documents\Harley's TFD\V2\%USERNAME%\Backup"

cls
echo ================================
echo     Harley's TFD Tool v2
echo ================================
echo.
echo       Restoring Keybindings
echo ================================
echo.
echo Checking for existing backup...

:: Check if the backup path exists
if not exist "%backupPath%" (
    echo.
    echo ================================
    echo Backup path not found: %backupPath%
    echo ================================
    echo.
    pause
    goto :mainMenu
)

:: Check if the backup file exists
if not exist "%backupPath%\GameUserSettings.ini" (
    echo.
    echo ================================
    echo Backup file not found in: %backupPath%
    echo ================================
    echo.
    pause
    goto :mainMenu
)

:: Create the necessary directories if they do not exist
for %%d in ("%USERPROFILE%\AppData\Local\M1\Saved\Config\Windows") do (
    if not exist "%%d" (
        echo Creating directory: %%d
        mkdir "%%d"
    )
)

call :showLoading "Restoring Keybindings" 30 "Restoring" "Creating directories if needed"

:: Attempt to restore the keybindings
copy "%backupPath%\GameUserSettings.ini" "%keybindingsPath%" /y >nul
if exist "%keybindingsPath%" (
    echo.
    echo ================================
    echo     Restore Successful!
    echo ================================
    echo.
) else (
    echo.
    echo ================================
    echo     Restore Failed! Could not copy file to: %keybindingsPath%
    echo ================================
    echo.
)

pause
goto :mainMenu

:deleteSaved
set "savedFolder=%USERPROFILE%\AppData\Local\M1\Saved"
set "displayFolderName=TFD Saved Folder"

cls
echo ================================
echo     Harley's TFD Tool v2
echo ================================
echo.
echo    Deleting %displayFolderName%
echo ================================
echo.
echo Please wait...

call :showLoading "Deleting %displayFolderName%" 30 "Deleting" "Removing old saved folder"

rmdir /s /q "%savedFolder%"

if not exist "%savedFolder%" (
    echo.
    echo ================================
    echo     Deletion Successful!
    echo ================================
    echo.
) else (
    echo.
    echo ================================
    echo   Deletion Failed!
    echo ================================
    echo.
)

pause
goto :mainMenu

:checkIntegrity
set "keybindingsPath=%USERPROFILE%\AppData\Local\M1\Saved\Config\Windows\GameUserSettings.ini"
set "backupPath=%USERPROFILE%\Documents\Harley's TFD\V2\%USERNAME%\Backup"

cls
echo ================================
echo     Harley's TFD Tool v2
echo ================================
echo.
echo    Checking Backup Integrity
echo ================================
echo.
call :showLoading "Checking Integrity" 30 "Checking" "Comparing files"

fc /b "%keybindingsPath%" "%backupPath%\GameUserSettings.ini" >nul
if %errorlevel%==0 (
    echo.
    echo ================================
    echo Files are identical!
    echo ================================
) else (
    echo.
    echo ================================
    echo Files are different!
    echo ================================
)
echo.
pause
goto :mainMenu

:showLoading
:: Progress Bar Function
:: Usage: call :showLoading "Message" totalSeconds actionType [additionalMessage]
setlocal EnableDelayedExpansion
set "message=%~1"
set "totalSeconds=%~2"
set "actionType=%~3"
set "additionalMessage=%~4"
set "totalBars=9"
set "interval=1"  :: Interval is 1 second
set "timeRemaining=%totalSeconds%"

for /L %%i in (1,1,%totalBars%) do (
    set /A "percent=%%i*100/totalBars"
    set "bar="
    for /L %%j in (1,1,%%i) do set "bar=!bar![*]"
    for /L %%k in (%%i+1,1,%totalBars%) do set "bar=!bar! "

    :: Wait for the interval
    timeout /t %interval% /nobreak >nul

    :: Update the time remaining
    set /A "timeRemaining=totalSeconds - (%%i*totalSeconds/totalBars)"
    
    cls
    echo ================================
    echo     Harley's TFD Tool v2
    echo ================================
    echo.
    echo !bar!
    echo %message%: !percent!%% complete
    echo Time remaining: !timeRemaining! seconds
    echo Action: %actionType%
    if defined additionalMessage echo %additionalMessage%
)

endlocal
exit /b

