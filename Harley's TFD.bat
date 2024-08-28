@echo off
title Harley's TFD Tool v2.5
cls
setlocal enabledelayedexpansion

:: Constants
set "settingsPath=%USERPROFILE%\AppData\Local\M1\Saved\Config\Windows\"
set "backupBasePath=%USERPROFILE%\Documents\Harley's TFD\V2\%USERNAME%\Backup"
set "zipPath=%USERPROFILE%\Documents\Harley's TFD\V2\%USERNAME%\%USERNAME%_Transfer.zip"
set "logDir=%USERPROFILE%\Documents\Harley's TFD\V2\%USERNAME%\Logs"
set "logFile=%logDir%\%USERNAME%-Support_Log-%DATE:~10,4%-%DATE:~4,2%-%DATE:~7,2%_%TIME:~0,2%-%TIME:~3,2%-%TIME:~6,2%.txt"
set "version=V2.5"

:: Ensure log directory exists
if not exist "%logDir%" (
    mkdir "%logDir%"
)

:: Initialize log file
echo [%DATE% %TIME%] Harley's TFD Tool %version% [Started]. Logged in user @%USERNAME%. > "%logFile%"

:: Display Welcome Screen
call :welcomeScreen

:mainMenu
cls
echo ================================
echo     Harley's TFD Tool %version%
echo           Main Menu
echo ================================
echo.
echo [1] GameUserSettings Options
echo [2] Transfer (Zip/Unzip) Options
echo [3] Delete/Reset 'TFD Saved' Folder 
echo [4] Display Version
echo [5] Help
echo [6] Exit 
echo ================================
set /p choice="Enter your choice [1/2/3/4/5/6]: "

if "%choice%"=="1" goto :gameUserSettingsMenu
if "%choice%"=="2" goto :transferMenu
if "%choice%"=="3" goto :deleteSaved
if "%choice%"=="4" goto :displayVersion
if "%choice%"=="5" goto :helpMenu
if "%choice%"=="6" goto :goodbye

call :log "Invalid choice in main menu: %choice%"
echo Invalid choice. Please try again.
pause
goto :mainMenu

:welcomeScreen
cls
echo ================================
echo      Welcome @%USERNAME% To
echo      Harley's TFD Tool v2.5
echo ================================
echo.
echo Manage and transfer your TFD settings with ease. 
echo Choose an option from the menu to get started.
echo If Support Needed Check ur 
echo %logDir% 
echo for Your Log File and DM @HarleyTG on Discord
echo.
echo [1] Start: Harley's TFD Tool v2.5: Access the main functionality.
echo [2] Exit: Close the tool.
echo ================================
set /p choice="Enter your choice [1/2]: "

if "%choice%"=="1" goto :mainMenu
if "%choice%"=="2" goto :goodbye

call :log "Invalid choice in welcome screen: %choice%"
echo Invalid choice. Please try again.
pause
goto :welcomeScreen

:gameUserSettingsMenu
cls
echo ================================
echo     Harley's TFD Tool %version%
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

call :log "Invalid choice in GameUserSettings menu: %choice%"
echo Invalid choice. Please try again.
pause
goto :gameUserSettingsMenu

:backupGameUserSettings
cls
echo ================================
echo     Harley's TFD Tool %version%
echo ================================
echo     Backing Up GameUserSettings.ini
echo ================================
echo.

call :showLoading "Backing Up GameUserSettings.ini" 30 "Backing Up" "Please wait while we create a backup..."

:: Ensure the target directory exists
call :ensureDirExists "%backupBasePath%"

:: Backup the file
copy /y "%settingsPath%GameUserSettings.ini" "%backupBasePath%\GameUserSettings.ini" >nul
if errorlevel 1 (
    call :log "Failed to copy GameUserSettings.ini from %settingsPath% to %backupBasePath%"
    echo ERROR: Backup failed. Check the log file for details.
    pause
    goto :gameUserSettingsMenu
)

:: Check if the file was backed up successfully
if exist "%backupBasePath%\GameUserSettings.ini" (
    echo.
    echo ================================
    echo     Backup Successful!
    echo ================================
    call :log "GameUserSettings.ini backed up successfully from %settingsPath% to %backupBasePath%"
) else (
    echo.
    echo ================================
    echo     Backup Failed!
    echo ================================
    call :log "Backup file not found after backup operation."
    echo ERROR: Backup failed. Check the log file for details.
)
pause
goto :gameUserSettingsMenu

