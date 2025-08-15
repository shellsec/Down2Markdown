@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

title Smart Note Apps Updater

echo === Smart Note Apps Updater ===
echo.

:: Set directories
set "DOWNLOAD_DIR=%~dp0downloads"
set "LOG_FILE=%~dp0update_log.txt"
set "TEMP_DIR=%TEMP%\updater"

:: Create directories
if not exist "%DOWNLOAD_DIR%" mkdir "%DOWNLOAD_DIR%"
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"

:: Clear log
echo [%date% %time%] Starting smart update process > "%LOG_FILE%"

:: Test network
echo Testing network connection...
ping -n 1 github.com >nul 2>&1
if errorlevel 1 (
    echo ERROR: No internet connection
    pause
    exit /b 1
)
echo Network OK
echo.

:: Show menu
echo Select application to update:
echo 1. Obsidian
echo 2. NoteGen  
echo 3. Yank Note
echo 4. Joplin
echo 5. SiYuan
echo 6. Trilium Notes
echo 7. Update All
echo 0. Exit
echo.

set /p "choice=Enter choice (0-7): "

if "%choice%"=="0" exit /b 0
if "%choice%"=="1" call :UpdateApp "Obsidian" "obsidianmd/obsidian-releases" "Obsidian.exe" "Obsidian-{version}.exe"
if "%choice%"=="2" call :UpdateApp "NoteGen" "codexu/note-gen" "NoteGen.exe" "NoteGen_{version_clean}_x64-setup.exe"
if "%choice%"=="3" call :UpdateApp "Yank Note" "purocean/yn" "Yank-Note.exe" "Yank-Note-win-x64-{version}.exe"
if "%choice%"=="4" call :UpdateApp "Joplin" "laurent22/joplin" "Joplin.exe" "Joplin-Setup-{version}.exe"
if "%choice%"=="5" call :UpdateApp "SiYuan" "siyuan-note/siyuan" "siyuan.exe" "siyuan-{version}-win.exe"
if "%choice%"=="6" call :UpdateApp "Trilium Notes" "TriliumNext/Trilium" "TriliumNotes.exe" "TriliumNotes-v{version}-windows-x64.exe"
if "%choice%"=="7" (
    call :UpdateApp "Obsidian" "obsidianmd/obsidian-releases" "Obsidian.exe" "Obsidian-{version}.exe"
    call :UpdateApp "NoteGen" "codexu/note-gen" "NoteGen.exe" "NoteGen_{version_clean}_x64-setup.exe"
    call :UpdateApp "Yank Note" "purocean/yn" "Yank-Note.exe" "Yank-Note-win-x64-{version}.exe"
    call :UpdateApp "Joplin" "laurent22/joplin" "Joplin.exe" "Joplin-Setup-{version}.exe"
    call :UpdateApp "SiYuan" "siyuan-note/siyuan" "siyuan.exe" "siyuan-{version}-win.exe"
    call :UpdateApp "Trilium Notes" "TriliumNext/Trilium" "TriliumNotes.exe" "TriliumNotes-v{version}-windows-x64.exe"
)

if "%choice%" gtr "7" (
    echo Invalid choice
    pause
    exit /b 1
)

echo.
echo All updates completed!
set /p "OPEN_DIR=Open download folder? (y/n): "
if /i "%OPEN_DIR%"=="y" explorer "%DOWNLOAD_DIR%"

pause
exit /b 0

:: Function to update an app
:UpdateApp
setlocal
set "APP_NAME=%~1"
set "REPO=%~2"
set "PROCESS_NAME=%~3"
set "FILE_PATTERN=%~4"

echo.
echo === Updating %APP_NAME% ===
echo Getting latest version info...

:: Get latest release info using GitHub API
set "API_URL=https://api.github.com/repos/%REPO%/releases/latest"
set "TEMP_JSON=%TEMP_DIR%\release_%RANDOM%.json"

:: Download release info
powershell -Command "try { Invoke-WebRequest -Uri '%API_URL%' -OutFile '%TEMP_JSON%' -UserAgent 'Mozilla/5.0' -TimeoutSec 30; Write-Host 'API_SUCCESS' } catch { Write-Host 'API_FAILED' }"

