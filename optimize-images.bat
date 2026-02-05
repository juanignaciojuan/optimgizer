@echo off
setlocal EnableExtensions

rem ==============================================================
rem optimize-images.bat (simple)
rem Double-click to create an "optimized" folder with optimized
rem copies of images from this folder and all subfolders.
rem
rem Requires: ffmpeg in PATH (https://ffmpeg.org/)
rem Formats:  JPG/JPEG, PNG, WEBP
rem Originals are never modified.
rem ==============================================================

cd /d "%~dp0"

where ffmpeg >nul 2>&1
if errorlevel 1 (
  echo ERROR: ffmpeg not found in PATH.
  echo Install ffmpeg, then run this again.
  echo.
  pause
  exit /b 1
)

set "PS1=%~dp0optimize-images.ps1"
if not exist "%PS1%" (
  echo ERROR: Missing PowerShell script: %PS1%
  echo Make sure optimize-images.ps1 is next to this .bat.
  echo.
  pause
  exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%PS1%"

echo.
pause
exit /b 0
