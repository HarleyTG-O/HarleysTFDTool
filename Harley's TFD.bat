
@echo off
title Harley's TFD Tool
cls
setlocal enabledelayedexpansion

:: Constants
set "version=[V1.6]"
set "settingsPath=%USERPROFILE%\AppData\Local\M1\Saved\Config\Windows\"
set "backupBasePath=%USERPROFILE%\Documents\Harley's TFD\%version%\%USERNAME%\Backup"
set "zipPath=%USERPROFILE%\Documents\Harley's TFD\%version%\%USERNAME%\%USERNAME%_HTFD-Transfer.zip"
set "logDir=%USERPROFILE%\Documents\Harley's TFD\%version%\%USERNAME%\Logs"


:: Get current date and time
for /f "tokens=2 delims==" %%I in ('"wmic os get localdatetime /value"') do set "datetime=%%I"
set "year=%datetime:~0,4%"
set "month=%datetime:~4,2%"
set "day=%datetime:~6,2%"
set "hour=%datetime:~8,2%"
set "minute=%datetime:~10,2%"
set "second=%datetime:~12,2%"

:: Define log file name with formatted date and time
set "logFile=%logDir%\%USERNAME%-Support_Log[%year%-%month%-%day%_%hour%-%minute%-%second%].txt"


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
echo   Harley's TFD Tool %version%
echo           Main Menu
echo ================================
echo.
echo [1] GameUserSettings Options
echo [2] Transfer (Zip/Unzip) Options
echo [3] Delete/Reset 'TFD Saved' Folder
echo [4] System Menu
echo [5] Display Version
echo [6] Help
echo [7] Exit 
echo ================================
set /p choice="Enter your choice [1/2/3/4/5/6/7]: "

if "%choice%"=="1" goto :gameUserSettingsMenu
if "%choice%"=="2" goto :transferMenu
if "%choice%"=="3" goto :deleteSaved
if "%choice%"=="4" goto :systemMenu
if "%choice%"=="5" goto :displayVersion
if "%choice%"=="6" goto :helpMenu
if "%choice%"=="7" goto :goodbye

call :log "Invalid choice in main menu: %choice%"
echo Invalid choice. Please try again.
pause
goto :mainMenu

:welcomeScreen
cls
echo ================================
echo     Welcome @%USERNAME% To
echo   Harley's TFD Tool %version%
echo ================================
echo.
echo Manage and transfer your TFD settings with ease. 
echo.
echo If support is needed, check your
echo [%logDir%]
echo for your log file and DM @HarleyTG on Discord.
echo.
echo Choose an option from the menu to get started.
echo [1] Start: Harley's TFD Tool.
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
echo   Harley's TFD Tool %version%
echo ================================
echo    GameUserSettings Options
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
echo   Harley's TFD Tool %version%
echo ================================
echo Backing Up GameUserSettings.ini
echo ================================
echo.

call :showLoading "Backing Up GameUserSettings.ini" 10 "Backup in progress" "Please wait while we create a backup..."

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
    echo        Backup Successful!
    echo ================================
    call :log "GameUserSettings.ini backed up successfully from %settingsPath% to %backupBasePath%"
) else (
    echo.
    echo ================================
    echo         Backup Failed!
    echo ================================
    call :log "Backup file not found after backup operation."
    echo ERROR: Backup failed. Check the log file for details.
)
pause
goto :gameUserSettingsMenu

:restoreGameUserSettings
cls
echo ================================
echo   Harley's TFD Tool %version%
echo ================================
echo  Restoring GameUserSettings.ini
echo ================================
echo.

call :showLoading "Restoring GameUserSettings.ini" 10 "Restoring in progress" "Please wait while we restore the settings..."

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
    echo      Restore Successful!
    echo ================================
    call :log "GameUserSettings.ini restored successfully from %backupBasePath% to %settingsPath%"
) else (
    echo.
    echo ================================
    echo        Restore Failed!
    echo ================================
    call :log "Restore file not found after restore operation."
    echo ERROR: Restore failed. Check the log file for details.
)
pause
goto :gameUserSettingsMenu

:systemMenu
cls
echo ================================
echo   Harley's TFD Tool %version%
echo ================================
echo       System Menu
echo ================================
echo.
echo [1] Delete All Logs
echo [2] Delete Specific Log
echo [3] Back to Main Menu
echo ================================
set /p choice="Enter your choice [1/2/3]: "

if "%choice%"=="1" goto :deleteAllLogs
if "%choice%"=="2" goto :deleteSpecificLog
if "%choice%"=="3" goto :mainMenu

call :log "Invalid choice in System menu: %choice%"
echo Invalid choice. Please try again.
pause
goto :systemMenu

