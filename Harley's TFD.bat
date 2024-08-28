@echo off
title Harley's TFD Tool v2.5
cls
setlocal enabledelayedexpansion

:: Constants
set "settingsPath=%USERPROFILE%\AppData\Local\M1\Saved\Config\Windows\GameUserSettings.ini"
set "backupBasePath=%USERPROFILE%\Documents\Harley's TFD\V2\%USERNAME%\Backup"
set "zipPath=%USERPROFILE%\Documents\Harley's TFD\V2\%USERNAME%\%USERNAME%_Transfer.zip"
set "logDir=%USERPROFILE%\Documents\Harley's TFD\V2\%USERNAME%\Logs"
set "logFile=%logDir%\%USERNAME%-Support_Log-%DATE:~10,4%-%DATE:~4,2%-%DATE:~7,2%_%TIME:~0,2%-%TIME:~3,2%-%TIME:~6,2%.txt"

:: Ensure log directory exists
if not exist "%logDir%" (
    mkdir "%logDir%"
)

:: Initialize log file
echo [%DATE% %TIME%] Harley's TFD Tool v2.5 [Started]. Logged in user @%USERNAME%. > "%logFile%"


:: Display Welcome Screen
call :welcomeScreen

:mainMenu
cls
echo ================================
echo     Harley's TFD Tool v2.5
echo           Main Menu
echo ================================
echo.
echo [1] GameUserSettings Options
echo [2] Transfer (Zip/Unzip) Options
echo [3] Delete/Reset 'TFD Saved' Folder 
echo [4] Help
echo [5] Exit 
echo ================================
set /p choice="Enter your choice [1/2/3/4/5]: "

if "%choice%"=="1" goto :gameUserSettingsMenu
if "%choice%"=="2" goto :transferMenu
if "%choice%"=="3" goto :deleteSaved
if "%choice%"=="4" goto :helpMenu
if "%choice%"=="5" goto :goodbye

call :log "Invalid choice in main menu: %choice%"
echo Invalid choice. Please try again.
pause
goto :mainMenu

:gameUserSettingsMenu
cls
echo ================================
echo     Harley's TFD Tool v2.5
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

:transferMenu
cls
echo ================================
echo     Harley's TFD Tool v2.5
echo ================================
echo         Transfer Menu
echo ================================
echo.
echo Easily transfer between PC's TFD Settings and more.
echo Note: [Extract Transfer Zip] When u add it to another PC it can Be Detected From Downloads
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
if not exist "%backupBasePath%" (
    call :log "Failed to create transfer zip: Backup directory not found at %backupBasePath%."
    echo Backup directory not found. Please check the path and try again.
    pause
    goto :transferMenu
)

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
echo     Harley's TFD Tool v2.5
echo ================================
echo     Extracting Transfer Zip
echo ================================
echo.
echo Select the location of the zip file:
echo [1] Current Location (Backup Directory)
echo [2] Downloads Folder
echo ================================
set /p locationChoice="Enter your choice [1/2]: "

:: Set default zip path for current location
set "zipPath=%USERPROFILE%\Documents\Harley's TFD\V2\%USERNAME%\%USERNAME%_Transfer.zip"

:: Update zip path based on user choice
if "%locationChoice%"=="2" (
    set "zipPath=C:\%USERNAME%\Downloads\%USERNAME%_Transfer.zip"
)

:: Show loading screen
call :showLoading "Extracting Transfer Zip" 30 "Extracting Zip" "Please wait while we extract the zip file..."

:: Ensure the zip file exists
if not exist "%zipPath%" (
    call :log "Failed to extract transfer zip: Zip file not found at %zipPath%"
    echo Transfer zip file not found at: %zipPath%
    pause
    goto :transferMenu
)

:: Ensure the backup directory exists
if not exist "%backupBasePath%" (
    mkdir "%backupBasePath%"
)

