@echo off
setlocal
set DAT_DEMO=%temp%\datdemo
set MAME_PATH=%DAT_DEMO%\mame

if not exist %MAME_PATH% (
  echo error %MAME_PATH% not found
  goto end
)

if not exist %MAME_PATH%\roms\neogeo\datdemo (
  echo error %MAME_PATH%\roms\neogeo\datdemo not found
  goto end
)

pushd %MAME_PATH%
@echo on
mame64 neogeo -cart1 datdemo
@echo off
popd

:end
endlocal