:restoreGameUserSettings
cls
echo ================================
echo     Harley's TFD Tool %version%
echo ================================
echo     Restoring GameUserSettings.ini
echo ================================
echo.

call :showLoading "Restoring GameUserSettings.ini" 30 "Restoring" "Please wait while we restore the settings..."

:: Ensure the backup file exists
if not exist "%backupBasePath%\GameUserSettings.ini" (
    call :log "Backup file not found at %backupBasePath%\GameUserSettings.ini"
    echo ERROR: Backup file not found. Check the log file for details.
    pause
    goto :gameUserSettingsMenu
)

:: Restore the file
copy /y "%backupBasePath%\GameUserSettings.ini" "%settingsPath%\GameUserSettings.ini" >nul
if errorlevel 1 (
    call :log "Failed to copy GameUserSettings.ini from %backupBasePath% to %settingsPath%"
    echo ERROR: Restore failed. Check the log file for details.
    pause
    goto :gameUserSettingsMenu
)

:: Check if the file was restored successfully
if exist "%settingsPath%\GameUserSettings.ini" (
    echo.
    echo ================================
    echo     Restore Successful!
    echo ================================
    call :log "GameUserSettings.ini restored successfully from %backupBasePath% to %settingsPath%"
) else (
    echo.
    echo ================================
    echo     Restore Failed!
    echo ================================
    call :log "Restore file not found after restore operation."
    echo ERROR: Restore failed. Check the log file for details.
)
pause
goto :gameUserSettingsMenu

:displayVersion
cls
echo ================================
echo     Harley's TFD Tool %version%
echo ================================
echo.
echo Current Version: %version%
echo ================================
pause
goto :mainMenu

:transferMenu
cls
echo ================================
echo     Harley's TFD Tool %version%
echo ================================
echo         Transfer Menu
echo ================================
echo.
echo Easily transfer between PC's TFD Settings and more.
echo Note: [Extract Transfer Zip] When you add it to another PC, it can be detected from Downloads
echo.
echo [1] Create Transfer Zip
echo [2] Extract Transfer Zip
echo [3] Back to Main Menu
echo ================================
set /p choice="Enter your choice [1/2/3]: "

if "%choice%"=="1" goto :createTransferZip
if "%choice%"=="2" goto :extractTransferZip
if "%choice%"=="3" goto :mainMenu

call :log "Invalid choice in Transfer menu: %choice%"
echo Invalid choice. Please try again.
pause
goto :transferMenu

:createTransferZip
cls
echo ================================
echo     Creating Transfer Zip
echo ================================
echo.
call :showLoading "Creating Transfer Zip" 30 "Creating Zip" "Please wait while we create the zip file..."

:: Ensure the backup directory exists
call :ensureDirExists "%backupBasePath%"

:: Create the zip file using PowerShell with detailed error reporting
powershell -Command ^
    "$sourcePath = \"%backupBasePath%\"; $destinationPath = \"%zipPath%\"; try { Compress-Archive -Path $sourcePath -DestinationPath $destinationPath -Force } catch { Write-Host \"Failed to create transfer zip: $($_.Exception.Message)\"; exit 1 }" 2>>"%logFile%"

:: Check if the zip file was created successfully
if exist "%zipPath%" (
    echo.
    echo ================================
    echo     Zip Creation Successful!
    echo ================================
    call :log "Transfer zip created successfully: %zipPath%"
) else (
    echo.
    echo ================================
    echo     Zip Creation Failed!
    echo ================================
    call :log "Failed to create transfer zip: Unknown error."
    echo Please check the log file for more details: %logFile%
)
pause
goto :transferMenu

:extractTransferZip
cls
echo ================================
echo     Harley's TFD Tool %version%
echo ================================
echo     Extracting Transfer Zip
echo ================================
echo.
echo Select the location of the transfer zip file to extract:
echo The zip file should be located in your Downloads folder or specified location.
echo.
set /p "zipPath=Enter the full path to the transfer zip file: "

