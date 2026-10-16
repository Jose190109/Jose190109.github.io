# ===================================================================
# Sistem Backup Data Portofolio Jose Amando Tarigan
# ===================================================================
param(
    [string]$Mode = ""
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Sistem Backup Data Portofolio - Jose Amando Tarigan"

Write-Host "===================================================================" -ForegroundColor Cyan
Write-Host "     🛡️  SISTEM BACKUP DATA OTOMATIS & AMAN (OFFLINE & REPO)        " -ForegroundColor Cyan
Write-Host "              Portofolio Resmi Jose Amando Tarigan                " -ForegroundColor Cyan
Write-Host "===================================================================" -ForegroundColor Cyan
Write-Host ""

$rootDir = Split-Path -Parent $PSScriptRoot
if (-not $rootDir) { $rootDir = Get-Location }

$backupDir = Join-Path $rootDir "_backups"
if (-not (Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    Write-Host "[INFO] Folder '$backupDir' berhasil disiapkan." -ForegroundColor Gray
}

$timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
$zipName = "backup_portofolio_$timestamp.zip"
$bundleName = "git_bundle_$timestamp.bundle"
$zipPath = Join-Path $backupDir $zipName
$bundlePath = Join-Path $backupDir $bundleName

if ([string]::IsNullOrWhiteSpace($Mode)) {
    Write-Host "Pilihan Mode Backup:" -ForegroundColor Yellow
    Write-Host "  [1] Backup Cepat (Arsip ZIP: Kode HTML, CSS, JS, Gambar & Aset)"
    Write-Host "  [2] Backup Komprehensif (Arsip ZIP + Git Bundle Riwayat Commit)"
    Write-Host "  [3] Batalkan"
    Write-Host ""
    $selected = Read-Host "Pilih mode (1/2/3) [Default: 2]"
    if ([string]::IsNullOrWhiteSpace($selected)) {
        $Mode = "2"
    } else {
        $Mode = $selected.Trim()
    }
}

if ($Mode -eq "3") {
    Write-Host "`nOperasi backup dibatalkan oleh pengguna." -ForegroundColor Yellow
    exit 0
}

Write-Host "`n-------------------------------------------------------------------" -ForegroundColor DarkGray
Write-Host "[1/3] Mengompresi berkas website..." -ForegroundColor Green
Write-Host "      Target: _backups\$zipName" -ForegroundColor Gray

# Dapatkan item yang akan diarsip (kecualikan _backups, backups, .git)
$itemsToZip = Get-ChildItem -Path $rootDir -Exclude "_backups", "backups", ".git" | ForEach-Object { $_.FullName }

try {
    Compress-Archive -Path $itemsToZip -DestinationPath $zipPath -Force
    $fileInfo = Get-Item $zipPath
    $sizeKb = [math]::Round($fileInfo.Length / 1KB, 2)
    Write-Host "      [OK] Arsip ZIP berhasil dibuat ($sizeKb KB)" -ForegroundColor Green
} catch {
    Write-Host "      [ERROR] Gagal membuat file ZIP: $_" -ForegroundColor Red
    exit 1
}

if ($Mode -eq "2") {
    Write-Host "`n[2/3] Menyimpan snapshot Git Bundle riwayat commit..." -ForegroundColor Green
    Push-Location $rootDir
    try {
        $gitCheck = git status 2>&1
        if ($LASTEXITCODE -eq 0) {
            git bundle create "$bundlePath" --all | Out-Null
            if (Test-Path $bundlePath) {
                $bInfo = Get-Item $bundlePath
                $bSize = [math]::Round($bInfo.Length / 1KB, 2)
                Write-Host "      [OK] Git Bundle berhasil dibuat ($bSize KB): _backups\$bundleName" -ForegroundColor Green
            } else {
                Write-Host "      [INFO] Git bundle tidak dibuat (belum ada commit)." -ForegroundColor Gray
            }
        } else {
            Write-Host "      [INFO] Git belum diinisialisasi, bundle dilewati." -ForegroundColor Gray
        }
    } finally {
        Pop-Location
    }
} else {
    Write-Host "`n[2/3] Pembuatan Git bundle dilewati sesuai pilihan." -ForegroundColor Gray
}

Write-Host "`n[3/3] Memeriksa integritas berkas backup..." -ForegroundColor Green

if (Test-Path $zipPath) {
    Write-Host "`n===================================================================" -ForegroundColor Cyan
    Write-Host "  ✅ BACKUP DATA BERHASIL DILAKUKAN!" -ForegroundColor Cyan
    Write-Host "===================================================================" -ForegroundColor Cyan
    Write-Host "  Lokasi Folder   : $backupDir"
    Write-Host "  File Cadangan   : $zipName"
    if (Test-Path $bundlePath) {
        Write-Host "  Git Bundle      : $bundleName"
    }
    Write-Host ""
    Write-Host "  Catatan Keamanan:" -ForegroundColor Yellow
    Write-Host "  - Salin file di folder '_backups' ke USB/Flashdisk atau cloud pribadi."
    Write-Host "  - Folder '_backups' dilindungi oleh .gitignore agar tidak terunggah publik."
    Write-Host "===================================================================" -ForegroundColor Cyan
}

if ([string]::IsNullOrWhiteSpace($Mode)) {
    Write-Host ""
    Read-Host "Tekan Enter untuk menutup jendela ini..."
}
