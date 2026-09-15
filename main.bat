@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul
title Windows Technician Recovery Toolkit v2.0

:: =========================================================
:: WINDOWS TECHNICIAN RECOVERY TOOLKIT
:: Safe Recovery / Diagnostics Edition
:: =========================================================

:: ---------- ADMIN CHECK ----------
net session >nul 2>&1
if not "%errorlevel%"=="0" (
    cls
    echo.
    echo  ============================================================
    echo        WINDOWS TECHNICIAN RECOVERY TOOLKIT GEOTAMA
    echo  ============================================================
    echo.
    echo  [!] STATUS : Administrator privileges required.
    echo.
    echo  Klik kanan main.bat lalu pilih:
    echo  "Run as administrator"
    echo.
    pause
    exit /b
)

set "VERSION=2.0"
set "BACKUPROOT=%USERPROFILE%\Desktop\WindowsBackup"

:MAIN
cls
call :HEADER

echo.
echo  SYSTEM STATUS
echo  ------------------------------------------------------------
echo  [OK] Administrator     : YES
echo  [OK] Computer          : %COMPUTERNAME%
echo  [OK] User              : %USERNAME%
echo  [OK] Windows Drive     : %SystemDrive%
echo.
echo  TOOLS
echo  ------------------------------------------------------------
echo.
echo   [01]  Detect Windows Partition
echo   [02]  CHKDSK - Disk Health Scan
echo   [03]  SFC - System File Repair
echo   [04]  DISM - Windows Image Repair
echo.
echo   [05]  Local Administrator Manager
echo   [06]  Built-in Administrator
echo   [07]  Password Recovery Assistant
echo.
echo   [08]  Backup User Data
echo   [09]  System Information
echo.
echo   [10]  Windows Recovery Environment
echo   [11]  Restart Windows
echo.
echo   [Q]   Exit
echo.
echo  ------------------------------------------------------------
set /p "CHOICE=  Select option ^> "

if /i "%CHOICE%"=="1" goto DETECT
if /i "%CHOICE%"=="01" goto DETECT
if /i "%CHOICE%"=="2" goto CHKDSK
if /i "%CHOICE%"=="02" goto CHKDSK
if /i "%CHOICE%"=="3" goto SFC
if /i "%CHOICE%"=="03" goto SFC
if /i "%CHOICE%"=="4" goto DISM
if /i "%CHOICE%"=="04" goto DISM
if /i "%CHOICE%"=="5" goto LOCALADMIN
if /i "%CHOICE%"=="05" goto LOCALADMIN
if /i "%CHOICE%"=="6" goto BUILTINADMIN
if /i "%CHOICE%"=="06" goto BUILTINADMIN
if /i "%CHOICE%"=="7" goto PASSWORD
if /i "%CHOICE%"=="07" goto PASSWORD
if /i "%CHOICE%"=="8" goto BACKUP
if /i "%CHOICE%"=="08" goto BACKUP
if /i "%CHOICE%"=="9" goto SYSINFO
if /i "%CHOICE%"=="09" goto SYSINFO
if /i "%CHOICE%"=="10" goto RECOVERY
if /i "%CHOICE%"=="11" goto RESTART
if /i "%CHOICE%"=="q" goto EXIT

echo.
echo  [ERROR] Invalid option.
timeout /t 2 >nul
goto MAIN


:: =========================================================
:: HEADER
:: =========================================================
:HEADER
echo  ============================================================
echo       WINDOWS TECHNICIAN RECOVERY TOOLKIT v%VERSION%
echo       Diagnostics ^| Repair ^| Backup ^| Recovery
echo  ============================================================
exit /b


:: =========================================================
:: 01 - DETECT WINDOWS PARTITION
:: =========================================================
:DETECT
cls
call :HEADER

echo.
echo  [01] WINDOWS PARTITION DETECTOR
echo  ------------------------------------------------------------
echo.

set "FOUND="

for %%D in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%D:\Windows\System32\winload.exe" (
        echo  [OK] Windows installation found on %%D:
        set "FOUND=YES"
    )
)

if not defined FOUND (
    echo  [!] No Windows installation detected.
    echo.
    echo  Make sure the Windows drive is accessible.
)

echo.
pause
goto MAIN


:: =========================================================
:: 02 - CHKDSK
:: =========================================================
:CHKDSK
cls
call :HEADER

echo.
echo  [02] CHKDSK - DISK HEALTH SCAN
echo  ------------------------------------------------------------
echo.
echo  Enter drive letter without colon.
echo  Example: C
echo.

set "DRIVE="
set /p "DRIVE=  Drive ^> "

if "%DRIVE%"=="" goto MAIN

set "DRIVE=%DRIVE:~0,1%"

echo.
echo  [INFO] Scanning %DRIVE%: ...
echo.

chkdsk %DRIVE%: /scan

echo.
echo  ------------------------------------------------------------
echo  [DONE] Disk scan finished.
echo  ------------------------------------------------------------
pause
goto MAIN


:: =========================================================
:: 03 - SFC
:: =========================================================
:SFC
cls
call :HEADER

