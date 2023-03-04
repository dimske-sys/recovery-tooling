@ECHO OFF
pushd "%~dp0"

IF EXIST C:\Recovery\OEM\Find.Me GOTO END
Recovery.exe -s -dC:\Recovery
ATTRIB -S -R -H C:\Recovery
ATTRIB -S -R -H C:\Recovery /S
icacls C:\Recovery /reset /T /C
icacls C:\Recovery /inheritance:r /grant:r SYSTEM:(OI)(CI)(F) /grant:r *S-1-5-32-544:(OI)(CI)(F) /grant:r *S-1-5-32-545:(OI)(CI)(RX) /C
ATTRIB +S +H C:\Recovery

:END
cd /d "%SystemRoot%\Setup\"
if not exist "%SystemRoot%\Setup\Scripts\SetupComplete.cmd" @RD /S /Q "%SystemRoot%\Setup\Scripts\"
exit