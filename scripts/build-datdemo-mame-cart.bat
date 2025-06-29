@echo off
setlocal
set DAT_DEMO=%temp%\datdemo
set SPOOL=%DAT_DEMO%\spool
set DAT_DEMO_ROM=%SPOOL%\rom
set SRC=..\src\samples\DATdemo
set DAT_DEMO_ZIP=..\src\samples\DATdemo_rom\DATdemo.zip
set MAME_PATH=%DAT_DEMO%\mame

if not exist %DAT_DEMO_ZIP% (
  echo error %DAT_DEMO_ZIP% not found
  goto end
)

if not exist %DAT_DEMO% md %DAT_DEMO%
if not exist %SPOOL% md %SPOOL%
if not exist %DAT_DEMO_ROM% md %DAT_DEMO_ROM%

if not exist %MAME_PATH% (
  echo install mame
  powershell -ExecutionPolicy Bypass -File cmdlets\start\download.ps1 -URL http://azertyvortex.free.fr/download/neocore/current/mame.zip -Path %SPOOL%
  powershell -Command "Expand-Archive -Path '%SPOOL%\mame.zip' -DestinationPath '%DAT_DEMO%' -Force"

  echo install neogeo bios
  if not exist %MAME_PATH%\roms\neogeo md %MAME_PATH%\roms\neogeo
  powershell -ExecutionPolicy Bypass -File cmdlets\start\download.ps1 -URL http://azertyvortex.free.fr/download/neocore/neogeo-bios-r0.zip -Path %SPOOL%
  powershell -Command "Expand-Archive -Path '%SPOOL%\neogeo-bios-r0.zip' -DestinationPath '%MAME_PATH%\roms\neogeo' -Force"
)

if not exist %MAME_PATH%\roms\neogeo\datdemo md %MAME_PATH%\roms\neogeo\datdemo

powershell -Command "Expand-Archive -Path '%DAT_DEMO_ZIP%' -DestinationPath '%DAT_DEMO_ROM%' -Force"

call ..\setmvs.bat

pushd %SRC%
@echo on
make
BuildChar chardata.xml
BuildChar fixData.xml
@echo off
popd

if not exist %SRC%\dev_p1.rom (
  echo error %SRC%\dev_p1.rom not found
  goto end
)

if not exist %SRC%\out\char.bin (
  echo error %SRC%\out\char.bin not found
  goto end
)

if not exist %SRC%\out\fix.bin (
  echo error %SRC%\out\fix.bin not found
  goto end
)

if not exist %DAT_DEMO_ROM%\demo-m1.bin (
  echo error %DAT_DEMO_ROM%\demo-m1.bin not found
  goto end
)

if not exist %DAT_DEMO_ROM%\demo-v1.bin (
  echo error %DAT_DEMO_ROM%\demo-v1.bin not found
  goto end
)

@echo on
copy /y %SRC%\dev_p1.rom %MAME_PATH%\roms\neogeo\datdemo\
copy /y %SRC%\out\char.bin %MAME_PATH%\roms\neogeo\datdemo\
copy /y %SRC%\out\fix.bin %MAME_PATH%\roms\neogeo\datdemo\
copy /y %DAT_DEMO_ROM%\demo-m1.bin %MAME_PATH%\roms\neogeo\datdemo\m1.rom
copy /y %DAT_DEMO_ROM%\demo-v1.bin %MAME_PATH%\roms\neogeo\datdemo\v1.rom
copy /y mame\hash\neogeo.xml %MAME_PATH%\hash
@echo off

:end
rd /s /q %SPOOL%
endlocal