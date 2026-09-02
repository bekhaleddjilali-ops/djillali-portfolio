@echo off
setlocal
chcp 65001 >nul
cd /d "%~dp0"

echo ============================================
echo   Portfolio Update - push to GitHub/Netlify
echo ============================================
echo.

:: ----- 1) Sync latest files from Downloads -----
echo [1/4] Syncing latest files into netlify-deploy ...
copy /Y "C:\Users\PC\Downloads\index-magic-bento.html" "index.html" >nul
copy /Y "C:\Users\PC\Downloads\index-magic-bento.html" "index-magic-bento.html" >nul
copy /Y "C:\Users\PC\Downloads\contact.html" "contact.html" >nul
copy /Y "C:\Users\PC\Downloads\index-dzd.html" "index-dzd.html" >nul
echo        Done.
echo.

:: ----- 2) Stage all changes -----
echo [2/4] Staging changes ...
set GIT=C:\Program Files\Git\cmd\git.exe
"%GIT%" add -A >nul 2>&1
echo        Done.
echo.

:: ----- 3) Commit -----
echo [3/4] Committing ...
for /f "tokens=1-3 delims=/ " %%a in ("%date%") do set D=%%c-%%b-%%a
for /f "tokens=1-2 delims=: " %%a in ("%time%") do set T=%%a%%b
"%GIT%" commit -m "update %D% %T%" >nul 2>&1
echo        Done.
echo.

:: ----- 4) Push to GitHub -----
echo [4/4] Pushing to GitHub (this may open a login window the FIRST time)...
:: Make sure the remote is set (self-contained)
"%GIT%" remote remove origin >nul 2>&1
"%GIT%" remote add origin "https://github.com/bekhaleddjilali-ops/PORTFOLIO2.git" >nul 2>&1
"%GIT%" push origin master:main
echo.
if errorlevel 1 (
    echo.
    echo WARNING: push failed. Common causes:
    echo   - The GitHub repo "PORTFOLIO2" does not exist. Create it at github.com/bekhaleddjilali-ops.
    echo   - Wrong branch name (this script pushes to 'main', which Netlify deploys).
) else (
    echo ============================================
    echo   SUCCESS! Netlify is now updating your site.
    echo   Your permanent link: https://peppy-rabanadas-9843dc.netlify.app
    echo   Changes go live in about 1 minute.
    echo ============================================
)
echo.
pause