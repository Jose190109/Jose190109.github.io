# 🛡️ Dokumentasi Sistem Keamanan, WAF, & Backup Data
**Website Portofolio Resmi Jose Amando Tarigan (`https://jose190109.github.io/`)**

Dokumen ini menjelaskan seluruh lapisan arsitektur keamanan, perlindungan WAF (*Web Application Firewall*), penegakan protokol HTTPS (SSL/TLS), serta sistem pencadangan (*backup & restore*) data yang telah dipasang pada website.

---

## 📑 Daftar Isi
1. [Arsitektur Keamanan Berlapis (Defense-in-Depth)](#1-arsitektur-keamanan-berlapis)
2. [Sistem HTTPS & Transport Security](#2-sistem-https--transport-security)
3. [Sistem WAF & Security Shield (Anti-XSS, Anti-Bot & Rate Limiting)](#3-sistem-waf--security-shield)
4. [Panduan Integrasi Cloudflare WAF (Opsional / Tingkat Lanjut)](#4-panduan-integrasi-cloudflare-waf)
5. [Sistem Pencadangan Data (Backup & Restore)](#5-sistem-pencadangan-data)
6. [Audit Otomatis & Cloud Backup di GitHub Actions](#6-audit-otomatis--cloud-backup-di-github-actions)

---

## 1. Arsitektur Keamanan Berlapis

Website ini mengadopsi prinsip **Defense-in-Depth** (Keamanan Berlapis Tiga Tingkat):

```
+-------------------------------------------------------------+
| TINGKAT 1: Jaringan & Edge CDN (GitHub Pages / Cloudflare)   |
| - Enforce HTTPS & SSL/TLS 256-bit                           |
| - Mitigasi DDoS bawaan GitHub Edge Fastly                   |
| - Cloudflare WAF (Web Application Firewall) & Bot Fight Mode|
+-------------------------------------------------------------+
                              |
                              v
+-------------------------------------------------------------+
| TINGKAT 2: HTTP Security Headers & Browser Hardening        |
| - Content Security Policy (CSP) + Upgrade Insecure Requests |
| - X-Content-Type-Options: nosniff                           |
| - X-Frame-Options: DENY (Anti-Clickjacking)                 |
| - Strict-Origin-When-Cross-Origin & Permissions-Policy      |
+-------------------------------------------------------------+
                              |
                              v
+-------------------------------------------------------------+
| TINGKAT 3: Client-Side Security Shield (script.js)          |
| - Automatic HTTPS Redirector                                |
| - Anti-Clickjacking Frame Buster                            |
| - Anti-XSS Sanitizer & Malicious Pattern Detector           |
| - Anti-Bot Honeypot Trap (Perangkap Spam Bot)               |
| - Client-Side Rate Limiter (Anti-Flooding Form)             |
+-------------------------------------------------------------+
```

---

## 2. Sistem HTTPS & Transport Security

### A. Fitur yang Telah Diaktifkan di Kode:
1. **`upgrade-insecure-requests`**: Dideklarasikan pada tag `<meta>` di `index.html`. Browser pengunjung secara otomatis mengonversi semua permintaan aset HTTP menjadi HTTPS tanpa peringatan *mixed content*.
2. **Auto HTTPS Redirector** (`script.js`):
   Jika ada pengunjung yang mengakses versi `http://`, skrip `SecurityShield.enforceHTTPS()` akan langsung mengalihkan halaman ke `https://` (dikecualikan pada *localhost* untuk kenyamanan pengembangan lokal).
3. **Permissions-Policy**: Membatasi akses peramban dari fitur berbahaya yang tidak dibutuhkan (kamera, mikrofon, geolokasi, usb).

### B. Cara Memastikan HTTPS Aktif di GitHub:
1. Buka repositori **`Jose190109.github.io`** di browser.
2. Klik tab **Settings** > menu **Pages** di sebelah kiri.
3. Pastikan centang **"Enforce HTTPS"** dalam keadaan aktif (bercentang hijau).
4. GitHub Pages akan otomatis menerbitkan dan memperbarui sertifikat SSL Let's Encrypt secara gratis.

---

## 3. Sistem WAF & Security Shield

Di sisi aplikasi web (*frontend application shield*), sistem keamanan aktif melindungi setiap interaksi:

### 1. Anti-XSS (Cross-Site Scripting) & Sanitasi Input
- Fungsi `SecurityShield.sanitize()` membersihkan input pengguna dari tag HTML, atribut event inline (`onclick`, `onerror`), dan skema URL berbahaya (`javascript:`).
- Fungsi `SecurityShield.detectThreat()` secara aktif memindai input pengguna dari tanda serangan XSS atau SQL Injection sebelum diteruskan ke WhatsApp atau Email.

### 2. Anti-Bot Honeypot Trap
- Di dalam formulir pesan cepat terdapat elemen tersembunyi (`#sec_hp_field`).
- Pengunjung manusia biasa tidak dapat melihat atau mengisi kolom ini.
- Robot/spammer otomatis (*crawlers*) biasanya mengisi seluruh kolom form. Jika kolom honeypot ini terisi, sistem seketika membatalkan pengiriman dan menandainya sebagai bot.

### 3. Client-Side Rate Limiting (Anti-Flooding / Spam)
- Mencegah *spamming* atau pengiriman tombol berulang-ulang secara beruntun.
- Maksimal **3 kali pengiriman per 60 detik**.
- Jika dilanggar, antarmuka akan menampilkan peringatan hitung mundur waktu tunggu.

### 4. Anti-Clickjacking (Frame Buster)
- Mencegah situs ditampilkan di dalam `<iframe>` milik situs asing untuk menghindari teknik penipuan *clickjacking*.

---

## 4. Panduan Integrasi Cloudflare WAF

Jika ingin menambahkan **WAF Kelas Enterprise** di level DNS secara gratis:
1. Daftarkan akun gratis di [Cloudflare.com](https://dash.cloudflare.com/).
2. Tambahkan domain Anda (jika memiliki domain kustom seperti `joseamando.com` atau domain gratis).
3. Di dashboard Cloudflare:
   - **Security > WAF**: Aktifkan **Cloudflare Managed Ruleset**.
   - **Security > Bots**: Aktifkan **Bot Fight Mode** (Menantang bot berbahaya dengan verifikasi otomatis).
   - **SSL/TLS**: Pilih mode **Full (Strict)**.
   - **SSL/TLS > Edge Certificates**: Aktifkan **Always Use HTTPS** dan **HTTP Strict Transport Security (HSTS)**.

---

## 5. Sistem Pencadangan Data

Tersedia utilitas lokal 1-klik untuk memastikan portofolio Anda dapat dicadangkan dan dipulihkan kapan saja secara offline.

### A. Cara Membuat Backup Data (`backup_data.bat`)
Cukup **klik dua kali** file `backup_data.bat` di folder proyek:
- **Mode 1 (Backup Cepat)**: Mengompresi seluruh file HTML, CSS, JavaScript, gambar, dan aset ke dalam berkas `.zip` berstempel waktu di folder `_backups/`.
- **Mode 2 (Backup Komprehensif - Direkomendasikan)**: Membuat arsip `.zip` sekaligus membuat snapshot **Git Bundle** (`.bundle`). Git bundle menyimpan **seluruh riwayat commit, branch, dan log** Anda secara offline bahkan tanpa internet.

> 🔒 **Keamanan Folder Backup**: Folder `_backups/` telah didaftarkan di `.gitignore` sehingga tidak akan pernah terunggah secara tidak sengaja ke repositori publik.

### B. Cara Memulihkan Data (`restore_data.bat`)
Jika Anda tidak sengaja menghapus atau merusak file proyek:
1. Klik dua kali file `restore_data.bat`.
2. Program akan menampilkan daftar cadangan ZIP yang tersedia.
3. Pilih nomor cadangan yang ingin diekstrak.
4. File cadangan akan diekstrak dengan aman ke folder `_restored_files/` (tidak akan langsung menimpa file aktif Anda tanpa konfirmasi).

---

## 6. Audit Otomatis & Cloud Backup di GitHub Actions

Setiap kali Anda mengunggah (*push*) kode ke GitHub, alur kerja otomatis `.github/workflows/security-and-backup.yml` akan berjalan:
1. **Audit Keamanan Otomatis**:
   - Memindai adanya URL http tidak aman (*mixed content*).
   - Memeriksa validitas dan sintaks kode JavaScript.
2. **Pencadangan Cloud Otomatis**:
   - Memaketkan seluruh repositori menjadi arsip backup cloud.
   - Menyimpan arsip di tab **Actions > Artifacts** selama 90 hari.
   - Berjalan terjadwal otomatis setiap hari Minggu.

---

### Ringkasan Berkas Keamanan:
| File | Fungsi |
| :--- | :--- |
| `index.html` | Memuat CSP, X-Frame-Options, Permissions-Policy, dan Honeypot |
| `script.js` | Modul `SecurityShield` (Auto HTTPS, Sanitasi XSS, Rate Limiter) |
| `style.css` | Tampilan lencana keamanan *HTTPS Enforced & XSS Protected* |
| `backup_data.bat` | Skrip 1-klik pencadangan data lokal & Git Bundle |
| `restore_data.bat` | Skrip 1-klik pemulihan data dari arsip cadangan |
| `scripts/backup.ps1` | Mesin kompresi backup PowerShell hemat memori |
| `scripts/restore.ps1` | Mesin pemulihan arsip PowerShell |
| `.gitignore` | Melindungi arsip lokal agar tidak bocor ke publik |
| `.github/workflows/security-and-backup.yml` | Otomasi audit keamanan & cloud backup mingguan |

