@echo off
rem Created by Artem Boldariev <artem.boldarev@gmail.com>, 2018.
rem
rem This file is distributed under the terms of CC0 license (Public Domain).
rem See the 'LICENSE.txt' file for the additional details.


rem configuration Variables
set InstallerName=emacs-installer.msi

set GeneratedWXSFiles=.\installer\Emacs.wxs
set InstallerFiles= %GeneratedWXSFiles% .\installer\Features.wxs .\installer\ContextMenu.wxs .\installer\EnvVars.wxs .\installer\Shortcuts.wxs .\installer\Main.wxs
set InstallerObjectFiles= .\installer\Emacs.wixobj .\installer\Features.wixobj .\installer\ContextMenu.wixobj .\installer\EnvVars.wixobj .\installer\Shortcuts.wixobj .\installer\Main.wixobj

set HeatOptions=-gg -srd -scom -sreg -sfrag -ke -dr APPLICATIONFOLDER  -t .\installer\heat-postprocess.xsl
set WixExtensions=-ext WixUIExtension -ext WixUtilExtension

rem set old current directory
set OldDir=%cd%


rem Build the installers

rem per-machine
CALL :gen_version_per_machine
CALL :build_the_installer
CALL :rename_per_machine_installer

rem per-user
CALL :gen_version_per_user
CALL :build_the_installer
CALL :rename_per_user_installer

EXIT /B 0

rem procedure to build the installer
:build_the_installer
cd "%~dp0\"

rem Cleanup
if exist %InstallerName% del %InstallerName%
del %GeneratedWXSFiles%
del %InstallerObjectFiles%

rem convert TXT license to RTF
.\emacs\bin\emacs.exe -Q --batch -l .\scripts\license-to-rtf.el

rem Generate fragments.
rem These should be synchronised with values in 'Config.wxi'

rem Emacs binaries
xcopy /h .\emacs\.empty .\
del /a .\emacs\.empty
"%WIX%\bin\heat" dir .\emacs -cg EmacsData -var var.EmacsDirectoryPath -out .\installer\Emacs.wxs %HeatOptions%
xcopy /h .\.empty .\emacs\
del /a .empty

rem build the installer
"%WIX%\bin\candle" %WiXExtensions% -out .\installer\ %InstallerFiles%
"%WIX%\bin\light" %WiXExtensions% -sw1076 -dcl:high -cultures:en-US %InstallerObjectFiles% -out %InstallerName%

rem change current directory
cd "%OldDir%"

rem end of procedure
EXIT /B 0

:rename_per_machine_installer
cd "%~dp0\"
rem rename Emacs installer binary
.\emacs\bin\emacs.exe -Q --batch -l .\scripts\rename-installer.el --eval "(rename-installer)"
cd "%OldDir%"
EXIT /B 0

:rename_per_user_installer
cd "%~dp0\"
rem rename Emacs installer binary
.\emacs\bin\emacs.exe -Q --batch -l .\scripts\rename-installer.el --eval "(rename-installer t)"
cd "%OldDir%"
EXIT /B 0

:gen_version_per_machine
cd "%~dp0\"
rem Generate file with build version information
.\emacs\bin\emacs.exe -Q --batch -l .\scripts\generate-version-wxi.el --eval "(generate-version-per-machine)"
cd "%OldDir%"
EXIT /B 0

:gen_version_per_user
cd "%~dp0\"
rem Generate file with build version information
.\emacs\bin\emacs.exe -Q --batch -l .\scripts\generate-version-wxi.el --eval "(generate-version-per-user)"
cd "%OldDir%"
EXIT /B 0