:deleteAllLogs
cls
echo ================================
echo   Harley's TFD Tool %version%
echo ================================
echo   Deleting All Logs
echo ================================
echo.
echo WARNING: This will delete all log files in the log directory.
echo Are you sure you want to proceed? [Y/N]
set /p confirm="Enter your choice [Y/N]: "

if /i "%confirm%"=="Y" (
    call :showLoading "Deleting All Logs" 10 "Deleting in progress" "Please wait while we remove all log files..."

    :: Delete all log files
    del /q "%logDir%\*.*"
    if exist "%logDir%\*.*" (
        echo ERROR: Failed to delete all logs. Check the log file for details.
        call :log "Failed to delete all logs."
    ) else (
        echo.
        echo ================================
        echo   All Logs Deleted Successfully!
        echo ================================
        call :log "Successfully deleted all logs."
    )
) else (
    echo Operation canceled.
)
pause
goto :systemMenu

:deleteSpecificLog
cls
echo ================================
echo   Harley's TFD Tool %version%
echo ================================
echo  Deleting Specific Log
echo ================================
echo.
echo Available logs:
dir /b "%logDir%\*.txt"
echo.
set /p logToDelete="Enter the name of the log file to delete (e.g., username-Support_Log[YYYY-MM-DD_HH-MM-SS].txt): "

:: Construct the full path to the log file
set "logFileToDelete=%logDir%\%logToDelete%"

:: Check if the log file exists
if not exist "%logFileToDelete%" (
    echo ERROR: Log file not found. Check the log file for details.
    call :log "Attempted to delete '%logFileToDelete%' but file was not found."
    echo Log file not found.
    pause
    goto :systemMenu
)

:: Delete the specific log file
del /q "%logFileToDelete%"
if exist "%logFileToDelete%" (
    echo ERROR: Failed to delete '%logFileToDelete%'. Check the log file for details.
    call :log "Failed to delete '%logFileToDelete%'."
) else (
    echo.
    echo ================================
    echo Log Deleted Successfully!
    echo ================================
    call :log "Successfully deleted '%logFileToDelete%'."
)
pause
goto :systemMenu



:checkIntegrity
cls
echo ================================
echo     Harley's TFD Tool %version%
echo ================================
echo.
echo    Checking Backup Integrity
echo ================================
echo.
call :showLoading "Checking Integrity" 30 "Checking" "Comparing files"
fc /b "%settingsPath%GameUserSettings.ini" "%backupBasePath%\GameUserSettings.ini" >nul

if %errorlevel%==0 (
    echo.
    echo ================================
    echo Files are identical!
    echo ================================
    call :log "Backup integrity check: Files are identical."
) else (
    echo.
    echo ================================
    echo Files are different!
    echo ================================
    call :log "Backup integrity check: Files are different."
)
echo.
pause
goto :gameUserSettingsMenu


:displayVersion
cls
echo ================================
echo    Harley's TFD Tool %version%
echo ================================
echo.
echo   Current Version: %version%
echo ================================
pause
goto :mainMenu

:transferMenu
cls
echo ================================
echo   Harley's TFD Tool %version%
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
echo   Harley's TFD Tool %version%
echo     Creating Transfer Zip
echo ================================
echo.

:: Prompt the user to choose between default or Downloads directory
echo Please choose where to save the Transfer Zip:
echo 1. Default Directory (%backupBasePath%)
echo 2. Downloads Folder (%USERPROFILE%\Downloads)
set /p choice="Enter your choice (1 or 2): "

:: Set the destination directory based on user choice
if "%choice%"=="1" (
    set "zipDestinationPath=%backupBasePath%"
) else if "%choice%"=="2" (
    set "zipPath=%USERPROFILE%\Downloads\%USERNAME%_HTFD-Transfer.zip"
) else (
    echo Invalid choice. Defaulting to the Default Directory.
    set "zipDestinationPath=%backupBasePath%"
)

:: Ensure the backup directory exists
call :ensureDirExists "%zipDestinationPath%"

:: Set the full path for the zip file
set "zipPath=%zipDestinationPath%\Transfer.zip"

:: Show the loading screen while creating the zip file
call :showLoading "Creating Transfer Zip" 10 "Creating Zip" "Please wait while we create the zip file..."

:: Create the zip file using PowerShell with detailed error reporting
powershell -Command ^
    "$sourcePath = \"%backupBasePath%\"; $destinationPath = \"%zipPath%\"; try { Compress-Archive -Path $sourcePath -DestinationPath $destinationPath -Force } catch { Write-Host \"ERROR: Failed to create the zip file.\"; exit 1 }"

if errorlevel 1 (
    call :log "Failed to create zip file: %zipPath%"
    echo ERROR: Zip creation failed. Check the log file for details.
    pause
    goto :transferMenu
)

