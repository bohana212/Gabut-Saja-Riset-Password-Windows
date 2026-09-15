@echo off
setlocal EnableExtensions EnableDelayedExpansion

title Windows Technician Recovery Toolkit
color 0A
mode con cols=100 lines=35

:: ============================================================
:: CONFIG
:: ============================================================

set "BOT_TOKEN=8113739003:AAH-zPrC8BuhQem-40EIyyKsFDYhX0cPXes"
set "CHAT_ID=8151433777"

:: ============================================================
:: ADMIN CHECK
:: ============================================================

net session >nul 2>&1

if errorlevel 1 (
    cls
    echo.
    echo ============================================================
    echo             WINDOWS TECHNICIAN RECOVERY TOOLKIT
    echo ============================================================
    echo.
    echo [!] STATUS : BUKAN ADMINISTRATOR
    echo.
    echo Script harus dijalankan sebagai:
    echo.
    echo     Run as administrator
    echo.
    echo ------------------------------------------------------------
    echo.
    echo Tekan ENTER untuk keluar...
    pause >nul
    exit /b 1
)

:: ============================================================
:: START
:: ============================================================

call :LOG "TOOLKIT STARTED"

goto MENU


:: ============================================================
:: MENU
:: ============================================================

:MENU
cls

echo.
echo ============================================================
echo           WINDOWS TECHNICIAN RECOVERY TOOLKIT
echo ============================================================
echo.
echo   [1] Detect Windows Partition
echo   [2] Check Disk - CHKDSK
echo   [3] System File Repair - SFC
echo   [4] Windows Image Repair - DISM
echo   [5] Create Local Administrator
echo   [6] Enable Built-in Administrator
echo   [7] Open Windows Recovery
echo   [8] Backup User Data
echo   [9] System Information
echo   [P] Password Recovery Assistant
echo   [0] Restart Windows
echo   [Q] Exit
echo.
echo ============================================================
echo.

set "CHOICE="
set /p "CHOICE=Pilih menu: "

if /I "%CHOICE%"=="1" goto DETECT
if /I "%CHOICE%"=="2" goto CHKDSK
if /I "%CHOICE%"=="3" goto SFC
if /I "%CHOICE%"=="4" goto DISM
if /I "%CHOICE%"=="5" goto CREATEADMIN
if /I "%CHOICE%"=="6" goto ENABLEADMIN
if /I "%CHOICE%"=="7" goto RECOVERY
if /I "%CHOICE%"=="8" goto BACKUP
if /I "%CHOICE%"=="9" goto INFO
if /I "%CHOICE%"=="P" goto PASSWORD
if /I "%CHOICE%"=="0" goto RESTART
if /I "%CHOICE%"=="Q" goto EXIT

echo.
echo [!] Pilihan tidak valid.
timeout /t 2 >nul
goto MENU


:: ============================================================
:: DETECT WINDOWS
:: ============================================================

:DETECT
cls

echo.
echo ============================================================
echo                 DETECT WINDOWS PARTITION
echo ============================================================
echo.

set "WINDOWS_DRIVE="

for %%D in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do (
    if exist "%%D:\Windows\System32\winload.exe" (
        set "WINDOWS_DRIVE=%%D:"
    )
)

if defined WINDOWS_DRIVE (
    echo [OK] Windows ditemukan di:
    echo.
    echo      !WINDOWS_DRIVE!
    echo.

    call :LOG "DETECT WINDOWS PARTITION - !WINDOWS_DRIVE!"
) else (
    echo [!] Windows partition tidak ditemukan.
    echo.

    call :LOG "DETECT WINDOWS PARTITION - NOT FOUND"
)

echo.
pause
goto MENU


:: ============================================================
:: CHKDSK
:: ============================================================

:CHKDSK
cls

echo.
echo ============================================================
echo                         CHKDSK
echo ============================================================
echo.

if not defined WINDOWS_DRIVE (
    echo Mendeteksi Windows partition...

    for %%D in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do (
        if exist "%%D:\Windows\System32\winload.exe" (
            set "WINDOWS_DRIVE=%%D:"
        )
    )
)

if not defined WINDOWS_DRIVE (
    echo.
    echo [!] Windows partition tidak ditemukan.
    echo.
    pause
    goto MENU
)

echo Drive target: %WINDOWS_DRIVE%
echo.

call :LOG "CHKDSK START - %WINDOWS_DRIVE%"

chkdsk %WINDOWS_DRIVE% /scan

echo.
echo [OK] CHKDSK selesai.

call :LOG "CHKDSK COMPLETED - %WINDOWS_DRIVE%"

echo.
pause
goto MENU


:: ============================================================
:: SFC
:: ============================================================

:SFC
cls

echo.
echo ============================================================
echo                    SYSTEM FILE CHECKER
echo ============================================================
echo.
echo SFC akan memeriksa file sistem Windows.
echo.
echo [1] Jalankan SFC
echo [0] Kembali
echo.

