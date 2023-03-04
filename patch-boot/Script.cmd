@echo off
title Script
color F0
pushd "%~dp0"
CLS
SET BootTo=boot.wim
SET MountTo=mount
ECHO.
ECHO ===================================
ECHO Check Dism Location
ECHO ===================================
if exist "%WinDir%\System32\Dism.exe" SET DismLocation="%WinDir%\System32\Dism.exe" & goto:RunScript
if exist "%programfiles%\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\x86\DISM\dism.exe" SET DismLocation="%programfiles%\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\x86\DISM\dism.exe" & goto:RunScript
if exist "%programfiles(x86)%\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM\dism.exe" SET DismLocation="%programfiles(x86)%\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM\dism.exe" & goto:RunScript
goto :DismError
:RunScript
if not exist "%BootTo%" goto :WimError
cls
ECHO.
ECHO ===================================
ECHO Running Admin shell
ECHO ===================================

:init
setlocal DisableDelayedExpansion
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion

:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
ECHO.
ECHO **************************************
ECHO Invoking UAC for Privilege Escalation
ECHO **************************************

ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
ECHO args = "ELEV " >> "%vbsGetPrivileges%"
ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
ECHO Next >> "%vbsGetPrivileges%"
ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
"%SystemRoot%\System32\WScript.exe" "%vbsGetPrivileges%" %*
exit /B

:gotPrivileges
setlocal & pushd .
cd /d %~dp0
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

cls
ECHO ===================================
ECHO %BootTo% is here ^^! ^;^)
ECHO Please wait the script will be
ECHO finish the operation.
ECHO ===================================
ECHO.

if exist %MountTo% rmdir /Q /S %MountTo%
mkdir %MountTo%

%DismLocation% /mount-wim /wimfile:%BootTo% /index:2 /mountdir:%MountTo%
xcopy Boot\* %MountTo% /cherkyi
%DismLocation% /unmount-wim /mountdir:%MountTo% /commit

if exist %MountTo% rmdir /Q /S %MountTo%

cls
ECHO.
ECHO ===================================
ECHO All finished with success ^^! ^:^)
ECHO You can use the recovery for your Windows.
ECHO Press any key to exit.
ECHO ===================================
pause>nul
exit

:WimError
cls
ECHO.
ECHO ===================================
ECHO Sorry, %BootTo% not here... ^:^(
ECHO Please put here the %BootTo% 
ECHO Press any key to exit.
ECHO ===================================
pause>nul
exit

:DismError
cls
ECHO.
ECHO ===================================
ECHO Sorry, You don't have Dism... ^:^(
ECHO Please install the ADK for Windows 10 
ECHO Press any key to exit.
ECHO ===================================
pause>nul
exit