echo.
echo  [03] SYSTEM FILE CHECKER
echo  ------------------------------------------------------------
echo.
echo  SFC will scan protected Windows system files.
echo.
choice /c YN /n /m "  Start SFC scan? [Y/N]: "

if errorlevel 2 goto MAIN

echo.
echo  [INFO] Starting SFC...
echo.

sfc /scannow

echo.
echo  ------------------------------------------------------------
echo  [DONE] SFC process finished.
echo  ------------------------------------------------------------
pause
goto MAIN


:: =========================================================
:: 04 - DISM
:: =========================================================
:DISM
cls
call :HEADER

echo.
echo  [04] WINDOWS IMAGE REPAIR
echo  ------------------------------------------------------------
echo.
echo  DISM will repair the Windows component store.
echo.
choice /c YN /n /m "  Start DISM repair? [Y/N]: "

if errorlevel 2 goto MAIN

echo.
echo  [INFO] Running DISM...
echo.

DISM /Online /Cleanup-Image /RestoreHealth

echo.
echo  ------------------------------------------------------------
echo  [DONE] DISM process finished.
echo  ------------------------------------------------------------
pause
goto MAIN


:: =========================================================
:: 05 - LOCAL ADMINISTRATOR MANAGER
:: =========================================================
:LOCALADMIN
cls
call :HEADER

echo.
echo  [05] LOCAL ADMINISTRATOR MANAGER
echo  ------------------------------------------------------------
echo.
echo  Existing local accounts:
echo.

net user

echo.
echo  ------------------------------------------------------------
echo   [1] Create Local Administrator
echo   [2] Account Information
echo   [3] Back
echo  ------------------------------------------------------------
echo.

set "ADMCHOICE="
set /p "ADMCHOICE=  Select ^> "

if "%ADMCHOICE%"=="1" goto CREATEADMIN
if "%ADMCHOICE%"=="2" goto ACCOUNTINFO
if "%ADMCHOICE%"=="3" goto MAIN

goto LOCALADMIN


:CREATEADMIN
cls
call :HEADER

echo.
echo  [05.1] CREATE LOCAL ADMINISTRATOR
echo  ------------------------------------------------------------
echo.

set "NEWUSER="
set "NEWPASS="

set /p "NEWUSER=  Username ^> "
if "%NEWUSER%"=="" goto LOCALADMIN

set /p "NEWPASS=  Password ^> "
if "%NEWPASS%"=="" goto LOCALADMIN

echo.
echo  [INFO] Creating account...

net user "%NEWUSER%" "%NEWPASS%" /add

if errorlevel 1 (
    echo.
    echo  [ERROR] Failed to create account.
    pause
    goto LOCALADMIN
)

net localgroup Administrators "%NEWUSER%" /add

if errorlevel 1 (
    echo.
    echo  [ERROR] Account created, but administrator group failed.
    pause
    goto LOCALADMIN
)

echo.
echo  [OK] Local administrator created successfully.
echo.
pause
goto LOCALADMIN


:ACCOUNTINFO
cls
call :HEADER

echo.
echo  [05.2] ACCOUNT INFORMATION
echo  ------------------------------------------------------------
echo.

set "TARGETUSER="
set /p "TARGETUSER=  Username ^> "

if "%TARGETUSER%"=="" goto LOCALADMIN

echo.
net user "%TARGETUSER%"

echo.
pause
goto LOCALADMIN


:: =========================================================
:: 06 - BUILT-IN ADMINISTRATOR
:: =========================================================
:BUILTINADMIN
cls
call :HEADER

echo.
echo  [06] BUILT-IN ADMINISTRATOR
echo  ------------------------------------------------------------
echo.
echo  Current status:
echo.

net user Administrator | findstr /i "Account active"

echo.
echo   [1] Enable Administrator
echo   [2] Disable Administrator
echo   [3] Back
echo.

set "BADMIN="
set /p "BADMIN=  Select ^> "

if "%BADMIN%"=="1" (
    net user Administrator /active:yes
    echo.
    echo  [OK] Built-in Administrator enabled.
    pause
    goto MAIN
)

if "%BADMIN%"=="2" (
    net user Administrator /active:no
    echo.
    echo  [OK] Built-in Administrator disabled.
    pause
    goto MAIN
)

if "%BADMIN%"=="3" goto MAIN

goto BUILTINADMIN


:: =========================================================
:: 07 - PASSWORD RECOVERY ASSISTANT
:: =========================================================
:PASSWORD
cls
call :HEADER

echo.
echo  [07] PASSWORD RECOVERY ASSISTANT
echo  ------------------------------------------------------------
echo.
echo  This module helps diagnose Windows account recovery.
echo.
echo  [1] List Local Accounts
echo  [2] Check Account Status
echo  [3] Open Windows Recovery
echo  [4] Recovery Guide
echo  [5] Back
echo.

set "PASSCHOICE="
set /p "PASSCHOICE=  Select ^> "

