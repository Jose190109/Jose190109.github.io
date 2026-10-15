@echo off
title Preview Portofolio Jose Amando Tarigan
chcp 65001 > nul
cls
echo ============================================================
echo   MENJALANKAN PREVIEW PORTOFOLIO LOKAL
echo ============================================================
echo.
echo Membuka browser pada http://localhost:8000 ...
start http://localhost:8000
echo.
echo Server aktif! Tekan Ctrl+C di terminal ini jika ingin menutup server.
echo.
python -m http.server 8000