:: Validate the zip file path
if not exist "%zipPath%" (
    call :log "Zip file not found at %zipPath%"
    echo ERROR: Zip file not found. Check the log file for details.
    pause
    goto :transferMenu
)

call :showLoading "Extracting Transfer Zip" 30 "Extracting Zip" "Please wait while we extract the zip file..."

:: Extract the zip file using PowerShell with detailed error reporting
powershell -Command ^
    "$zipPath = \"%zipPath%\"; $extractPath = \"%backupBasePath%\"; try { Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force } catch { Write-Host \"Failed to extract zip: $($_.Exception.Message)\"; exit 1 }" 2>>"%logFile%"

:: Check if extraction was successful
if exist "%backupBasePath%\GameUserSettings.ini" (
    echo.
    echo ================================
    echo     Extraction Successful!
    echo ================================
    call :log "Transfer zip extracted successfully to: %backupBasePath%"
) else (
    echo.
    echo ================================
    echo     Extraction Failed!
    echo ================================
    call :log "Failed to extract zip file: Unknown error."
    echo Please check the log file for more details: %logFile%
)
pause
goto :transferMenu

:deleteSaved
cls
echo ================================
echo     Harley's TFD Tool %version%
echo ================================
echo     Delete TFD Saved Folder
echo ================================
echo.
echo WARNING: This will delete all files in the TFD Saved folder.
echo.
set /p "confirm=Are you sure you want to delete the TFD Saved folder? [y/n]: "

if /i "%confirm%"=="y" (
    echo Deleting files...
    del /q "%settingsPath%*.*"
    if errorlevel 1 (
        call :log "Failed to delete files in %settingsPath%"
        echo ERROR: Deletion failed. Check the log file for details.
    ) else (
        call :log "Files deleted successfully in %settingsPath%"
        echo ================================
        echo     Deletion Successful!
        echo ================================
    )
) else (
    echo Deletion cancelled.
    call :log "User cancelled deletion of files in %settingsPath%"
)
pause
goto :mainMenu

:helpMenu
cls
echo ================================
echo     Harley's TFD Tool %version%
echo ================================
echo     Help Menu
echo ================================
echo.
echo [1] GameUserSettings Options - Manage GameUserSettings.ini file.
echo [2] Transfer (Zip/Unzip) Options - Create or extract transfer zip files.
echo [3] Delete/Reset 'TFD Saved' Folder - Remove all files in TFD Saved folder.
echo [4] Display Version - Show the current version of the tool.
echo [5] Help - View this help menu.
echo [6] Exit - Close the tool.
echo ================================
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
set "totalBars=40"
set "interval=1"  :: Interval is 1 second
set "timeRemaining=%totalSeconds%"

:: Check if totalSeconds is greater than 0 to avoid division by zero
if "%totalSeconds%"=="0" set "totalSeconds=1"

for /L %%i in (1,1,%totalBars%) do (
    set /A "percent=%%i*100/totalBars"
    set "bar="
    for /L %%j in (1,1,%%i) do set "bar=!bar!█"
    for /L %%k in (%%i+1,1,%totalBars%) do set "bar=!bar!░"

    :: Wait for the interval
    timeout /t %interval% /nobreak >nul

    :: Update the time remaining
    set /A "timeRemaining=totalSeconds - (%%i*totalSeconds/totalBars)"
    
    cls
    echo ================================
    echo     Harley's TFD Tool v2.5
    echo ================================
    echo.
    echo %message%
    echo.
    echo [!bar!] %percent%%% Complete
    echo Time remaining: !timeRemaining! seconds
    echo Action: %actionType%
    if defined additionalMessage echo %additionalMessage%
)
echo Done!
goto :eof



:log
:: Log messages with timestamp
echo [%DATE% %TIME%] %~1 >> "%logFile%"
goto :eof

:ensureDirExists
:: Ensure the directory exists
if not exist "%~1" (
    mkdir "%~1"
)
goto :eof

:goodbye
cls
echo ================================
echo     Harley's TFD Tool %version%
echo ================================
echo.
echo Thank you for using Harley's TFD Tool!
echo Goodbye, %USERNAME%!
echo ================================
echo.
pause
exit