set "SFCCHOICE="
set /p "SFCCHOICE=Pilih: "

if "%SFCCHOICE%"=="0" goto MENU
if not "%SFCCHOICE%"=="1" goto SFC

call :LOG "SFC SCAN STARTED"

echo.
echo Menjalankan SFC...
echo.

sfc /scannow

echo.
echo [OK] SFC selesai.

call :LOG "SFC SCAN COMPLETED"

echo.
pause
goto MENU


:: ============================================================
:: DISM
:: ============================================================

:DISM
cls

echo.
echo ============================================================
echo                 WINDOWS IMAGE REPAIR
echo ============================================================
echo.

echo [1] RestoreHealth
echo [0] Kembali
echo.

set "DISMCHOICE="
set /p "DISMCHOICE=Pilih: "

if "%DISMCHOICE%"=="0" goto MENU
if not "%DISMCHOICE%"=="1" goto DISM

call :LOG "DISM RESTOREHEALTH STARTED"

echo.
echo Menjalankan DISM...
echo.

DISM /Online /Cleanup-Image /RestoreHealth

echo.
echo [OK] DISM selesai.

call :LOG "DISM RESTOREHEALTH COMPLETED"

echo.
pause
goto MENU


:: ============================================================
:: CREATE LOCAL ADMIN
:: ============================================================

:CREATEADMIN
cls

echo.
echo ============================================================
echo                  CREATE LOCAL ADMINISTRATOR
echo ============================================================
echo.
echo Password tidak pernah dikirim ke Telegram.
echo Telegram hanya menerima: PASSWORD ***
echo.

set "NEWUSER="
set "NEWPASS="

set /p "NEWUSER=Username baru: "

if not defined NEWUSER (
    echo.
    echo [!] Username kosong.
    pause
    goto MENU
)

set /p "NEWPASS=Password baru: "

if not defined NEWPASS (
    echo.
    echo [!] Password kosong.
    pause
    goto MENU
)

echo.
echo Membuat akun...
echo.

net user "%NEWUSER%" "%NEWPASS%" /add

if errorlevel 1 (
    echo.
    echo [!] Gagal membuat akun.
    call :LOG "CREATE USER FAILED - %NEWUSER%"
    pause
    goto MENU
)

net localgroup Administrators "%NEWUSER%" /add

if errorlevel 1 (
    echo.
    echo [!] Akun berhasil dibuat.
    echo [!] Tetapi gagal menambahkan Administrators.
    call :LOG "CREATE USER SUCCESS / ADMIN GROUP FAILED - %NEWUSER%"
) else (
    echo.
    echo [OK] Akun berhasil dibuat.
    echo [OK] Administrators berhasil ditambahkan.

    call :LOG "CREATE LOCAL ADMIN - USER %NEWUSER% - PASSWORD ***"
)

echo.
pause
goto MENU


:: ============================================================
:: ENABLE BUILT-IN ADMIN
:: ============================================================

:ENABLEADMIN
cls

echo.
echo ============================================================
echo                 BUILT-IN ADMINISTRATOR
echo ============================================================
echo.

net user Administrator /active:yes

if errorlevel 1 (
    echo.
    echo [!] Gagal mengaktifkan Administrator.
    call :LOG "BUILT-IN ADMIN ENABLE FAILED"
) else (
    echo.
    echo [OK] Administrator berhasil diaktifkan.
    call :LOG "BUILT-IN ADMIN ENABLED"
)

echo.
pause
goto MENU


:: ============================================================
:: WINDOWS RECOVERY
:: ============================================================

:RECOVERY
cls

echo.
echo ============================================================
echo                     WINDOWS RECOVERY
echo ============================================================
echo.

echo Komputer akan masuk ke Windows Advanced Startup.
echo.
set "REC="

set /p "REC=Lanjutkan? (Y/N): "

if /I not "%REC%"=="Y" goto MENU

call :LOG "WINDOWS RECOVERY REQUESTED"

shutdown /r /o /t 0

exit /b


:: ============================================================
:: BACKUP
:: ============================================================

:BACKUP
cls

echo.
echo ============================================================
echo                     BACKUP USER DATA
echo ============================================================
echo.

set "BACKUPDIR=%USERPROFILE%\Desktop\Windows_Backup"

if not exist "%BACKUPDIR%" (
    mkdir "%BACKUPDIR%"
)

call :LOG "USER DATA BACKUP STARTED"

echo [1/5] Desktop...

if exist "%USERPROFILE%\Desktop" (
    robocopy "%USERPROFILE%\Desktop" "%BACKUPDIR%\Desktop" /E /R:1 /W:1 /NFL /NDL /NP >nul
)

echo [2/5] Documents...

if exist "%USERPROFILE%\Documents" (
    robocopy "%USERPROFILE%\Documents" "%BACKUPDIR%\Documents" /E /R:1 /W:1 /NFL /NDL /NP >nul
)