if not exist "%TEMP_JSON%" (
    echo Failed to get release info for %APP_NAME%
    echo [%date% %time%] Failed to get %APP_NAME% release info >> "%LOG_FILE%"
    endlocal
    exit /b 1
)

:: Parse JSON to get version and download URL
for /f "delims=" %%i in ('powershell -Command "try { $json = Get-Content '%TEMP_JSON%' | ConvertFrom-Json; $version = $json.tag_name; if ($version -notmatch '^v') { $version = 'v' + $version }; Write-Output $version } catch { Write-Output 'ERROR' }"') do set "VERSION=%%i"

if "%VERSION%"=="ERROR" (
    echo Failed to parse version for %APP_NAME%
    del "%TEMP_JSON%" 2>nul
    endlocal
    exit /b 1
)

echo Found version: %VERSION%

:: Build filename
set "VERSION_CLEAN=%VERSION:v=%"
set "FILENAME=%FILE_PATTERN%"

if "%APP_NAME%"=="NoteGen" (
    set "FILENAME=!FILENAME:{version_clean}=%VERSION_CLEAN%!"
    set "TAG=%VERSION%"
) else (
    set "FILENAME=!FILENAME:{version}=%VERSION_CLEAN%!"
    set "TAG=%VERSION%"
)

:: Special handling for NoteGen tag format
if "%APP_NAME%"=="NoteGen" set "TAG=note-gen-%VERSION%"

:: Build download URL
set "DOWNLOAD_URL=https://github.com/%REPO%/releases/download/%TAG%/!FILENAME!"
set "LOCAL_FILE=%DOWNLOAD_DIR%\!FILENAME!"

echo Downloading: !FILENAME!
echo URL: !DOWNLOAD_URL!

:: Download file
powershell -Command "& {$ProgressPreference = 'Continue'; try { Write-Host 'Starting download...'; Invoke-WebRequest -Uri '!DOWNLOAD_URL!' -OutFile '!LOCAL_FILE!' -UserAgent 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36' -TimeoutSec 300; Write-Host 'Download completed' } catch { Write-Host 'Download failed:' $_.Exception.Message; exit 1 }}"

if errorlevel 1 (
    echo Download failed for %APP_NAME%!
    echo [%date% %time%] %APP_NAME% download failed >> "%LOG_FILE%"
    del "%TEMP_JSON%" 2>nul
    endlocal
    exit /b 1
)

:: Verify download
if not exist "!LOCAL_FILE!" (
    echo Downloaded file not found for %APP_NAME%!
    del "%TEMP_JSON%" 2>nul
    endlocal
    exit /b 1
)

for %%F in ("!LOCAL_FILE!") do set "FILESIZE=%%~zF"
if !FILESIZE! lss 1000000 (
    echo Downloaded file too small for %APP_NAME% (!FILESIZE! bytes^)
    del "%TEMP_JSON%" 2>nul
    endlocal
    exit /b 1
)

echo Download successful! Size: !FILESIZE! bytes
echo [%date% %time%] %APP_NAME% downloaded successfully >> "%LOG_FILE%"

:: Stop process
echo Stopping %APP_NAME% process...
taskkill /F /IM "%PROCESS_NAME%" >nul 2>&1
if errorlevel 1 (
    echo %APP_NAME% was not running
) else (
    echo %APP_NAME% process stopped
    timeout /t 2 >nul
)

:: Start installer
echo Starting %APP_NAME% installer...
start "" "!LOCAL_FILE!"
if errorlevel 1 (
    echo Failed to start %APP_NAME% installer
    del "%TEMP_JSON%" 2>nul
    endlocal
    exit /b 1
)

echo %APP_NAME% installer started successfully!
echo [%date% %time%] %APP_NAME% installer started >> "%LOG_FILE%"

:: Cleanup
del "%TEMP_JSON%" 2>nul

:: Wait before next app
timeout /t 3 >nul

endlocal
exit /b 0