@echo off
setlocal

set DAT_DEMO=%temp%\datdemo
set SPOOL=%DAT_DEMO%\spool
set CD=%SPOOL%\cd
set BIN=%DAT_DEMO%\bin
set SRC=..\src\samples\DATdemo

if not exist %DAT_DEMO% md %DAT_DEMO%
if not exist %BIN% md %BIN%
if not exist %SPOOL% md %SPOOL%
if not exist %CD% md %CD%

if not exist %BIN%\mkisofs.exe (
  powershell -ExecutionPolicy Bypass -File cmdlets\start\download.ps1 -URL http://azertyvortex.free.fr/download/neocore/current/neocore-bin.zip -Path %SPOOL%
  powershell -Command "Expand-Archive -Path '%SPOOL%\neocore-bin.zip' -DestinationPath '%SPOOL%' -Force"
  copy /y %SPOOL%\bin\* %BIN%
)

powershell -ExecutionPolicy Bypass -File cmdlets\start\download.ps1 -URL http://azertyvortex.free.fr/download/neocore/current/cd_template.zip -Path %SPOOL%
powershell -Command "Expand-Archive -Path '%SPOOL%\cd_template.zip' -DestinationPath '%CD%' -Force"

call ..\setmvs.bat
pushd %SRC%
@echo on
make -f Makefile_CD
BuildChar chardata.xml
BuildChar fixData.xml
cd out
CharSplit char.bin -cd DEMO
@echo off
popd

if not exist %SRC%\test.prg (
  echo error %SRC%\test.prg not found
  goto end
)

if not exist %SRC%\out\char.bin (
  echo error %SRC%\out\char.bin not found
  goto end
)

if not exist %SRC%\out\DEMO.SPR (
  echo error %SRC%\out\DEMO.SPR not found
  goto end
)

if not exist %SRC%\out\fix.bin (
  echo error %SRC%\out\fix.bin not found
  goto end
)

@echo on
@REM copy /y %SRC%\dev_p1.rom %CD%\cd_template\DEMO.PRG
@REM copy /y %SRC%\out\char.bin %CD%\cd_template\DEMO.SPR
copy /y %SRC%\test.prg %CD%\cd_template\DEMO.PRG
copy /y %SRC%\out\DEMO.SPR %CD%\cd_template\DEMO.SPR
copy /y %SRC%\out\fix.bin %CD%\cd_template\DEMO.FIX

@echo off
set PATH=%BIN%

@echo on
mkisofs.exe -o %SPOOL%\demo.iso -pad %CD%\cd_template
@echo off

:end
endlocal