@echo off
setlocal
chcp 65001 > nul
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\backup.ps1" %*

