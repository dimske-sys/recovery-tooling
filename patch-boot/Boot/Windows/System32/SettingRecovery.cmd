@echo off
SetLocal EnableDelayedExpansion

FOR %%i IN (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO IF EXIST %%i:\efi.xml IF EXIST %%i:\mbr.xml SET install=%%i:

IF DEFINED install GOTO :InstallRecovery
IF NOT DEFINED install GOTO :ExitWithERROR

:InstallRecovery
wpeutil UpdateBootInfo
for /f "tokens=2* delims=	 " %%A in ('reg query HKLM\System\CurrentControlSet\Control /v PEFirmwareType') DO SET Firmware=%%B
if !Firmware!==0x1 set UEFI=0
if !Firmware!==0x2 set UEFI=1

if !UEFI! EQU 1 ( 
%install%\setup.exe /unattend:%install%\efi.xml /m:%install%\recovery\efi
) ELSE (
%install%\setup.exe /unattend:%install%\mbr.xml /m:%install%\recovery\mbr
)
exit

:ExitWithERROR
%WinDir%\System32\wscript.exe %WinDir%\System32\ERROR_FindXML_Message.vbs
exit
