# ===================================================================
# Sistem Pemulihan (Restore) Data Portofolio Jose Amando Tarigan
# ===================================================================
param(
    [string]$Index = ""
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Sistem Restore Data Portofolio - Jose Amando Tarigan"

Write-Host "===================================================================" -ForegroundColor Cyan
Write-Host "             🔄 SISTEM PEMULIHAN (RESTORE) DATA PORTOFOLIO         " -ForegroundColor Cyan
Write-Host "                 Portofolio Resmi Jose Amando Tarigan              " -ForegroundColor Cyan
Write-Host "===================================================================" -ForegroundColor Cyan
Write-Host ""

$rootDir = Split-Path -Parent $PSScriptRoot
if (-not $rootDir) { $rootDir = Get-Location }

$backupDir = Join-Path $rootDir "_backups"

if (-not (Test-Path $backupDir)) {
    Write-Host "[ERROR] Folder cadangan '$backupDir' tidak ditemukan!" -ForegroundColor Red
    Write-Host "        Silakan jalankan 'backup_data.bat' terlebih dahulu."
    exit 1
}

$zipFiles = Get-ChildItem -Path $backupDir -Filter "*.zip" | Sort-Object LastWriteTime -Descending

if ($zipFiles.Count -eq 0) {
    Write-Host "[ERROR] Tidak ada file cadangan .zip yang ditemukan di '$backupDir'!" -ForegroundColor Red
    exit 1
}

Write-Host "Daftar Berkas Cadangan Tersedia:" -ForegroundColor Yellow
$i = 1
foreach ($f in $zipFiles) {
    $sizeKb = [math]::Round($f.Length / 1KB, 1)
    $dateStr = $f.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
    Write-Host "  [$i] $($f.Name) ($sizeKb KB) - $dateStr"
    $i++
}
Write-Host ""

if ([string]::IsNullOrWhiteSpace($Index)) {
    $sel = Read-Host "Pilih nomor cadangan yang ingin diekstrak [Default: 1]"
    if ([string]::IsNullOrWhiteSpace($sel)) {
        $Index = "1"
    } else {
        $Index = $sel.Trim()
    }
}

$chosenIdx = [int]$Index - 1
if ($chosenIdx -lt 0 -or $chosenIdx -ge $zipFiles.Count) {
    Write-Host "[ERROR] Nomor pilihan tidak valid!" -ForegroundColor Red
    exit 1
}

$targetZip = $zipFiles[$chosenIdx].FullName
$restoreDir = Join-Path $rootDir "_restored_files"

Write-Host "`n-------------------------------------------------------------------" -ForegroundColor DarkGray
Write-Host "[INFO] Mengekstrak: $($zipFiles[$chosenIdx].Name)" -ForegroundColor Green
Write-Host "       Target   : $restoreDir" -ForegroundColor Gray

try {
    if (-not (Test-Path $restoreDir)) {
        New-Item -ItemType Directory -Path $restoreDir -Force | Out-Null
    }
    Expand-Archive -Path $targetZip -DestinationPath $restoreDir -Force
    Write-Host "       [OK] Berhasil mengekstrak seluruh file!" -ForegroundColor Green
} catch {
    Write-Host "       [ERROR] Gagal mengekstrak arsip: $_" -ForegroundColor Red
    exit 1
}

Write-Host "`n===================================================================" -ForegroundColor Cyan
Write-Host "  ✅ PEMULIHAN BERHASIL SELESAI!" -ForegroundColor Cyan
Write-Host "===================================================================" -ForegroundColor Cyan
Write-Host "  File hasil pemulihan berada di: $restoreDir"
Write-Host "  Anda dapat memeriksa dan menyalin kembali file yang dibutuhkan."
Write-Host "===================================================================" -ForegroundColor Cyan
if ([string]::IsNullOrWhiteSpace($Index)) {
    Write-Host ""
    Read-Host "Tekan Enter untuk menutup jendela ini..."
}
