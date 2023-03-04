@ECHO OFF
COLOR F0
TITLE Preparation before Sysprep
SET SYSPREP=C:\Recovery\OEM\Sysprep.cmd
SET Setting=C:\Recovery\OEM\Menu\Settings.ini
SET OEMScripts=%SystemRoot%\Setup\Scripts\OOBE.cmd
SET ADDONOptional=C:\Recovery\OEM\Menu\AddOn
SET OEMOptional=C:\Recovery\OEM\Manufacturer

SETLOCAL EnableDelayedExpansion
PUSHD %TEMP%
SET DELETEADDON=REMOVED
SET DELETEOEM=REMOVED
if not exist %SYSPREP% (
if not exist %OEMScripts% goto ERROR
ECHO ************************************
ECHO Install Recovery Software. Please wait ...
ECHO ************************************
start /wait /min "Install Recovery Software" %OEMScripts%
)
:LOOPMENU
if not exist %ADDONOptional% goto OEMCONFIRMATION
CLS
ECHO ************************************
ECHO Add-On Options
ECHO ************************************
ECHO This package include the following
ECHO add-on in the Recovery menu:
ECHO - ESET Online Scanner
ECHO - Yamicsoft Windows 10 Manager
ECHO ************************************
CHOICE /C 12 /M "1=Install the add-on 2=Do not install the add-on"
IF ERRORLEVEL 2 SET DELETEADDON=Yes
IF ERRORLEVEL 1 SET DELETEADDON=No

:OEMCONFIRMATION
if not exist %OEMOptional% goto ALLCONFIRMATION
CLS
ECHO ************************************
ECHO OEM Updater Options
ECHO ************************************
ECHO This software can install 
ECHO current manufacturer information
ECHO ************************************
CHOICE /C 12 /M "1=Install the OEM 2=Do not install the OEM"
IF ERRORLEVEL 2 SET DELETEOEM=Yes
IF ERRORLEVEL 1 SET DELETEOEM=No

:ALLCONFIRMATION
CLS
ECHO ************************************
ECHO Confirmation
ECHO ************************************
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do     rem"') do (
  set "DEL=%%a"
)
IF %DELETEADDON%==REMOVED (
  call :chooseColor F0 "Delete AddOn"&call :chooseColor FF "sssssssssssssssss"&call :chooseColor FB "REMOVED"
echo.)
IF %DELETEADDON%==Yes (
  call :chooseColor F0 "Delete AddOn"&call :chooseColor FF "sssssssssssssssssssss"&call :chooseColor FC "Yes"
echo.)
IF %DELETEADDON%==No (
  call :chooseColor F0 "Delete AddOn"&call :chooseColor FF "ssssssssssssssssssssss"&call :chooseColor FA "No"
echo.)
IF %DELETEOEM%==REMOVED (
  call :chooseColor F0 "Delete OEM Updater"&call :chooseColor FF "sssssssssss"&call :chooseColor FB "REMOVED"
echo.)
IF %DELETEOEM%==Yes (
  call :chooseColor F0 "Delete OEM Updater"&call :chooseColor FF "sssssssssssssss"&call :chooseColor FC "Yes"
echo.)
IF %DELETEOEM%==No (
  call :chooseColor F0 "Delete OEM Updater"&call :chooseColor FF "ssssssssssssssss"&call :chooseColor FA "No"
echo.)
ECHO ************************************
CHOICE /C 12 /M "1=Confirm 2=Back to choice"
IF ERRORLEVEL 2 goto LOOPMENU
IF ERRORLEVEL 1 goto PHASEI

:PHASEI
CLS
if %DELETEADDON%==No goto PHASEII
IF %DELETEADDON%==REMOVED goto PHASEII
ECHO *************************************
ECHO Delete Add-On. Please wait ...
ECHO *************************************
if exist %ADDONOptional% RD /S /Q %ADDONOptional%
if exist %Setting% powershell -Command "(gc %Setting%) -replace 'AddOn=1', 'AddOn=0' | Out-File -encoding Unicode %Setting%"

:PHASEII
CLS
if %DELETEOEM%==No goto INSTALL
IF %DELETEOEM%==REMOVED goto INSTALL
ECHO *************************************
ECHO Delete OEM Updater. Please wait ...
ECHO *************************************
if exist %OEMOptional% RD /S /Q %OEMOptional%

:INSTALL
if exist "%SYSPREP%" start "Sysprep" "%SYSPREP%"
exit

:ERROR
CLS
ECHO ************************************
ECHO Installation problem...
ECHO Check if you use the
ECHO ************************************
ECHO Press any key to exit.
pause>nul
exit

:chooseColor
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1i
goto :EOF
