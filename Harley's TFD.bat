@echo off
title Harley's TFD Tool v2
cls
setlocal

:: Constants
set "settingsPath=%USERPROFILE%\AppData\Local\M1\Saved\Config\Windows\GameUserSettings.ini"
set "backupBasePath=%USERPROFILE%\Documents\Harley's TFD\V2\%USERNAME%\Backup"
set "savedFolder=%USERPROFILE%\AppData\Local\M1\Saved"

:: Welcome Screen
call :welcomeScreen

:mainMenu
cls
echo ================================
echo     Harley's TFD Tool v2
echo ================================
echo.
echo [1] GameUserSettings Options
echo [2] Delete/Reset 'TFD Saved' Folder 
echo [3] Help
echo [4] Exit 
echo ================================
set /p choice="Enter your choice [1/2/3/4]: "

if "%choice%"=="1" goto :gameUserSettingsMenu
if "%choice%"=="2" goto :deleteSaved
if "%choice%"=="3" goto :helpMenu
if "%choice%"=="4" goto :goodbye

echo Invalid choice. Please try again.
pause
goto :mainMenu

:gameUserSettingsMenu
cls
echo ================================
echo     GameUserSettings Options
echo ================================
echo.
echo [1] Backup GameUserSettings.ini 
echo [2] Restore GameUserSettings.ini
echo [3] Check Backup Integrity
echo [4] Back to Main Menu
echo ================================
set /p choice="Enter your choice [1/2/3/4]: "

if "%choice%"=="1" goto :backupGameUserSettings
if "%choice%"=="2" goto :restoreGameUserSettings
if "%choice%"=="3" goto :checkIntegrity
if "%choice%"=="4" goto :mainMenu

echo Invalid choice. Please try again.
pause
goto :gameUserSettingsMenu

:backupGameUserSettings
set "backupPath=%backupBasePath%"
cls
echo ================================
echo     Harley's TFD Tool v2
echo ================================
echo.
echo        Backing Up GameUserSettings.ini
echo ================================
echo.
echo Creating backup of GameUserSettings.ini...

:: Create backup directory if it doesn't exist
if not exist "%backupPath%" mkdir "%backupPath%"

call :showLoading "Backing up GameUserSettings.ini" 30 "Backup in Progress" "Creating backup directory if needed"
copy "%settingsPath%" "%backupPath%\GameUserSettings.ini" /y >nul

if exist "%backupPath%\GameUserSettings.ini" (
    echo.
    echo ================================
    echo     Backup Successful!
    echo ================================
) else (
    echo.
    echo ================================
    echo     Backup Failed!
    echo ================================
)
pause
goto :gameUserSettingsMenu

:restoreGameUserSettings
set "backupPath=%backupBasePath%"
cls
echo ================================
echo     Harley's TFD Tool v2
echo ================================
echo.
echo       Restoring GameUserSettings.ini
echo ================================
echo.
echo Checking for existing backup...

:: Check if the backup file exists
if not exist "%backupPath%\GameUserSettings.ini" (
    echo.
    echo ================================
    echo Backup file not found at: %backupPath%
    echo ================================
    echo.
    pause
    goto :gameUserSettingsMenu
)

:: Ensure necessary directories exist
if not exist "%settingsPath%" mkdir "%settingsPath%"

call :showLoading "Restoring GameUserSettings.ini" 30 "Restoring" "Creating directories if needed"
copy "%backupPath%\GameUserSettings.ini" "%settingsPath%" /y >nul

if exist "%settingsPath%" (
    echo.
    echo ================================
    echo     Restore Successful!
    echo ================================
) else (
    echo.
    echo ================================
    echo     Restore Failed!
    echo ================================
)
pause
goto :gameUserSettingsMenu

:deleteSaved
cls
echo ================================
echo     Harley's TFD Tool v2
echo ================================
echo.
echo    Deleting TFD Saved Folder
echo ================================
echo.
echo Please wait...

call :showLoading "Deleting TFD Saved Folder" 30 "Deleting" "Removing old saved folder"
rmdir /s /q "%savedFolder%"

if not exist "%savedFolder%" (
    echo.
    echo ================================
    echo     Deletion Successful!
    echo ================================
) else (
    echo.
    echo ================================
    echo   Deletion Failed!
    echo ================================
)
pause
goto :mainMenu

:checkIntegrity
cls
echo ================================
echo     Harley's TFD Tool v2
echo ================================
echo.
echo    Checking Backup Integrity
echo ================================
echo.
call :showLoading "Checking Integrity" 30 "Checking" "Comparing files"
fc /b "%settingsPath%" "%backupPath%\GameUserSettings.ini" >nul

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
goto :gameUserSettingsMenu

:helpMenu
cls
echo ================================
echo     Harley's TFD Tool v2
echo ================================
echo.
echo     Interactive Help Menu
echo ================================
echo.
echo [1] GameUserSettings Options:
echo    - Backup GameUserSettings.ini: Create a backup of the GameUserSettings.ini file.
echo    - Restore GameUserSettings.ini: Restore the GameUserSettings.ini file from a backup.
echo    - Check Backup Integrity: Compare the current GameUserSettings.ini with the backup to ensure they are identical.
echo.
echo [2] Delete/Reset 'TFD Saved' Folder:
echo    - This option deletes the 'TFD Saved' folder in the 'M1' directory, which can be useful for resetting or clearing out old data.
echo.
echo [3] Exit:
echo    - Exit the tool and close the script.
echo.
echo Press any key to return to the main menu...
pause >nul
goto :mainMenu

:goodbye
cls
echo ================================
echo     Harley's TFD Tool v2
echo ================================
echo.
echo   Thank you for using the tool!
echo   Goodbye and see you next time!
echo ================================
timeout /t 5 /nobreak >nul
exit /b

:welcomeScreen
cls
echo ================================
echo       Welcome to the
echo     Harley's TFD Tool v2
echo ================================
echo.
echo Description: This script allows you to back up, restore GameUserSettings.ini, and delete/reset the 'TFD Saved' folder inside the 'M1' directory.
echo Fixes: Tutorial bug and More Coming Soon
echo Made by: HarleyTG
echo.
echo Press any key to continue...
pause >nul
exit /b

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