if "%PASSCHOICE%"=="1" goto PASSLIST
if "%PASSCHOICE%"=="2" goto PASSSTATUS
if "%PASSCHOICE%"=="3" goto RECOVERY
if "%PASSCHOICE%"=="4" goto PASSGUIDE
if "%PASSCHOICE%"=="5" goto MAIN

goto PASSWORD


:PASSLIST
cls
call :HEADER

echo.
echo  [07.1] LOCAL ACCOUNTS
echo  ------------------------------------------------------------
echo.

net user

echo.
echo  [INFO] Microsoft accounts may not appear as normal local
echo         password accounts here.
echo.
pause
goto PASSWORD


:PASSSTATUS
cls
call :HEADER

echo.
echo  [07.2] ACCOUNT STATUS
echo  ------------------------------------------------------------
echo.

set "PASSUSER="
set /p "PASSUSER=  Username ^> "

if "%PASSUSER%"=="" goto PASSWORD

echo.
net user "%PASSUSER%"

echo.
pause
goto PASSWORD


:PASSGUIDE
cls
call :HEADER

echo.
echo  [07.4] PASSWORD RECOVERY GUIDE
echo  ------------------------------------------------------------
echo.
echo  LOCAL ACCOUNT
echo  - If you can sign in with an authorized Administrator,
echo    manage the account password through Windows account tools.
echo.
echo  MICROSOFT ACCOUNT
echo  - Use Microsoft's official account recovery process.
echo  - Verify your identity using the recovery methods available.
echo.
echo  CANNOT SIGN IN
echo  - Use Windows Recovery Environment.
echo  - Consider "Reset this PC" with "Keep my files" when needed.
echo.
echo  [!] This toolkit does not bypass Windows authentication.
echo      It is intended for authorized recovery and diagnostics.
echo.
pause
goto PASSWORD


:: =========================================================
:: 08 - BACKUP USER DATA
:: =========================================================
:BACKUP
cls
call :HEADER

echo.
echo  [08] USER DATA BACKUP
echo  ------------------------------------------------------------
echo.
echo  Destination:
echo  %BACKUPROOT%
echo.
echo  Folders:
echo  - Desktop
echo  - Documents
echo  - Downloads
echo  - Pictures
echo  - Videos
echo.

choice /c YN /n /m "  Start backup? [Y/N]: "

if errorlevel 2 goto MAIN

if not exist "%BACKUPROOT%" mkdir "%BACKUPROOT%"

echo.
echo  [INFO] Backing up Desktop...
robocopy "%USERPROFILE%\Desktop" "%BACKUPROOT%\Desktop" /E /R:1 /W:1 /NFL /NDL /NP

echo  [INFO] Backing up Documents...
robocopy "%USERPROFILE%\Documents" "%BACKUPROOT%\Documents" /E /R:1 /W:1 /NFL /NDL /NP

echo  [INFO] Backing up Downloads...
robocopy "%USERPROFILE%\Downloads" "%BACKUPROOT%\Downloads" /E /R:1 /W:1 /NFL /NDL /NP

echo  [INFO] Backing up Pictures...
robocopy "%USERPROFILE%\Pictures" "%BACKUPROOT%\Pictures" /E /R:1 /W:1 /NFL /NDL /NP

echo  [INFO] Backing up Videos...
robocopy "%USERPROFILE%\Videos" "%BACKUPROOT%\Videos" /E /R:1 /W:1 /NFL /NDL /NP

echo.
echo  ------------------------------------------------------------
echo  [OK] Backup completed.
echo  Location:
echo  %BACKUPROOT%
echo  ------------------------------------------------------------
pause
goto MAIN


:: =========================================================
:: 09 - SYSTEM INFORMATION
:: =========================================================
:SYSINFO
cls
call :HEADER

echo.
echo  [09] SYSTEM INFORMATION
echo  ------------------------------------------------------------
echo.

systeminfo

echo.
echo  ------------------------------------------------------------
pause
goto MAIN


:: =========================================================
:: 10 - WINDOWS RECOVERY
:: =========================================================
:RECOVERY
cls
call :HEADER

echo.
echo  [10] WINDOWS RECOVERY ENVIRONMENT
echo  ------------------------------------------------------------
echo.
echo  Windows will restart into Advanced Startup.
echo.
echo  Save your work before continuing.
echo.

choice /c YN /n /m "  Restart into Recovery? [Y/N]: "

if errorlevel 2 goto MAIN

shutdown /r /o /t 0
goto EXIT


:: =========================================================
:: 11 - RESTART
:: =========================================================
:RESTART
cls
call :HEADER

echo.
echo  [11] RESTART WINDOWS
echo  ------------------------------------------------------------
echo.
echo  Windows will restart in 5 seconds.
echo.

shutdown /r /t 5
goto EXIT


:: =========================================================
:: EXIT
:: =========================================================
:EXIT
echo.
echo  ============================================================
echo       WINDOWS TECHNICIAN RECOVERY TOOLKIT GEOTAMA
echo       Session closed.
echo  ============================================================
echo.
timeout /t 2 >nul
endlocal
exit /b