:: Extract the zip file using PowerShell with detailed error reporting
powershell -Command ^
    "$sourcePath = \"%zipPath%\"; $destinationPath = \"%backupBasePath%\"; try { Expand-Archive -Path $sourcePath -DestinationPath $destinationPath -Force } catch { Write-Host \"Failed to extract transfer zip: $($_.Exception.Message)\"; exit 1 }" 2>>"%logFile%"

:: Check if the files were extracted successfully
if exist "%backupBasePath%\GameUserSettings.ini" (
    echo.
    echo ================================
    echo     Extraction Successful!
    echo ================================
    call :log "Transfer zip extracted successfully: %zipPath%"
) else (
    echo.
    echo ================================
    echo     Extraction Failed!
    echo ================================
    call :log "Failed to extract transfer zip: Unknown error."
    echo Please check the log file for more details: %logFile%
)
pause
goto :transferMenu


:deleteSaved
cls
echo ================================
echo     Harley's TFD Tool v2.5
echo ================================
echo.
echo    Deleting TFD Saved Folder
echo ================================
echo.
call :showLoading "Deleting TFD Saved Folder" 30 "Deleting" "Removing old saved folder"

:: Ensure savedFolder variable is defined
set "savedFolder=%USERPROFILE%\AppData\Local\M1\Saved"
rmdir /s /q "%savedFolder%"

if not exist "%savedFolder%" (
    echo.
    echo ================================
    echo     Deletion Successful!
    echo ================================
    call :log "TFD Saved folder deleted successfully."
) else (
    echo.
    echo ================================
    echo   Deletion Failed!
    echo ================================
    call :log "Failed to delete TFD Saved folder."
)
pause
goto :mainMenu

:checkIntegrity
cls
echo ================================
echo     Harley's TFD Tool v2.5
echo ================================
echo.
echo    Checking Backup Integrity
echo ================================
echo.
call :showLoading "Checking Backup Integrity" 30 "Checking" "Comparing files"

fc /b "%settingsPath%" "%backupBasePath%\GameUserSettings.ini" >nul

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

:helpMenu
cls
echo ================================
echo     Harley's TFD Tool v2.5
echo ================================
echo.
echo        Interactive Help 
echo ================================
echo.
echo [1] GameUserSettings Options:
echo    - Backup GameUserSettings.ini: Create a backup of the GameUserSettings.ini file.
echo    - Restore GameUserSettings.ini: Restore the GameUserSettings.ini file from a backup.
echo    - Check Backup Integrity: Compare the current GameUserSettings.ini with the backup to ensure they are identical.
echo.
echo [2] Transfer (Zip/Unzip) Options:
echo    - Create Transfer Zip: Create a zip file of the GameUserSettings.ini backup for easy transfer.
echo    - Extract Transfer Zip: Extract the zip file back into the backup folder for restoration.
echo.
echo [3] Delete/Reset 'TFD Saved' Folder:
echo    - This option deletes the 'TFD Saved' folder to reset the game's settings.
echo.
echo [4] Help:
echo    - Provides this help menu.
echo.
echo [5] Exit:
echo    - Exit the tool and close the script.
echo ================================
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

:goodbye
cls
echo ================================
echo     Harley's TFD Tool v2.5
echo ================================
echo.
echo     Goodbye, %USERNAME%!
echo ================================
echo.
echo Thank you for using Harley's TFD Tool v2.5.
echo ================================
echo.

:: Call the loading function for 5 seconds
call :showLoading "Shutting down..." 5 "Shutdown" "Please wait while we close the tool..."

:: Ensure logs are recorded before exiting
call :log "Harley's TFD Tool v2.5 closed by user."
call :log "Harley's TFD Tool v2.5 [Ended]"

:: Exit the script completely
exit




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

:: Check if totalSeconds is greater than 0 to avoid division by zero
if "%totalSeconds%"=="0" set "totalSeconds=1"

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
    echo     Harley's TFD Tool v2.5
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
:: Log Function
:: Usage: call :log "Message"
setlocal
echo [%DATE% %TIME%] %~1 >> "%logFile%"
endlocal
exit /b
