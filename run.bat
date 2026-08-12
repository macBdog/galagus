@echo off
setlocal EnableExtensions

cd /d "%~dp0"

set "ENGINE="
if exist "..\game\bazel-bin\game.exe" set "ENGINE=..\game\bazel-bin\game.exe"
if not defined ENGINE if exist "..\game\game.exe" set "ENGINE=..\game\game.exe"

if not defined ENGINE (
  echo Engine binary not found. Looked for:
  echo   ..\game\bazel-bin\game.exe
  echo   ..\game\game.exe
  exit /b 1
)

if not exist "game.json" (
  echo Missing boot config: "%~dp0game.json"
  exit /b 1
)

echo Starting Galagus with "%ENGINE%"
"%ENGINE%" "%~dp0game.json"
exit /b %ERRORLEVEL%
