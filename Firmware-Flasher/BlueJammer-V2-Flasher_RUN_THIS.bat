@echo off
title BW16 BlueJammer-V2 Flasher

echo  ============================================
echo   BW16 BlueJammer-V2 Flasher  -  by @emensta
echo  ============================================
echo.

echo Available COM ports:
for /f "tokens=3 delims= " %%a in ('reg query "HKEY_LOCAL_MACHINE\HARDWARE\DEVICEMAP\SERIALCOMM"') do (
    echo %%a
)
echo.

set /p com_port=Enter COM port (e.g. COM4): 

echo.
echo Put BW16 in download mode:
echo   1. Hold BURN button
echo   2. Press and release RST
echo   3. Release BURN
echo.
pause

echo Flashing BW16 on %com_port%...
amebatool.exe . %com_port% --verbose=5

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Flash failed. Check COM port and download mode.
) else (
    echo.
    echo [OK] Flash complete. Press RST to boot.
)

pause