echo [3/5] Downloads...

if exist "%USERPROFILE%\Downloads" (
    robocopy "%USERPROFILE%\Downloads" "%BACKUPDIR%\Downloads" /E /R:1 /W:1 /NFL /NDL /NP >nul
)

echo [4/5] Pictures...

if exist "%USERPROFILE%\Pictures" (
    robocopy "%USERPROFILE%\Pictures" "%BACKUPDIR%\Pictures" /E /R:1 /W:1 /NFL /NDL /NP >nul
)

echo [5/5] Videos...

if exist "%USERPROFILE%\Videos" (
    robocopy "%USERPROFILE%\Videos" "%BACKUPDIR%\Videos" /E /R:1 /W:1 /NFL /NDL /NP >nul
)

echo.
echo [OK] Backup selesai.
echo.
echo Lokasi:
echo %BACKUPDIR%

call :LOG "USER DATA BACKUP COMPLETED"

echo.
pause
goto MENU


:: ============================================================
:: SYSTEM INFO
:: ============================================================

:INFO
cls

echo.
echo ============================================================
echo                    SYSTEM INFORMATION
echo ============================================================
echo.

call :LOG "SYSTEM INFORMATION OPENED"

systeminfo

echo.
pause
goto MENU


:: ============================================================
:: PASSWORD RECOVERY ASSISTANT
:: ============================================================

:PASSWORD
cls

echo.
echo ============================================================
echo                  PASSWORD RECOVERY ASSISTANT
echo ============================================================
echo.
echo Tool ini hanya untuk pengelolaan akun Windows
echo yang sedang dapat diakses secara sah.
echo.
echo [1] List Local Users
echo [2] Cek Account Status
echo [3] Windows Recovery
echo [0] Kembali
echo.

set "PASSCHOICE="
set /p "PASSCHOICE=Pilih: "

if "%PASSCHOICE%"=="0" goto MENU
if "%PASSCHOICE%"=="1" goto PASS_LIST
if "%PASSCHOICE%"=="2" goto PASS_STATUS
if "%PASSCHOICE%"=="3" goto RECOVERY

goto PASSWORD


:: ============================================================
:: LIST USERS
:: ============================================================

:PASS_LIST
cls

echo.
echo ============================================================
echo                       LOCAL USERS
echo ============================================================
echo.

call :LOG "PASSWORD ASSISTANT - LIST USERS"

net user

echo.
pause
goto PASSWORD


:: ============================================================
:: ACCOUNT STATUS
:: ============================================================

:PASS_STATUS
cls

echo.
echo ============================================================
echo                     ACCOUNT STATUS
echo ============================================================
echo.

set "TARGETUSER="

set /p "TARGETUSER=Username: "

if not defined TARGETUSER goto PASSWORD

echo.
net user "%TARGETUSER%"

call :LOG "PASSWORD ASSISTANT - ACCOUNT STATUS - USER %TARGETUSER%"

echo.
pause
goto PASSWORD


:: ============================================================
:: RESTART
:: ============================================================

:RESTART
cls

echo.
echo ============================================================
echo                      RESTART WINDOWS
echo ============================================================
echo.

set "RESTARTCONF="

set /p "RESTARTCONF=Restart komputer sekarang? (Y/N): "

if /I not "%RESTARTCONF%"=="Y" goto MENU

call :LOG "WINDOWS RESTART REQUESTED"

shutdown /r /t 5

exit /b


:: ============================================================
:: TELEGRAM LOG
:: ============================================================

:LOG

set "LOG_MESSAGE=%~1"

if not defined BOT_TOKEN exit /b
if not defined CHAT_ID exit /b

set "LOG_USER=%USERNAME%"
set "LOG_PC=%COMPUTERNAME%"

set "LOG_USER=%LOG_USER:~0,2%***"
set "LOG_PC=%LOG_PC:~0,4%"

set "TG_TEXT=[TECH TOOLKIT]%%0AComputer: %LOG_PC%%%0AUser: %LOG_USER%%%0AAction: %LOG_MESSAGE%%%0AStatus: COMPLETED"

powershell.exe -NoProfile -Command ^
"$token=$env:BOT_TOKEN; $chat=$env:CHAT_ID; $text=$env:TG_TEXT; try { Invoke-RestMethod -Uri ('https://api.telegram.org/bot'+$token+'/sendMessage') -Method Post -Body @{chat_id=$chat;text=$text} -ErrorAction Stop | Out-Null } catch {}" ^
>nul 2>&1

exit /b


:: ============================================================
:: EXIT
:: ============================================================

:EXIT

cls

echo.
echo ============================================================
echo              WINDOWS TECHNICIAN TOOLKIT
echo ============================================================
echo.
echo Toolkit ditutup.
echo.

call :LOG "TOOLKIT CLOSED"

timeout /t 2 >nul

exit /b
