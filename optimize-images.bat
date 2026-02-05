@echo off
setlocal EnableExtensions EnableDelayedExpansion

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

set "FFMPEG=ffmpeg"
if exist "%~dp0ffmpeg.exe" set "FFMPEG=%~dp0ffmpeg.exe"

"%FFMPEG%" -version >nul 2>&1
if errorlevel 1 (
  echo ERROR: ffmpeg not found.
  echo Put ffmpeg.exe next to this .bat or add it to PATH.
  echo.
  pause
  exit /b 1
)

set "OUTROOT=%~dp0optimized"
if not exist "%OUTROOT%" mkdir "%OUTROOT%" >nul 2>&1

set /a SEEN=0
set /a DONE=0

for %%F in (*.jpg *.jpeg *.png *.webp) do (
  if exist "%%~fF" (
    set /a SEEN+=1
    set "IN=%%~fF"
    set "OUT=%OUTROOT%\%%~nxF"
    call :PROCESS_ONE "%%~fF" "!OUT!"
  )
)

echo.
echo Done. Seen: !SEEN!  Wrote: !DONE!

echo.
pause
exit /b 0

goto :eof

set "FFMPEG=ffmpeg"
if exist "%~dp0ffmpeg.exe" set "FFMPEG=%~dp0ffmpeg.exe"

"%FFMPEG%" -version >nul 2>&1
if errorlevel 1 (
  echo ERROR: ffmpeg not found.
  echo Put ffmpeg.exe next to this .bat or add it to PATH.
  echo.
  pause
  exit /b 1
)

set "OUTROOT=%~dp0optimized"
if not exist "%OUTROOT%" mkdir "%OUTROOT%" >nul 2>&1

set /a SEEN=0
set /a DONE=0

for %%F in (*.jpg *.jpeg *.png *.webp) do (
  if exist "%%~fF" (
    set /a SEEN+=1
    set "IN=%%~fF"
    set "OUT=%OUTROOT%\%%~nxF"
    call :PROCESS_ONE "%%~fF" "!OUT!"
  )
)

echo.
echo Done. Seen: !SEEN!  Wrote: !DONE!

echo.
pause
exit /b 0

goto :eof

:PROCESS_ONE
set "IN=%~1"
set "OUT=%~2"
set "EXT=%~x1"

if /i "%EXT%"==".png" (
  "%FFMPEG%" -hide_banner -loglevel error -y -i "%IN%" -map_metadata -1 -compression_level 9 "%OUT%" >nul 2>&1
) else if /i "%EXT%"==".webp" (
  "%FFMPEG%" -hide_banner -loglevel error -y -i "%IN%" -map_metadata -1 -c:v libwebp -q:v 80 -compression_level 6 -preset picture "%OUT%" >nul 2>&1
) else (
  "%FFMPEG%" -hide_banner -loglevel error -y -i "%IN%" -map_metadata -1 -q:v 3 "%OUT%" >nul 2>&1
)

if not errorlevel 1 if exist "%OUT%" (
  set /a DONE+=1
  echo WROTE: %~nx1 ^> "%OUT%"
) else (
  echo FAIL: %~nx1
)
goto :eof
