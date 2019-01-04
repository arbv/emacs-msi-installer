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

set HeatOptions=-gg -srd -scom -sreg -sfrag -ke -dr INSTALLDIR  -t .\installer\heat-postprocess.xsl
set WixExtensions=-ext WixUIExtension -ext WixUtilExtension

rem set old current directory
set OldDir=%cd%
cd "%~dp0\"

rem Cleanup
if exist %InstallerName% del %InstallerName%
del %GeneratedWXSFiles%
del %InstallerObjectFiles%

rem convert TXT license to RTF
.\emacs\bin\emacs.exe -Q --batch -l .\scripts\license-to-rtf.el

rem Generate file with build version information
.\emacs\bin\emacs.exe -Q --batch -l .\scripts\generate-version-wxi.el

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
"%WIX%\bin\light" %WiXExtensions% -sw1076 -sice:ICE57 -dcl:high -cultures:en-US %InstallerObjectFiles% -out %InstallerName%

rem rename Emacs installer binary
.\emacs\bin\emacs.exe -Q --batch -l .\scripts\rename-installer.el

rem change current directory
cd "%OldDir%"
