@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Windows Technician Recovery Toolkit
color 0A

:: ========================================================
:: WINDOWS TECHNICIAN RECOVERY TOOLKIT
:: Untuk maintenance/recovery Windows yang berizin
:: ========================================================

:: Cek Administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    cls
    echo ========================================================
    echo   TOOL INI HARUS DIJALANKAN SEBAGAI ADMINISTRATOR
    echo ========================================================
    echo.
    echo Klik kanan file ^> Run as administrator
    echo.
    pause
    exit /b
)

:MENU
cls
echo.
echo ========================================================
echo       WINDOWS TECHNICIAN RECOVERY TOOLKIT
echo ========================================================
echo.
echo  [1] Detect Windows Partition
echo  [2] Check Disk - CHKDSK
echo  [3] System File Repair - SFC
echo  [4] Windows Image Repair - DISM
echo  [5] Create Local Administrator
echo  [6] Enable Built-in Administrator
echo  [7] Open Windows Recovery
echo  [8] Backup User Data
echo  [9] System Information
echo  [0] Restart Windows
echo  [Q] Exit
echo.
echo ========================================================
set /p "PILIH=Pilih menu: "

if /i "%PILIH%"=="1" goto DETECT
if /i "%PILIH%"=="2" goto CHKDSK
if /i "%PILIH%"=="3" goto SFC
if /i "%PILIH%"=="4" goto DISM
if /i "%PILIH%"=="5" goto CREATEADMIN
if /i "%PILIH%"=="6" goto ENABLEADMIN
if /i "%PILIH%"=="7" goto RECOVERY
if /i "%PILIH%"=="8" goto BACKUP
if /i "%PILIH%"=="9" goto INFO
if /i "%PILIH%"=="0" goto RESTART
if /i "%PILIH%"=="Q" goto EXIT

goto MENU


:: ========================================================
:: DETECT WINDOWS PARTITION
:: ========================================================
:DETECT
cls
echo ========================================================
echo                 WINDOWS PARTITION
echo ========================================================
echo.

echo [*] Daftar volume:
echo.
powershell -NoProfile -Command "Get-Volume | Where-Object {$_.DriveLetter} | Select DriveLetter,FileSystemLabel,FileSystem,@{N='SizeGB';E={[math]::Round($_.Size/1GB,2)}},@{N='FreeGB';E={[math]::Round($_.SizeRemaining/1GB,2)}} | Format-Table -AutoSize"

echo.
echo [*] Mencari instalasi Windows...
echo.

for %%D in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%D:\Windows\System32\winload.exe" (
        echo [FOUND] %%D:\Windows
    )
)

echo.
pause
goto MENU


:: ========================================================
:: CHKDSK
:: ========================================================
:CHKDSK
cls
echo ========================================================
echo                     CHKDSK
echo ========================================================
echo.
set "DRIVE="
set /p "DRIVE=Masukkan drive Windows ^(contoh C^): "

if not defined DRIVE goto MENU

echo.
echo [*] Menjalankan CHKDSK /scan pada %DRIVE%:
echo.

chkdsk %DRIVE%: /scan

echo.
pause
goto MENU


:: ========================================================
:: SFC
:: ========================================================
:SFC
cls
echo ========================================================
echo                SYSTEM FILE CHECKER
echo ========================================================
echo.
echo [*] Menjalankan SFC /SCANNOW...
echo.

sfc /scannow

echo.
pause
goto MENU


:: ========================================================
:: DISM
:: ========================================================
:DISM
cls
echo ========================================================
echo                  DISM REPAIR
echo ========================================================
echo.
echo [*] Menjalankan DISM /RestoreHealth...
echo.

DISM /Online /Cleanup-Image /RestoreHealth

echo.
pause
goto MENU


:: ========================================================
:: CREATE LOCAL ADMIN
:: ========================================================
:CREATEADMIN
cls
echo ========================================================
echo             CREATE LOCAL ADMINISTRATOR
echo ========================================================
echo.

set "NEWUSER="
set "NEWPASS="

set /p "NEWUSER=Username baru: "
if not defined NEWUSER goto MENU

set /p "NEWPASS=Password baru: "
if not defined NEWPASS goto MENU

echo.
echo [*] Membuat user...

net user "%NEWUSER%" "%NEWPASS%" /add

if errorlevel 1 (
    echo.
    echo [!] Gagal membuat user.
    pause
    goto MENU
)

echo.
echo [*] Menambahkan user ke Administrators...

net localgroup Administrators "%NEWUSER%" /add

if errorlevel 1 (
    echo.
    echo [!] User dibuat tetapi gagal masuk group Administrators.
) else (
    echo.
    echo [+] User berhasil dibuat.
    echo [+] User memiliki hak Administrator.
)

echo.
pause
goto MENU


:: ========================================================
:: ENABLE BUILT-IN ADMIN
:: ========================================================
:ENABLEADMIN
cls
echo ========================================================
echo             BUILT-IN ADMINISTRATOR
echo ========================================================
echo.

net user Administrator /active:yes

if errorlevel 1 (
    echo [!] Gagal mengaktifkan Administrator.
) else (
    echo [+] Akun Administrator bawaan berhasil diaktifkan.
)

echo.
pause
goto MENU


:: ========================================================
:: WINDOWS RECOVERY
:: ========================================================
:RECOVERY
cls
echo ========================================================
echo                WINDOWS RECOVERY
echo ========================================================
echo.
echo Windows akan restart menuju Advanced Startup.
echo.
choice /c YN /n /m "Lanjutkan? [Y/N]: "

if errorlevel 2 goto MENU

shutdown /r /o /t 0
exit /b


:: ========================================================
:: BACKUP USER DATA
:: ========================================================
:BACKUP
cls
echo ========================================================
echo                  BACKUP USER DATA
echo ========================================================
echo.
echo Contoh:
echo   Source : C:\Users\Nama
echo   Backup : D:\Backup
echo.

set "SRC="
set "DST="

set /p "SRC=Folder user yang akan dibackup: "

if not exist "%SRC%" (
    echo.
    echo [!] Folder tidak ditemukan.
    pause
    goto MENU
)

set /p "DST=Lokasi backup: "

if not defined DST goto MENU

mkdir "%DST%" >nul 2>&1

echo.
echo [*] Backup Desktop...
robocopy "%SRC%\Desktop" "%DST%\Desktop" /E /R:1 /W:1

echo.
echo [*] Backup Documents...
robocopy "%SRC%\Documents" "%DST%\Documents" /E /R:1 /W:1

echo.
echo [*] Backup Downloads...
robocopy "%SRC%\Downloads" "%DST%\Downloads" /E /R:1 /W:1

echo.
echo [*] Backup Pictures...
robocopy "%SRC%\Pictures" "%DST%\Pictures" /E /R:1 /W:1

echo.
echo [*] Backup Videos...
robocopy "%SRC%\Videos" "%DST%\Videos" /E /R:1 /W:1

echo.
echo ========================================================
echo                  BACKUP SELESAI
echo ========================================================
echo.
pause
goto MENU


:: ========================================================
:: SYSTEM INFORMATION
:: ========================================================
:INFO
cls
echo ========================================================
echo                SYSTEM INFORMATION
echo ========================================================
echo.

systeminfo

echo.
pause
goto MENU


:: ========================================================
:: RESTART
:: ========================================================
:RESTART
cls
echo.
echo Windows akan restart dalam 5 detik...
echo.
shutdown /r /t 5
exit /b


:: ========================================================
:: EXIT
:: ========================================================
:EXIT
cls
echo.
echo Windows Technician Recovery Toolkit ditutup.
echo.
exit /b
