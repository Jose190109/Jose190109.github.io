@echo off
title Upload Portofolio ke GitHub Pages
chcp 65001 > nul
cls
echo ============================================================
echo   UNGGAH PORTOFOLIO JOSE AMANDO TARIGAN KE GITHUB PAGES
echo ============================================================
echo.
echo Akun GitHub : Jose190109
echo Email       : josetarigan29@gmail.com
echo Target URL  : https://jose190109.github.io/
echo.
echo Langkah mudah jika belum membuat repo di GitHub:
echo 1. Buka https://github.com/new
echo 2. Beri nama repositori: Jose190109.github.io
echo 3. Pilih "Public", jangan centang Add README (karena file sudah ada)
echo 4. Klik "Create repository"
echo.
echo Tekan sembarang tombol untuk mulai mengunggah...
pause > nul
echo.
echo [1/3] Menyiapkan file...
git add .
git commit -m "Update Portofolio Jose Amando Tarigan" 2>nul
echo [2/3] Mengatur branch main...
git branch -M main
echo [3/3] Mengunggah (push) ke GitHub...
git push -u origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ============================================================
    echo   BERHASIL! Website portofolio Anda sedang dipublikasikan.
    echo   Tunggu 1-2 menit lalu akses di:
    echo   https://jose190109.github.io/
    echo ============================================================
) else (
    echo.
    echo ============================================================
    echo   Catatan: Jika diminta login GitHub, silakan selesaikan login
    echo   di jendela browser yang muncul atau masukkan Personal Access Token.
    echo ============================================================
)
echo.
pause