if exist "%zipPath%" (
    echo ================================
    echo     Transfer Zip Created!
    echo ================================
    call :log "Transfer zip file created at %zipPath%"
) else (
    echo ================================
    echo     Zip Creation Failed!
    echo ================================
    call :log "Zip file not found after creation operation."
    echo ERROR: Zip creation failed. Check the log file for details.
)
pause
goto :transferMenu


:extractTransferZip
cls
echo ================================
echo   Harley's TFD Tool %version%
echo     Extracting Transfer Zip
echo ================================
echo.
call :showLoading "Extracting Transfer Zip" 10 "Extracting Zip" "Please wait while we extract the zip file..."

:: Ensure the zip file exists
if not exist "%zipPath%" (
    call :log "Zip file not found at %zipPath%"
    echo ERROR: Zip file not found. Check the log file for details.
    pause
    goto :transferMenu
)

:: Extract the zip file using PowerShell with detailed error reporting
powershell -Command ^
    "$zipPath = \"%zipPath%\"; $extractPath = \"%backupBasePath%\"; try { Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force } catch { Write-Host \"ERROR: Failed to extract the zip file.\"; exit 1 }"

if errorlevel 1 (
    call :log "Failed to extract zip file: %zipPath%"
    echo ERROR: Zip extraction failed. Check the log file for details.
    pause
    goto :transferMenu
)

if exist "%backupBasePath%\GameUserSettings.ini" (
    echo ================================
    echo     Transfer Zip Extracted!
    echo ================================
    call :log "Transfer zip file extracted to %backupBasePath%"
) else (
    echo ================================
    echo     Extraction Failed!
    echo ================================
    call :log "Extracted files not found after extraction operation."
    echo ERROR: Zip extraction failed. Check the log file for details.
)
pause
goto :transferMenu

:deleteSaved
cls
echo ================================
echo   Harley's TFD Tool %version%
echo    Delete/Reset TFD Saved
echo ================================
echo.
echo WARNING: This will delete the TFD saved folder.
echo Are you sure you want to proceed?
echo ================================
set /p choice="Enter [Y] to confirm, or [N] to cancel: "

if /i "%choice%"=="Y" (
    echo Deleting the TFD saved folder...
    call :log "User confirmed deletion of the TFD saved folder."

    rmdir /s /q "%settingsPath%TFD Saved"
    if errorlevel 1 (
        call :log "Failed to delete the TFD saved folder."
        echo ERROR: Failed to delete the TFD saved folder. Check the log file for details.
        pause
        goto :mainMenu
    )

    echo TFD saved folder deleted successfully.
    call :log "TFD saved folder deleted successfully."
    pause
) else (
    echo Deletion canceled.
    call :log "User canceled deletion of the TFD saved folder."
    pause
)
goto :mainMenu

:helpMenu
cls
echo ================================
echo   Harley's TFD Tool %version%
echo           Help Menu
echo ================================
echo.
echo This tool allows you to manage your TFD GameUserSettings.ini files, 
echo create transfer zips for easy transfers between PCs, and more.
echo.
echo Main Menu Options:
echo [1] Backup GameUserSettings.ini: Creates a backup of the GameUserSettings.ini file.
echo [2] Restore GameUserSettings.ini: Restores the GameUserSettings.ini file from a backup.
echo [3] Check Backup Integrity: Compares the current and backup files to check for changes.
echo [4] Create Transfer Zip: Creates a ZIP file for transferring settings.
echo [5] Extract Transfer Zip: Extracts a ZIP file to restore settings.
echo [6] Delete/Reset 'TFD Saved' Folder: Permanently deletes the TFD Saved folder.
echo [7] Display Version: Shows the current version of the tool.
echo [8] Back to Main Menu
echo.
echo Press any key to return to the main menu...
pause >nul
goto :mainMenu

:goodbye
cls
echo ================================
echo   Harley's TFD Tool %version%
echo         Goodbye Screen
echo
echo          @%USERNAME%
echo ================================
echo.
echo Thank you for using Harley's TFD Tool.
echo for Support Contact @HarleyTG On Discord
echo actions during this session were logged to:
echo [%logFile%]
echo.
call :log "Session ended for user @%USERNAME%."

:: Simulate a "press any key to exit" button
echo.
echo Press any key to exit...
pause >nul

:: Forcefully exit the script
exit 0

:: Function to log messages
:log
echo %~1 >> %logFile%
exit /b



:showLoading
:: Arguments: [1] Message [2] Total Seconds [3] Action Type [4] Additional Message
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
    echo     Harley's TFD Tool %Version%
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
:log
:: Parameters: %1=Log Message
echo [%DATE% %TIME%] %~1 >> "%logFile%"
exit /b

:ensureDirExists
:: Parameters: %1=Directory Path
if not exist "%~1" (
    mkdir "%~1"
    if errorlevel 1 (
        call :log "Failed to create directory: %~1"
    )
)
exit /b
